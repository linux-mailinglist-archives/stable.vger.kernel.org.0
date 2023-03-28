Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263F46CBDE7
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjC1LgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjC1LgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 07:36:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E8E5FFD
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 04:36:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C81BE616DF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 11:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2ECC433D2;
        Tue, 28 Mar 2023 11:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003365;
        bh=vhFM6Hh3XNquo2a05qkYfZ1C6roQCct72nJBydLGucQ=;
        h=Subject:To:Cc:From:Date:From;
        b=N8hM7a/M3z3ZqpyCqZRhRhal97uq42BvO9f3aepZg6i3vD8hSnvCKus499Q0dPzsx
         ZGaEmSLcQGMus+cxaFCm8130oJqDXEwWjViDCn5Ti+YLv1UWL7lreP2Jr0gcZl1frj
         S0AICvfLTAGhdLr/CtDSiUSF5gwiM2oBOg3Ki9ZA=
Subject: FAILED: patch "[PATCH] cifs: lock chan_lock outside match_session" failed to apply to 5.15-stable tree
To:     sprasad@microsoft.com, pc@manguebit.com, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:35:40 +0200
Message-ID: <1680003340205249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 2f4e429c846972c8405951a9ff7a82aceeca7461
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1680003340205249@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

2f4e429c8469 ("cifs: lock chan_lock outside match_session")
d7d7a66aacd6 ("cifs: avoid use of global locks for high contention data")
9543c8ab3016 ("cifs: list_for_each() -> list_for_each_entry()")
af3a6d1018f0 ("cifs: update cifs_ses::ip_addr after failover")
b54034a73baf ("cifs: during reconnect, update interface if necessary")
cc391b694ff0 ("cifs: fix potential deadlock in direct reclaim")
5752bf645f9d ("cifs: avoid parallel session setups on same channel")
dd3cd8709ed5 ("cifs: use new enum for ses_status")
1a6a41d4cedd ("cifs: do not use tcpStatus after negotiate completes")
cd70a3e8988a ("cifs: use correct lock type in cifs_reconnect()")
fb39d30e2272 ("cifs: force new session setup and tcon for dfs")
9a005bea4f59 ("Merge tag '5.18-smb3-fixes-part2' of git://git.samba.org/sfrench/cifs-2.6")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2f4e429c846972c8405951a9ff7a82aceeca7461 Mon Sep 17 00:00:00 2001
From: Shyam Prasad N <sprasad@microsoft.com>
Date: Mon, 20 Feb 2023 13:02:11 +0000
Subject: [PATCH] cifs: lock chan_lock outside match_session

Coverity had rightly indicated a possible deadlock
due to chan_lock being done inside match_session.
All callers of match_* functions should pick up the
necessary locks and call them.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Fixes: 724244cdb382 ("cifs: protect session channel fields with chan_lock")
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 49b37594e991..f42cc7077312 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1721,7 +1721,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	return ERR_PTR(rc);
 }
 
-/* this function must be called with ses_lock held */
+/* this function must be called with ses_lock and chan_lock held */
 static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
 	if (ctx->sectype != Unspecified &&
@@ -1732,12 +1732,8 @@ static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	 * If an existing session is limited to less channels than
 	 * requested, it should not be reused
 	 */
-	spin_lock(&ses->chan_lock);
-	if (ses->chan_max < ctx->max_channels) {
-		spin_unlock(&ses->chan_lock);
+	if (ses->chan_max < ctx->max_channels)
 		return 0;
-	}
-	spin_unlock(&ses->chan_lock);
 
 	switch (ses->sectype) {
 	case Kerberos:
@@ -1865,10 +1861,13 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 			spin_unlock(&ses->ses_lock);
 			continue;
 		}
+		spin_lock(&ses->chan_lock);
 		if (!match_session(ses, ctx)) {
+			spin_unlock(&ses->chan_lock);
 			spin_unlock(&ses->ses_lock);
 			continue;
 		}
+		spin_unlock(&ses->chan_lock);
 		spin_unlock(&ses->ses_lock);
 
 		++ses->ses_count;
@@ -2693,6 +2692,7 @@ cifs_match_super(struct super_block *sb, void *data)
 
 	spin_lock(&tcp_srv->srv_lock);
 	spin_lock(&ses->ses_lock);
+	spin_lock(&ses->chan_lock);
 	spin_lock(&tcon->tc_lock);
 	if (!match_server(tcp_srv, ctx, dfs_super_cmp) ||
 	    !match_session(ses, ctx) ||
@@ -2705,6 +2705,7 @@ cifs_match_super(struct super_block *sb, void *data)
 	rc = compare_mount_options(sb, mnt_data);
 out:
 	spin_unlock(&tcon->tc_lock);
+	spin_unlock(&ses->chan_lock);
 	spin_unlock(&ses->ses_lock);
 	spin_unlock(&tcp_srv->srv_lock);
 

