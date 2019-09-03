Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E552A72F7
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfICS7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:59:08 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37925 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfICS7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:59:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B157422274;
        Tue,  3 Sep 2019 14:59:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:59:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dISYzZ
        7fcrdwntIrnr4XvRYRKX5pLDghkdpacjzBEn4=; b=vb4MucLthxM2kj1Bbkfy6q
        TfNwzaHx56MIO+2f8rX6+nqg7dJ97BWWwUJxna2CufQNaHpVUCHgBR7UNo2dQ/6m
        Bnf39A4JQ0oCJQEYzHAs5+2WN+WgM0HjOtpmR6FbVRVt/Y9atGM7lw8yfnknndrc
        JVCnPsF4x51T7au5uKOg0f4cTbXuuOezVEUa1H4rpmBgsn9aEwXA4P2m/SHMoknb
        jDHJ5F3tXXigHVxZDDAxeTqy8a2+mNABmNGXdjhx97LQHUEd2q+vdwNyVt1fNRQV
        hKB16DsCWduYKM2XPPAk02wT8yGfs3+A1lKoVKA9mFe6iNbxtTkjx7duP11P+4tA
        ==
X-ME-Sender: <xms:-7duXQnZZak6rxQ_ijjz3kkfmMCYggI6qkSHOXueyQPzjeiaAXhU_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:-7duXcRjFbYsLJJd5Pc7j65auNU-7Y8Zy5StLndj-iyNrfUiNP8XDA>
    <xmx:-7duXdhXzpJGmYZtygNVwcR-AbAo2AAghfKgeM37qr4lDHTwR-Ymug>
    <xmx:-7duXSuDLxXAjmA87ew1ulDoz9b8nucBzwjPq-lri6yzGjKaWFKfyw>
    <xmx:-7duXe3hw_xJ5Kc5o-_4fQoZF-D4rRBsgKpf00bPjFFKDhGiKR4hIA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 322D680061;
        Tue,  3 Sep 2019 14:59:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFSv4/pnfs: Fix a page lock leak in nfs_pageio_resend()" failed to apply to 4.19-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:58:56 +0200
Message-ID: <15675371364297@kroah.com>
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

