Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AE54C7474
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbiB1RpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238967AbiB1Rnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:43:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D9B954BB;
        Mon, 28 Feb 2022 09:35:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BD79614B9;
        Mon, 28 Feb 2022 17:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533A8C340E7;
        Mon, 28 Feb 2022 17:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069726;
        bh=VmStJ6T+OyAkIxE+FbIqLnB7hnpBeUANqtODQkwTNfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4IPsyVfhut9/scPEEE3HCFAJ2kMU08OcKuqC79Afyo3HqDN/kd/lOZkCIzYflKEj
         nzzd+eaiqC09/NgfTRQa5anrzgN23RqfTHEHAObYUoOu3EOsgLjx+3IhbS7tKqtgQw
         Ro3ZwJ7u6XZGM3caL5Mrn5u20FfpQROXGI804Lxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c94a3675a626f6333d74@syzkaller.appspotmail.com,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 71/80] RDMA/cma: Do not change route.addr.src_addr outside state checks
Date:   Mon, 28 Feb 2022 18:24:52 +0100
Message-Id: <20220228172320.302966455@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit 22e9f71072fa605cbf033158db58e0790101928d upstream.

If the state is not idle then resolve_prepare_src() should immediately
fail and no change to global state should happen. However, it
unconditionally overwrites the src_addr trying to build a temporary any
address.

For instance if the state is already RDMA_CM_LISTEN then this will corrupt
the src_addr and would cause the test in cma_cancel_operation():

           if (cma_any_addr(cma_src_addr(id_priv)) && !id_priv->cma_dev)

Which would manifest as this trace from syzkaller:

  BUG: KASAN: use-after-free in __list_add_valid+0x93/0xa0 lib/list_debug.c:26
  Read of size 8 at addr ffff8881546491e0 by task syz-executor.1/32204

  CPU: 1 PID: 32204 Comm: syz-executor.1 Not tainted 5.12.0-rc8-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Call Trace:
   __dump_stack lib/dump_stack.c:79 [inline]
   dump_stack+0x141/0x1d7 lib/dump_stack.c:120
   print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
   __kasan_report mm/kasan/report.c:399 [inline]
   kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
   __list_add_valid+0x93/0xa0 lib/list_debug.c:26
   __list_add include/linux/list.h:67 [inline]
   list_add_tail include/linux/list.h:100 [inline]
   cma_listen_on_all drivers/infiniband/core/cma.c:2557 [inline]
   rdma_listen+0x787/0xe00 drivers/infiniband/core/cma.c:3751
   ucma_listen+0x16a/0x210 drivers/infiniband/core/ucma.c:1102
   ucma_write+0x259/0x350 drivers/infiniband/core/ucma.c:1732
   vfs_write+0x28e/0xa30 fs/read_write.c:603
   ksys_write+0x1ee/0x250 fs/read_write.c:658
   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xae

This is indicating that an rdma_id_private was destroyed without doing
cma_cancel_listens().

Instead of trying to re-use the src_addr memory to indirectly create an
any address derived from the dst build one explicitly on the stack and
bind to that as any other normal flow would do. rdma_bind_addr() will copy
it over the src_addr once it knows the state is valid.

This is similar to commit bc0bdc5afaa7 ("RDMA/cma: Do not change
route.addr.src_addr.ss_family")

Link: https://lore.kernel.org/r/0-v2-e975c8fd9ef2+11e-syz_cma_srcaddr_jgg@nvidia.com
Cc: stable@vger.kernel.org
Fixes: 732d41c545bb ("RDMA/cma: Make the locking for automatic state transition more clear")
Reported-by: syzbot+c94a3675a626f6333d74@syzkaller.appspotmail.com
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/cma.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3321,22 +3321,30 @@ err:
 static int cma_bind_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 			 const struct sockaddr *dst_addr)
 {
-	if (!src_addr || !src_addr->sa_family) {
-		src_addr = (struct sockaddr *) &id->route.addr.src_addr;
-		src_addr->sa_family = dst_addr->sa_family;
-		if (IS_ENABLED(CONFIG_IPV6) &&
-		    dst_addr->sa_family == AF_INET6) {
-			struct sockaddr_in6 *src_addr6 = (struct sockaddr_in6 *) src_addr;
-			struct sockaddr_in6 *dst_addr6 = (struct sockaddr_in6 *) dst_addr;
-			src_addr6->sin6_scope_id = dst_addr6->sin6_scope_id;
-			if (ipv6_addr_type(&dst_addr6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
-				id->route.addr.dev_addr.bound_dev_if = dst_addr6->sin6_scope_id;
-		} else if (dst_addr->sa_family == AF_IB) {
-			((struct sockaddr_ib *) src_addr)->sib_pkey =
-				((struct sockaddr_ib *) dst_addr)->sib_pkey;
-		}
+	struct sockaddr_storage zero_sock = {};
+
+	if (src_addr && src_addr->sa_family)
+		return rdma_bind_addr(id, src_addr);
+
+	/*
+	 * When the src_addr is not specified, automatically supply an any addr
+	 */
+	zero_sock.ss_family = dst_addr->sa_family;
+	if (IS_ENABLED(CONFIG_IPV6) && dst_addr->sa_family == AF_INET6) {
+		struct sockaddr_in6 *src_addr6 =
+			(struct sockaddr_in6 *)&zero_sock;
+		struct sockaddr_in6 *dst_addr6 =
+			(struct sockaddr_in6 *)dst_addr;
+
+		src_addr6->sin6_scope_id = dst_addr6->sin6_scope_id;
+		if (ipv6_addr_type(&dst_addr6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
+			id->route.addr.dev_addr.bound_dev_if =
+				dst_addr6->sin6_scope_id;
+	} else if (dst_addr->sa_family == AF_IB) {
+		((struct sockaddr_ib *)&zero_sock)->sib_pkey =
+			((struct sockaddr_ib *)dst_addr)->sib_pkey;
 	}
-	return rdma_bind_addr(id, src_addr);
+	return rdma_bind_addr(id, (struct sockaddr *)&zero_sock);
 }
 
 /*


