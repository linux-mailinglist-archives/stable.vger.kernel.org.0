Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CBE1A7F3B
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 16:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389203AbgDNOJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 10:09:52 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33953 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389175AbgDNOJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 10:09:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0AC885C0263;
        Tue, 14 Apr 2020 10:09:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 10:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZNW7LH
        6Lji3w0tbksuy3DwsDemfECagSzUSouKc5gNU=; b=auHaEce6jC2BAxuno3ESu6
        n5G8xLe3ytx9kgnYszAzJaB1N13D85ssat9F3ZzsLmxgylj6TOpqHnGKfoIlJRAT
        a8BD7mu+k6ls0ODCadNcxf3lv0ZcoCYLEvwGrO/cQa2SoRwu8fGF776jD5nElpJG
        eJZqbQNU2iaqq+kBi5kNAMf1yMFDmH2G7LsveHoyJhACV8dw5IRNfh9p2oXgFMLx
        MRx2JKCFyHZpwr+nt5KDVYopnQFyyRYUM6lFrWLIt7+B+RW1igN+onav8fgj1h5M
        EiLh+ZCQ3/sY/taUn6oLlbw8J4cb0bkVc27PDxsowizDuOHB8DT2PTMcqix0yZpQ
        ==
X-ME-Sender: <xms:LMSVXh6fES-Z0ibg7NDoBGp_x5_QZzMW777U_8npcoMv5srnZIrjmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:LMSVXtagB9NArRd6d8szU2m7cY5hX4Z9sq8R5hMjToBYty6LuaTgPg>
    <xmx:LMSVXg21_faiJmq4a5YfZD17GU1lXdTC3cjquucInpCDmEJsYV5VPA>
    <xmx:LMSVXr_Y7qchF0Ix2A14DXexFFqsznCeXzeopjVtJt924wVqE33NQg>
    <xmx:LcSVXkHE3HZQmTKjw_JIJCjRztZluNf7hsmRIxkv7ixzs51tFcfiPw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7DD743280066;
        Tue, 14 Apr 2020 10:09:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] CIFS: check new file size when extending file by fallocate" failed to apply to 4.19-stable tree
To:     jencce.kernel@gmail.com, lsahlber@redhat.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Apr 2020 16:09:39 +0200
Message-ID: <1586873379150133@kroah.com>
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

From ef4a632ccc1c7d3fb71a5baae85b79af08b7f94b Mon Sep 17 00:00:00 2001
From: Murphy Zhou <jencce.kernel@gmail.com>
Date: Wed, 18 Mar 2020 20:43:38 +0800
Subject: [PATCH] CIFS: check new file size when extending file by fallocate

xfstests generic/228 checks if fallocate respect RLIMIT_FSIZE.
After fallocate mode 0 extending enabled, we can hit this failure.
Fix this by check the new file size with vfs helper, return
error if file size is larger then RLIMIT_FSIZE(ulimit -f).

This patch has been tested by LTP/xfstests aginst samba and
Windows server.

Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index b0759c8aa6f5..9c9258fc8756 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3255,6 +3255,10 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	 * Extending the file
 	 */
 	if ((keep_size == false) && i_size_read(inode) < off + len) {
+		rc = inode_newsize_ok(inode, off + len);
+		if (rc)
+			goto out;
+
 		if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 

