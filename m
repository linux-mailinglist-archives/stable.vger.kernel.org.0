Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DC8A72F5
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfICS67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:58:59 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46325 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbfICS66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:58:58 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 89D332222B;
        Tue,  3 Sep 2019 14:58:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:58:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mLBrhP
        0oVXXewhstTDOEws2XtGXl9S0Qf0M2NkqPJp8=; b=UjkLbiBcxE8Rd24YqsVHgc
        z1Zg2S07d7UT9TprdvhPY65WyAwA/WHX4XNmqjTcxwfAUcKW/Kn77NVFpe3Se8i2
        L6AQ0r+fNQ9sMt3qVEyQS3P+3D/jIJw++6Z61lGhqORxth/1ZdO29XzfZR5b9P9g
        5s1s1ntyw5EyAze7GbSIMXWiQHojrWomua+0TMc172HHzjH0XVaotGN9u8M6WJOz
        CD28w2jRrLGofNyRI+RMOg6tH2xwfpH6QJ41j1ztOoQxjljGSw5+tYB0siF/bnyU
        gwt1Er/+vE11LyhUq3lb8xQX7slYSz7O6as3bqI9oODg3Xn8ZvwYHIXGCzOUcsFA
        ==
X-ME-Sender: <xms:8bduXbG7yTs79VpjyQxw9TsSt11m9_jrZfkvMyl2fFzyySKTI_-Lbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:8bduXaNIdmMwwH2ewJcvqLT3rSrru39rsXHu1XUTNp1nsnIVD-NpkQ>
    <xmx:8bduXSSRQeDxtFaTiPcW7LV9LTQ8KHdyKDiKLb5bCHgbTVxGvl9o9Q>
    <xmx:8bduXZSNUrP1r0X1IKp2Hy3zgpnOuBe7XHeaBHZGG_AGURTYGKjaTw>
    <xmx:8bduXQXXDZyTQBcfKSukMmWBcNBI_lIn5E3WXWURf1Fq1mLCGjA0rg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E5E9AD6005F;
        Tue,  3 Sep 2019 14:58:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFSv4/pnfs: Fix a page lock leak in nfs_pageio_resend()" failed to apply to 4.4-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:58:55 +0200
Message-ID: <1567537135131165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

