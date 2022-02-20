Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C244BCE25
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 12:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiBTL2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 06:28:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiBTL2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 06:28:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F275E22BC9
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 03:27:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BB7AB80CDD
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 11:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E40C340E8;
        Sun, 20 Feb 2022 11:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645356471;
        bh=D3gCdnQMwr9FpP6TiD44yXqP/33K32VcpT83Mhm4/i8=;
        h=Subject:To:Cc:From:Date:From;
        b=rcJA/B2dWfzjMej24tMtrdR5ESpaKItnk0+iKNOwXW9AEZ5eaEdxHB5lGUb1tNj/i
         h58ii+tc7ltShly96OtiujY/PdHNcO0Tu98wxGzSpSdGU3dWns83lq2nJJCBkLKc/L
         a4/aCq/Fxh6f+Ar36XG++b+xTtuoD2wyi9EsYOc8=
Subject: FAILED: patch "[PATCH] cifs: fix confusing unneeded warning message on smb2.1 and" failed to apply to 5.15-stable tree
To:     stfrench@microsoft.com, kim@scarborough.kim, pc@cjr.nz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 20 Feb 2022 12:27:49 +0100
Message-ID: <1645356469197169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 53923e0fe2098f90f339510aeaa0e1413ae99a16 Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Wed, 16 Feb 2022 13:23:53 -0600
Subject: [PATCH] cifs: fix confusing unneeded warning message on smb2.1 and
 earlier

When mounting with SMB2.1 or earlier, even with nomultichannel, we
log the confusing warning message:
  "CIFS: VFS: multichannel is not supported on this protocol version, use 3.0 or above"

Fix this so that we don't log this unless they really are trying
to mount with multichannel.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215608
Reported-by: Kim Scarborough <kim@scarborough.kim>
Cc: stable@vger.kernel.org # 5.11+
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 5723d50340e5..32f478c7a66d 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -127,11 +127,6 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 	struct cifs_server_iface *ifaces = NULL;
 	size_t iface_count;
 
-	if (ses->server->dialect < SMB30_PROT_ID) {
-		cifs_dbg(VFS, "multichannel is not supported on this protocol version, use 3.0 or above\n");
-		return 0;
-	}
-
 	spin_lock(&ses->chan_lock);
 
 	new_chan_count = old_chan_count = ses->chan_count;
@@ -145,6 +140,12 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 		return 0;
 	}
 
+	if (ses->server->dialect < SMB30_PROT_ID) {
+		spin_unlock(&ses->chan_lock);
+		cifs_dbg(VFS, "multichannel is not supported on this protocol version, use 3.0 or above\n");
+		return 0;
+	}
+
 	if (!(ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
 		ses->chan_max = 1;
 		spin_unlock(&ses->chan_lock);

