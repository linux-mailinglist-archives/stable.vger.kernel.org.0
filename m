Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52578621442
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbiKHN7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbiKHN7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:59:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8780E528A4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:59:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 242B5615A8
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36309C433C1;
        Tue,  8 Nov 2022 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915954;
        bh=SVP1nAfYHn4WWA0rZ7CSp3klERGXBB5zUfe8bWjtkLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r97a+YCsxr1XGJt2JvNqaRowCtNO+bGovn3K8ArWuRhSvlmHDwcx+q9KMjtICidrc
         Z5t3FBmdOXe9LE7xavgFY/v4GxRdtQ73UJ5P//QQ3m/9URuyQ+4j3iRl3hlmHn4Nf5
         mqvwxrBB61XP7tEC4oLpUEON4OANVy2QNu4pDM+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/144] SUNRPC: Fix null-ptr-deref when xps sysfs alloc failed
Date:   Tue,  8 Nov 2022 14:38:18 +0100
Message-Id: <20221108133346.193558629@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit cbdeaee94a415800c65a8c3fa04d9664a8b8fb3a ]

There is a null-ptr-deref when xps sysfs alloc failed:
  BUG: KASAN: null-ptr-deref in sysfs_do_create_link_sd+0x40/0xd0
  Read of size 8 at addr 0000000000000030 by task gssproxy/457

  CPU: 5 PID: 457 Comm: gssproxy Not tainted 6.0.0-09040-g02357b27ee03 #9
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   kasan_report+0xa3/0x120
   sysfs_do_create_link_sd+0x40/0xd0
   rpc_sysfs_client_setup+0x161/0x1b0
   rpc_new_client+0x3fc/0x6e0
   rpc_create_xprt+0x71/0x220
   rpc_create+0x1d4/0x350
   gssp_rpc_create+0xc3/0x160
   set_gssp_clnt+0xbc/0x140
   write_gssp+0x116/0x1a0
   proc_reg_write+0xd6/0x130
   vfs_write+0x177/0x690
   ksys_write+0xb9/0x150
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0

When the xprt_switch sysfs alloc failed, should not add xprt and
switch sysfs to it, otherwise, maybe null-ptr-deref; also initialize
the 'xps_sysfs' to NULL to avoid oops when destroy it.

Fixes: 2a338a543163 ("sunrpc: add a symlink from rpc-client directory to the xprt_switch")
Fixes: d408ebe04ac5 ("sunrpc: add add sysfs directory per xprt under each xprt_switch")
Fixes: baea99445dd4 ("sunrpc: add xprt_switch direcotry to sunrpc's sysfs")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sysfs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index a7020b1f3ec7..55da1b627a7d 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -525,13 +525,16 @@ void rpc_sysfs_client_setup(struct rpc_clnt *clnt,
 			    struct net *net)
 {
 	struct rpc_sysfs_client *rpc_client;
+	struct rpc_sysfs_xprt_switch *xswitch =
+		(struct rpc_sysfs_xprt_switch *)xprt_switch->xps_sysfs;
+
+	if (!xswitch)
+		return;
 
 	rpc_client = rpc_sysfs_client_alloc(rpc_sunrpc_client_kobj,
 					    net, clnt->cl_clid);
 	if (rpc_client) {
 		char name[] = "switch";
-		struct rpc_sysfs_xprt_switch *xswitch =
-			(struct rpc_sysfs_xprt_switch *)xprt_switch->xps_sysfs;
 		int ret;
 
 		clnt->cl_sysfs = rpc_client;
@@ -565,6 +568,8 @@ void rpc_sysfs_xprt_switch_setup(struct rpc_xprt_switch *xprt_switch,
 		rpc_xprt_switch->xprt_switch = xprt_switch;
 		rpc_xprt_switch->xprt = xprt;
 		kobject_uevent(&rpc_xprt_switch->kobject, KOBJ_ADD);
+	} else {
+		xprt_switch->xps_sysfs = NULL;
 	}
 }
 
@@ -576,6 +581,9 @@ void rpc_sysfs_xprt_setup(struct rpc_xprt_switch *xprt_switch,
 	struct rpc_sysfs_xprt_switch *switch_obj =
 		(struct rpc_sysfs_xprt_switch *)xprt_switch->xps_sysfs;
 
+	if (!switch_obj)
+		return;
+
 	rpc_xprt = rpc_sysfs_xprt_alloc(&switch_obj->kobject, xprt, gfp_flags);
 	if (rpc_xprt) {
 		xprt->xprt_sysfs = rpc_xprt;
-- 
2.35.1



