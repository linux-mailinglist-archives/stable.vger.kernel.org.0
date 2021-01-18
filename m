Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A0A2FAA1C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437322AbhART07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:26:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390432AbhARLiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BF2C221EC;
        Mon, 18 Jan 2021 11:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969802;
        bh=psplj7E6pbRF0VvFZdW6Qy+OBViV4uIQvI+KMFyV4bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0Uzzvj+6HGRU5dcm3b7uKe7DwuzhBLXg8zWh/i1pwaUu7/eWnO9fUv8Kxl3WZ6uG
         WFMue3X5tdLRej3GTVsdqj02U5NQJrNIY6hbQL7lW1yT7JvK0r/3UtDvfJx+FW/4Fr
         Fi9U3fzgQZwUG7eKPeZp0/q4Otf97/qNPXmmtufg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 32/43] NFS: nfs_igrab_and_active must first reference the superblock
Date:   Mon, 18 Jan 2021 12:34:55 +0100
Message-Id: <20210118113336.502926083@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 896567ee7f17a8a736cda8a28cc987228410a2ac upstream.

Before referencing the inode, we must ensure that the superblock can be
referenced. Otherwise, we can end up with iput() calling superblock
operations that are no longer valid or accessible.

Fixes: ea7c38fef0b7 ("NFSv4: Ensure we reference the inode for return-on-close in delegreturn")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/internal.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -575,12 +575,14 @@ extern int nfs4_test_session_trunk(struc
 
 static inline struct inode *nfs_igrab_and_active(struct inode *inode)
 {
-	inode = igrab(inode);
-	if (inode != NULL && !nfs_sb_active(inode->i_sb)) {
-		iput(inode);
-		inode = NULL;
+	struct super_block *sb = inode->i_sb;
+
+	if (sb && nfs_sb_active(sb)) {
+		if (igrab(inode))
+			return inode;
+		nfs_sb_deactive(sb);
 	}
-	return inode;
+	return NULL;
 }
 
 static inline void nfs_iput_and_deactive(struct inode *inode)


