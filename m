Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D922EA72F8
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfICS7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:59:10 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60811 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfICS7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:59:10 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 43B06222AF;
        Tue,  3 Sep 2019 14:59:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:59:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Y/8BN/
        F8e+0ptAl6sxK+vtnKUh8d5BuqlBqRkLUDouw=; b=TyNavdBYSCnVeuTY7L0Pih
        zmn6vdaH6UMlIod9RI21CHWEpB+C81GVwJHk6ssWj5aKr7vsdYO7UVDmEpZkrO+X
        BSqXQK0AzVg0JXpQNiZDs2jMLJjtp0aCM6Ca0ikvi/OnsQ2Jx02C2xwoAwKPy+af
        dMiBEIQJ00YypdHcqqaL/Sz0XwI5kHptVC+FnYWuC3ToEci3Piicsmrwim2rS/hc
        286wSHuDcVU1kTccltF4htyJEz0PsIwpM+0en/Ocflfe+l/onjV577GeeI91rgeX
        Cr2Pa6XVW1PNyA9Nbxh+qepvrZcaN+G25uELkzQ/DwYyStEpXrrvCX2z7pRYqfPw
        ==
X-ME-Sender: <xms:_bduXb0nYfEOMaCSlqqql2U4uV7AXzSD071LQKI1r5EXhebxyXY6Og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:_bduXbZqHzYp98eSxtqYSLNPUhV_4oEvlSHqoChOphxs9J6P_nrNNw>
    <xmx:_bduXQj4NhTaDDEToi20mQcUUdrIpydYmDZNse5g1EmCFGmjVqUlVg>
    <xmx:_bduXThzWkAi8ILuzrvVMxUhSWq-nZazu2Cm2r--0la02CiNssAR6A>
    <xmx:_bduXeF7CApX7v4Pfk6eHaT3j39fBpC2cnt7xHB2-cKFe-s0U0LzOA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C8F92D6005D;
        Tue,  3 Sep 2019 14:59:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFSv4/pnfs: Fix a page lock leak in nfs_pageio_resend()" failed to apply to 4.9-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:58:56 +0200
Message-ID: <1567537136240220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

