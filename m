Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A461AD670E
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 18:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbfJNQRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 12:17:32 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56877 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729271AbfJNQRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 12:17:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2E1E620C69;
        Mon, 14 Oct 2019 12:17:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 12:17:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=H9HE4j
        t6Pkt3zj6MW1PNuxkWaiZr9d2kgVXXljoaMRo=; b=fUheZuy9N2/o71gEYqRvwC
        KqNWdUdYe13ICaAplbFSNltyUduWlHScMz058lZ3qRSjjXWO/7zjeSszqrxrg+uC
        AU3JIxu7Wy3hB4HKe3Wi5+/uwW9bYTQaPvbhShHSQGycJ9ntJkAnfP/dzRxUjGz9
        J1mVbawnEWOhpfHwRrPGmoSxTneSYxSJnGnW+Ex9QmFeo2MBVleAB/ydiwPuSgs4
        +j6nl+/ScoKdBN/F06I2WwtWRG4FlQaZBbFgVVe7M8JV8c20HU/5kkammfMl1AIn
        u9P9S92heMmg5KyA5wvtDOd+uhE4tlxfD6AUUKaUc9WfVKxBCc3WRnStgzhcotcg
        ==
X-ME-Sender: <xms:mp-kXSzW2vrAr3jgAYhwo7xdEph1MOEaxq0VJLCLrMiDznn2YooCeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:mp-kXTdHZywaAHFsEyneSALAUKhzhxAUe8HRFZDuB0NWYCzudgnbRA>
    <xmx:mp-kXVO6YOvAZvOcrsTAUrKlwfR5losyqcESwYqSBbSlIMqft2-a1A>
    <xmx:mp-kXes33WASYtRH6zb3Sf4wGzUnvbalJsgei_Dplq_LD-voJ9HIRg>
    <xmx:m5-kXUSWc7IEsVjiBFagkcDS8ZQRr-dHS9DhZAG7PGC3DVLsH1F-rA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9852ED60065;
        Mon, 14 Oct 2019 12:17:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] CIFS: Force revalidate inode when dentry is stale" failed to apply to 4.4-stable tree
To:     piastryyy@gmail.com, pshilov@microsoft.com, stable@vger.kernel.org,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 18:17:29 +0200
Message-ID: <1571069849229168@kroah.com>
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

From c82e5ac7fe3570a269c0929bf7899f62048e7dbc Mon Sep 17 00:00:00 2001
From: Pavel Shilovsky <piastryyy@gmail.com>
Date: Mon, 30 Sep 2019 10:06:19 -0700
Subject: [PATCH] CIFS: Force revalidate inode when dentry is stale

Currently the client indicates that a dentry is stale when inode
numbers or type types between a local inode and a remote file
don't match. If this is the case attributes is not being copied
from remote to local, so, it is already known that the local copy
has stale metadata. That's why the inode needs to be marked for
revalidation in order to tell the VFS to lookup the dentry again
before openning a file. This prevents unexpected stale errors
to be returned to the user space when openning a file.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 3bae2e53f0b8..5dcc95b38310 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -414,6 +414,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 		/* if uniqueid is different, return error */
 		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
 		    CIFS_I(*pinode)->uniqueid != fattr.cf_uniqueid)) {
+			CIFS_I(*pinode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgiiu_exit;
 		}
@@ -421,6 +422,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 		/* if filetype is different, return error */
 		if (unlikely(((*pinode)->i_mode & S_IFMT) !=
 		    (fattr.cf_mode & S_IFMT))) {
+			CIFS_I(*pinode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgiiu_exit;
 		}
@@ -933,6 +935,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 		/* if uniqueid is different, return error */
 		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
 		    CIFS_I(*inode)->uniqueid != fattr.cf_uniqueid)) {
+			CIFS_I(*inode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgii_exit;
 		}
@@ -940,6 +943,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 		/* if filetype is different, return error */
 		if (unlikely(((*inode)->i_mode & S_IFMT) !=
 		    (fattr.cf_mode & S_IFMT))) {
+			CIFS_I(*inode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgii_exit;
 		}

