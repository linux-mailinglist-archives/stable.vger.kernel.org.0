Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961F31A7F3C
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 16:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389175AbgDNOJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 10:09:52 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43011 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389201AbgDNOJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 10:09:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 4FA165C0216;
        Tue, 14 Apr 2020 10:09:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 10:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ER4qRf
        prpqUe699n+GZPIUrt4Kim+7UllKDVnA+VMlI=; b=2YWDLwuCjHpslrs6UqBULB
        JU94b9lvi9S0ZF1vo/EFN0vJua2U6oCpt5mJACXwIhJK/NZ7v+EMYRZHrQW3LZO/
        OE5TKYe0YlPeuwXMJUI5QmQ84rnE2RbChtek6C9AcqubujYY4eSoNzn3SrmcoeIb
        6c+DFaBRTNSGba9LYev9sd9npxUZ+dnQxb/nYFVTNlh4tKTjSKUQ8/u/75/rSWDJ
        BX6Uyri+a7JOBfAtNJhzUVvdkiKYTFxcTgFQB+VU+Hml7INKxg1H2ZcjV0QrtaL4
        uSkV3YVqWHLVuEujVToie6s1taBqzOTf9EtJctjQQGTvCTa4O9qJ7JRIyr1Ivohg
        ==
X-ME-Sender: <xms:LsSVXuj8otNqv7t_vCDim8XbCIwLwYxc0-NCeI3YtlECLFAD32pjrA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:LsSVXhqoV7Wor7M9TI69yocTB6-VG79ar5IRHf4j1KZ7VyZbeN0F8w>
    <xmx:LsSVXqXAjf39AKLcbZJ_38juUzHkGbR1RQxkLnIWSPX7WUYReY8rrQ>
    <xmx:LsSVXiqZOeB9S2D27AZmvtoOLbEb2Gsvwa3ZM8IHA6a9WQUpsCGzgA>
    <xmx:LsSVXpsX4UuKnojwg49IoeNGmaQuztJ4UntP2QtVB_e0zDOeh1BEDw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3687328006B;
        Tue, 14 Apr 2020 10:09:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] CIFS: check new file size when extending file by fallocate" failed to apply to 5.4-stable tree
To:     jencce.kernel@gmail.com, lsahlber@redhat.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Apr 2020 16:09:39 +0200
Message-ID: <15868733793359@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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
 

