Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E26C12602F
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 11:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfLSK6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 05:58:41 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49489 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726681AbfLSK6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 05:58:41 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3AFDE223F1;
        Thu, 19 Dec 2019 05:58:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 19 Dec 2019 05:58:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=0NuXtu
        SBazIFJsABlGo3wuWVIMOKbiW787HxOafYbAA=; b=SXvFU3qGjJsepFFwC2d8P7
        RZkWcHN+970Mb8D6qSlx2NGSp2qrIwJll9a2KjbuGLnoXLvfXUnYRs2y8SPQUrCI
        0CfQWcZ18PbAwA2YB+mdLRA3VIFhc3JnBJXjcTJwTWt5pCQ+UXn3BAac7kIHEYeZ
        w5SzB3J/5XLcqryN7use1ZTTAli4b+0606HlN1hOeQBGWCCAwHIvTtuBHkphy4JE
        DFlquaClXuvPHqCe2U1VQqTSEDwZY4IPbPGWpvu2ywBaat//u3aRj/LwTBCR3qSH
        Tg0dgRooCPhgOlLH5slL6CyIS9C7CybfeQQrV4/5hacstLSRg1ZATbr7HvSQmOtg
        ==
X-ME-Sender: <xms:31f7XRVR61LrLiE9TfvDkQOxfyJx2KUWUHTw9yUGjQT5cUb7kIhoHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdduuddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:31f7XYypQXG3Zq-VDncTH6xUYFhttruRZvVTVA--3iuHxCF4RbNGJQ>
    <xmx:31f7XRzvt5R-W51q1YSATAajOoKW5c2BjVAqjnLO6hMDEtCVhRs9gA>
    <xmx:31f7XdBgdmPRFicTo9gah0BexopK9jcNORBDnTCq-okNt1-e54JFcA>
    <xmx:4Ff7XZvOoKrR_bydplOhggscdwS486nb13ZpFjsYlWB9cB0txrhjuQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A74930609D4;
        Thu, 19 Dec 2019 05:58:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] cifs: Fix retrieval of DFS referrals in cifs_mount()" failed to apply to 4.19-stable tree
To:     pc@cjr.nz, matthew.ruffell@canonical.com, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 Dec 2019 11:58:38 +0100
Message-ID: <157675311816525@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5bb30a4dd60e2a10a4de9932daff23e503f1dd2b Mon Sep 17 00:00:00 2001
From: "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Date: Fri, 22 Nov 2019 12:30:56 -0300
Subject: [PATCH] cifs: Fix retrieval of DFS referrals in cifs_mount()

Make sure that DFS referrals are sent to newly resolved root targets
as in a multi tier DFS setup.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Link: https://lkml.kernel.org/r/05aa2995-e85e-0ff4-d003-5bb08bd17a22@canonical.com
Cc: stable@vger.kernel.org
Tested-by: Matthew Ruffell <matthew.ruffell@canonical.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f611163b5bc3..86d1baedf21c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4786,6 +4786,17 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb_vol *vol,
 }
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
+static inline void set_root_tcon(struct cifs_sb_info *cifs_sb,
+				 struct cifs_tcon *tcon,
+				 struct cifs_tcon **root)
+{
+	spin_lock(&cifs_tcp_ses_lock);
+	tcon->tc_count++;
+	tcon->remap = cifs_remap(cifs_sb);
+	spin_unlock(&cifs_tcp_ses_lock);
+	*root = tcon;
+}
+
 int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 {
 	int rc = 0;
@@ -4887,18 +4898,10 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 	/* Cache out resolved root server */
 	(void)dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb),
 			     root_path + 1, NULL, NULL);
-	/*
-	 * Save root tcon for additional DFS requests to update or create a new
-	 * DFS cache entry, or even perform DFS failover.
-	 */
-	spin_lock(&cifs_tcp_ses_lock);
-	tcon->tc_count++;
-	tcon->dfs_path = root_path;
+	kfree(root_path);
 	root_path = NULL;
-	tcon->remap = cifs_remap(cifs_sb);
-	spin_unlock(&cifs_tcp_ses_lock);
 
-	root_tcon = tcon;
+	set_root_tcon(cifs_sb, tcon, &root_tcon);
 
 	for (count = 1; ;) {
 		if (!rc && tcon) {
@@ -4935,6 +4938,15 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 			mount_put_conns(cifs_sb, xid, server, ses, tcon);
 			rc = mount_get_conns(vol, cifs_sb, &xid, &server, &ses,
 					     &tcon);
+			/*
+			 * Ensure that DFS referrals go through new root server.
+			 */
+			if (!rc && tcon &&
+			    (tcon->share_flags & (SHI1005_FLAGS_DFS |
+						  SHI1005_FLAGS_DFS_ROOT))) {
+				cifs_put_tcon(root_tcon);
+				set_root_tcon(cifs_sb, tcon, &root_tcon);
+			}
 		}
 		if (rc) {
 			if (rc == -EACCES || rc == -EOPNOTSUPP)

