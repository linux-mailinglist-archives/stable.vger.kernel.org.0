Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DB7300D19
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbhAVT6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:58:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:34412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbhAVOOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:14:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4452523A5F;
        Fri, 22 Jan 2021 14:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324664;
        bh=9q3kSDHOt1IVp/diBP4F39WtWudxppLFmPDFRhZz48Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TD2roMyYaT/78A5/ABwPEBd9qE4bSG4b4s9APMuUF6BgB2rEb6GkjQmvvo93Q9+ZW
         gMadDTcxLdpFWQ3l0jocGmn1OIKhGQyAmEmhziBsCB4yJ/BUFoMlUtBNPeYfNascYV
         YAV/n7Vt970wu5tk7+UYUhLc3+bc1MTwPBvUfC9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.9 17/35] NFS: nfs_igrab_and_active must first reference the superblock
Date:   Fri, 22 Jan 2021 15:10:19 +0100
Message-Id: <20210122135733.017925650@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135732.357969201@linuxfoundation.org>
References: <20210122135732.357969201@linuxfoundation.org>
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
@@ -572,12 +572,14 @@ extern int nfs4_test_session_trunk(struc
 
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


