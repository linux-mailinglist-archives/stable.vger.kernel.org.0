Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F92C6213CE
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbiKHNyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbiKHNyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:54:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CF917E1E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:54:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7B366CE1B95
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA8BC433D6;
        Tue,  8 Nov 2022 13:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915638;
        bh=inE6oPua0lGt46slRq7uMbEBSIvGcezObdGuYc49+zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfEV8FCE5L3jbZNTvagMxNDQ/nL2durUy7KUWIGKPZUUSX+IN7cBnVNz1XTD2qa1C
         LdqJ+k+kFrG/RQtMKyW5SKmkUO/a3fQKwWZ0ewi9SMea8Avif3vVFggmDmdWHhAZFj
         Z5I2Meq0R2SJNSwRhJXXlrUxGmpz/yYPf8FCF4jI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/118] nfs4: Fix kmemleak when allocate slot failed
Date:   Tue,  8 Nov 2022 14:38:16 +0100
Message-Id: <20221108133341.469062581@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,WEIRD_QUOTING autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 7e8436728e22181c3f12a5dbabd35ed3a8b8c593 ]

If one of the slot allocate failed, should cleanup all the other
allocated slots, otherwise, the allocated slots will leak:

  unreferenced object 0xffff8881115aa100 (size 64):
    comm ""mount.nfs"", pid 679, jiffies 4294744957 (age 115.037s)
    hex dump (first 32 bytes):
      00 cc 19 73 81 88 ff ff 00 a0 5a 11 81 88 ff ff  ...s......Z.....
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<000000007a4c434a>] nfs4_find_or_create_slot+0x8e/0x130
      [<000000005472a39c>] nfs4_realloc_slot_table+0x23f/0x270
      [<00000000cd8ca0eb>] nfs40_init_client+0x4a/0x90
      [<00000000128486db>] nfs4_init_client+0xce/0x270
      [<000000008d2cacad>] nfs4_set_client+0x1a2/0x2b0
      [<000000000e593b52>] nfs4_create_server+0x300/0x5f0
      [<00000000e4425dd2>] nfs4_try_get_tree+0x65/0x110
      [<00000000d3a6176f>] vfs_get_tree+0x41/0xf0
      [<0000000016b5ad4c>] path_mount+0x9b3/0xdd0
      [<00000000494cae71>] __x64_sys_mount+0x190/0x1d0
      [<000000005d56bdec>] do_syscall_64+0x35/0x80
      [<00000000687c9ae4>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: abf79bb341bf ("NFS: Add a slot table to struct nfs_client for NFSv4.0 transport blocking")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 0e6437b08a3a..252c99c76a42 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -346,6 +346,7 @@ int nfs40_init_client(struct nfs_client *clp)
 	ret = nfs4_setup_slot_table(tbl, NFS4_MAX_SLOT_TABLE,
 					"NFSv4.0 transport Slot table");
 	if (ret) {
+		nfs4_shutdown_slot_table(tbl);
 		kfree(tbl);
 		return ret;
 	}
-- 
2.35.1



