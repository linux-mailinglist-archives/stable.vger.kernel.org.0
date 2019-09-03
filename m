Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9F8A72F6
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfICS7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:59:07 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49521 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbfICS7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:59:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4033122274;
        Tue,  3 Sep 2019 14:59:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:59:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uFPoKn
        2kaCRMFz7VygYXrNXDBwlSN6+wHdFd02On9rQ=; b=HafhcFqRGUqQKzLKIQxtoc
        bE+iC7umW1Baos5zVrk7LSLgUB0s5fbBsRSb8xLG6Rqg+wC/VU/Dcw5wkqtNVJIX
        m342l9dplHR5Hp170aqMOuh+79T2ZJiRWbSRXx/XZC7FOfV1OxeuujgMZD+Lo1mS
        kG3CWgzWLWZMxhVbgSHdSsU3Z3jS6AMSbThyiJpSIvqbaq8VGyMxAoMN0Aipzm0s
        3NmOFwnGdUOLk+U32HHxlSuY0NKzlBdQn9AsmUqUJZn3W55OSZJD6jMA9LzzlyMc
        xvS15LXMxa/hyVGufsLyGipafu3Kj+qpjROqjX0FBEOHXiV1ZFEPZn/ejxHKF8hw
        ==
X-ME-Sender: <xms:-rduXUj4jYaSTnblh4spfL7uMcX2emB1b1vUY9e4TP7OJIfSn8LIiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:-rduXR5aNCyEXLV3an2B9o-GEdQFLm82npeQaxL2sNGLfEnJ1SbxOw>
    <xmx:-rduXZpjFUsdf1IHPeWZRujC0Mywwv5OTM7xM_WGj-TVUA7wAqZuqQ>
    <xmx:-rduXXWUMprYKwhwexbeHn6CfOtcD0N8LqxKOLQs2K5CY49Me56e7Q>
    <xmx:-rduXbrHSuIK0dk9FZInSVmP2aoXf-31CBYUwbRwd80-YtOPJ_-ewQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B68AC80061;
        Tue,  3 Sep 2019 14:59:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFSv4/pnfs: Fix a page lock leak in nfs_pageio_resend()" failed to apply to 4.14-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:58:56 +0200
Message-ID: <1567537136103128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f4340e9314dbfadc48758945f85fc3b16612d06f Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Mon, 12 Aug 2019 15:19:54 -0400
Subject: [PATCH] NFSv4/pnfs: Fix a page lock leak in nfs_pageio_resend()

If the attempt to resend the pages fails, we need to ensure that we
clean up those pages that were not transmitted.

Fixes: d600ad1f2bdb ("NFS41: pop some layoutget errors to application")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v4.5+

diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index ed4e1b07447b..15c254753f88 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -1251,20 +1251,22 @@ static void nfs_pageio_complete_mirror(struct nfs_pageio_descriptor *desc,
 int nfs_pageio_resend(struct nfs_pageio_descriptor *desc,
 		      struct nfs_pgio_header *hdr)
 {
-	LIST_HEAD(failed);
+	LIST_HEAD(pages);
 
 	desc->pg_io_completion = hdr->io_completion;
 	desc->pg_dreq = hdr->dreq;
-	while (!list_empty(&hdr->pages)) {
-		struct nfs_page *req = nfs_list_entry(hdr->pages.next);
+	list_splice_init(&hdr->pages, &pages);
+	while (!list_empty(&pages)) {
+		struct nfs_page *req = nfs_list_entry(pages.next);
 
 		if (!nfs_pageio_add_request(desc, req))
-			nfs_list_move_request(req, &failed);
+			break;
 	}
 	nfs_pageio_complete(desc);
-	if (!list_empty(&failed)) {
-		list_move(&failed, &hdr->pages);
-		return desc->pg_error < 0 ? desc->pg_error : -EIO;
+	if (!list_empty(&pages)) {
+		int err = desc->pg_error < 0 ? desc->pg_error : -EIO;
+		hdr->completion_ops->error_cleanup(&pages, err);
+		return err;
 	}
 	return 0;
 }

