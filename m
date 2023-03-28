Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612326CC332
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbjC1OwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbjC1Ovt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:51:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6779DBEA
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:51:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34C41B81D6E
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D12C433D2;
        Tue, 28 Mar 2023 14:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015093;
        bh=bhLU6mwpDf4aty68f90LQgPlMyE8nF2YZdFvGqe6Qos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1NLFxRxFVWmQWAJ28CCRyjRcjsu3wA8U6pP8H+CDXtmcBv1QQHG88xpKgMQo4aCf
         Zx1mT+tsmYa981EFKh5KutUWuvdb/6OTDzAJaHkkHVOlnsDFAazENoC+dZZItQqUNE
         ZJww2gTW22J8io+lX1oetolUOa6w8Zlk0dhGuEp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 162/240] cifs: lock chan_lock outside match_session
Date:   Tue, 28 Mar 2023 16:42:05 +0200
Message-Id: <20230328142626.430679137@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit 2f4e429c846972c8405951a9ff7a82aceeca7461 upstream.

Coverity had rightly indicated a possible deadlock
due to chan_lock being done inside match_session.
All callers of match_* functions should pick up the
necessary locks and call them.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Fixes: 724244cdb382 ("cifs: protect session channel fields with chan_lock")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1770,7 +1770,7 @@ out_err:
 	return ERR_PTR(rc);
 }
 
-/* this function must be called with ses_lock held */
+/* this function must be called with ses_lock and chan_lock held */
 static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
 	if (ctx->sectype != Unspecified &&
@@ -1781,12 +1781,8 @@ static int match_session(struct cifs_ses
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
@@ -1914,10 +1910,13 @@ cifs_find_smb_ses(struct TCP_Server_Info
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
@@ -2743,6 +2742,7 @@ cifs_match_super(struct super_block *sb,
 
 	spin_lock(&tcp_srv->srv_lock);
 	spin_lock(&ses->ses_lock);
+	spin_lock(&ses->chan_lock);
 	spin_lock(&tcon->tc_lock);
 	if (!match_server(tcp_srv, ctx, dfs_super_cmp) ||
 	    !match_session(ses, ctx) ||
@@ -2755,6 +2755,7 @@ cifs_match_super(struct super_block *sb,
 	rc = compare_mount_options(sb, mnt_data);
 out:
 	spin_unlock(&tcon->tc_lock);
+	spin_unlock(&ses->chan_lock);
 	spin_unlock(&ses->ses_lock);
 	spin_unlock(&tcp_srv->srv_lock);
 


