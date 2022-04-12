Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5771E4FD014
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbiDLGlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349045AbiDLGkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:40:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2459E0EB;
        Mon, 11 Apr 2022 23:36:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AD12B81B29;
        Tue, 12 Apr 2022 06:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A84C385A6;
        Tue, 12 Apr 2022 06:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745360;
        bh=GYkMMH33gop5fdJ0SczhyS7N+fbjH7M69y+vrEGQO+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqKIPpJi+w8KIgEjPT7rF9d9fot61evQP0Oc2V9e9T8z6NAVX7FAC8B74a39ygmaA
         CuNz+h8sI3RbWAUqz7jcty+T53mhaDDt1zpA1Q6fUIGGkv6zsJ6gVIZ0sIQT3afmTO
         awApIc4siWjLH4lHRMEK5IiPjhGf7x7nK3U5VmsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/171] netlabel: fix out-of-bounds memory accesses
Date:   Tue, 12 Apr 2022 08:29:19 +0200
Message-Id: <20220412062929.851142253@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit f22881de730ebd472e15bcc2c0d1d46e36a87b9c ]

In calipso_map_cat_ntoh(), in the for loop, if the return value of
netlbl_bitmap_walk() is equal to (net_clen_bits - 1), when
netlbl_bitmap_walk() is called next time, out-of-bounds memory accesses
of bitmap[byte_offset] occurs.

The bug was found during fuzzing. The following is the fuzzing report
 BUG: KASAN: slab-out-of-bounds in netlbl_bitmap_walk+0x3c/0xd0
 Read of size 1 at addr ffffff8107bf6f70 by task err_OH/252

 CPU: 7 PID: 252 Comm: err_OH Not tainted 5.17.0-rc7+ #17
 Hardware name: linux,dummy-virt (DT)
 Call trace:
  dump_backtrace+0x21c/0x230
  show_stack+0x1c/0x60
  dump_stack_lvl+0x64/0x7c
  print_address_description.constprop.0+0x70/0x2d0
  __kasan_report+0x158/0x16c
  kasan_report+0x74/0x120
  __asan_load1+0x80/0xa0
  netlbl_bitmap_walk+0x3c/0xd0
  calipso_opt_getattr+0x1a8/0x230
  calipso_sock_getattr+0x218/0x340
  calipso_sock_getattr+0x44/0x60
  netlbl_sock_getattr+0x44/0x80
  selinux_netlbl_socket_setsockopt+0x138/0x170
  selinux_socket_setsockopt+0x4c/0x60
  security_socket_setsockopt+0x4c/0x90
  __sys_setsockopt+0xbc/0x2b0
  __arm64_sys_setsockopt+0x6c/0x84
  invoke_syscall+0x64/0x190
  el0_svc_common.constprop.0+0x88/0x200
  do_el0_svc+0x88/0xa0
  el0_svc+0x128/0x1b0
  el0t_64_sync_handler+0x9c/0x120
  el0t_64_sync+0x16c/0x170

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_kapi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 5e1239cef000..91b35b7c80d8 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -885,6 +885,8 @@ int netlbl_bitmap_walk(const unsigned char *bitmap, u32 bitmap_len,
 	unsigned char bitmask;
 	unsigned char byte;
 
+	if (offset >= bitmap_len)
+		return -1;
 	byte_offset = offset / 8;
 	byte = bitmap[byte_offset];
 	bit_spot = offset;
-- 
2.35.1



