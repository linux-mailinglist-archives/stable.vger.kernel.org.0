Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E0250879
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbfFXKRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730971AbfFXKR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:17:27 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA24E208E4;
        Mon, 24 Jun 2019 10:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371446;
        bh=40PerwcHDL3afshREEfkdHj0tWkUN9N4rfcQBy/ERWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjIko8DPZeJbqN2FwKfqLuFwn06h10CjuwGv+gSmxoj8MycTdCpm127FmJZBQ6UOK
         NiTfW3uG31mv8vm1Nkv4Car3/ZsH1t1gQvYHG/JzzXX4nVqEBrZYCXCeq5xqjNmzGh
         9VAGr6damlSofkg2SBCIW3Q8vBTrANi7uFkWm6Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.1 105/121] ovl: make i_ino consistent with st_ino in more cases
Date:   Mon, 24 Jun 2019 17:57:17 +0800
Message-Id: <20190624092326.069500108@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 6dde1e42f497b2d4e22466f23019016775607947 upstream.

Relax the condition that overlayfs supports nfs export, to require
that i_ino is consistent with st_ino/d_ino.

It is enough to require that st_ino and d_ino are consistent.

This fixes the failure of xfstest generic/504, due to mismatch of
st_ino to inode number in the output of /proc/locks.

Fixes: 12574a9f4c9c ("ovl: consistent i_ino for non-samefs with xino")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/inode.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -553,15 +553,15 @@ static void ovl_fill_inode(struct inode
 	int xinobits = ovl_xino_bits(inode->i_sb);
 
 	/*
-	 * When NFS export is enabled and d_ino is consistent with st_ino
-	 * (samefs or i_ino has enough bits to encode layer), set the same
-	 * value used for d_ino to i_ino, because nfsd readdirplus compares
-	 * d_ino values to i_ino values of child entries. When called from
+	 * When d_ino is consistent with st_ino (samefs or i_ino has enough
+	 * bits to encode layer), set the same value used for st_ino to i_ino,
+	 * so inode number exposed via /proc/locks and a like will be
+	 * consistent with d_ino and st_ino values. An i_ino value inconsistent
+	 * with d_ino also causes nfsd readdirplus to fail.  When called from
 	 * ovl_new_inode(), ino arg is 0, so i_ino will be updated to real
 	 * upper inode i_ino on ovl_inode_init() or ovl_inode_update().
 	 */
-	if (inode->i_sb->s_export_op &&
-	    (ovl_same_sb(inode->i_sb) || xinobits)) {
+	if (ovl_same_sb(inode->i_sb) || xinobits) {
 		inode->i_ino = ino;
 		if (xinobits && fsid && !(ino >> (64 - xinobits)))
 			inode->i_ino |= (unsigned long)fsid << (64 - xinobits);


