Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068213290D6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242849AbhCAUQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:16:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:38958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241506AbhCAUGL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:06:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7162265253;
        Mon,  1 Mar 2021 17:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621543;
        bh=A0Dda4FVAuVphiflLZOboimPZVchu3H/ga9el1qADzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlxNWS3MLOU6gTN+vFZ/x+8sSjoRqrmoC6/F40BWulcPLGfO/C0eIqXB+H6EkcY8v
         E544t1qGeUwIHQcKtazb+Sy9dTuGnGLK6vyB+r2HPqYSa141x5BZe21U7ZkDgdHwk/
         yZ+/0zKZ+DbKp5FodIXr9Be3yoJ6oP/bzx/5pHt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 554/775] NFSv4: Fixes for nfs4_bitmask_adjust()
Date:   Mon,  1 Mar 2021 17:12:02 +0100
Message-Id: <20210301161228.860194837@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 45901a231723a5a513ff08477983f3a274a6a910 ]

We don't want to ask for the ACL in a WRITE reply, since we don't have
a preallocated buffer.

Instead of checking NFS_INO_INVALID_ACCESS, which is really about
managing the access cache, we should look at the value of
NFS_INO_INVALID_OTHER. Also ensure we assign the mode, owner and
owner_group flags to the correct bit mask.

Finally, fix up the check for NFS_INO_INVALID_CTIME to retrieve the
ctime, and add a check for NFS_INO_INVALID_CHANGE.

Fixes: 76bd5c016ef4 ("NFSv4: make cache consistency bitmask dynamic")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 2f4679a62712a..fc8bbfd9beb36 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5438,15 +5438,16 @@ static void nfs4_bitmask_adjust(__u32 *bitmask, struct inode *inode,
 
 	if (cache_validity & NFS_INO_INVALID_ATIME)
 		bitmask[1] |= FATTR4_WORD1_TIME_ACCESS;
-	if (cache_validity & NFS_INO_INVALID_ACCESS)
-		bitmask[0] |= FATTR4_WORD1_MODE | FATTR4_WORD1_OWNER |
-				FATTR4_WORD1_OWNER_GROUP;
-	if (cache_validity & NFS_INO_INVALID_ACL)
-		bitmask[0] |= FATTR4_WORD0_ACL;
-	if (cache_validity & NFS_INO_INVALID_LABEL)
+	if (cache_validity & NFS_INO_INVALID_OTHER)
+		bitmask[1] |= FATTR4_WORD1_MODE | FATTR4_WORD1_OWNER |
+				FATTR4_WORD1_OWNER_GROUP |
+				FATTR4_WORD1_NUMLINKS;
+	if (label && label->len && cache_validity & NFS_INO_INVALID_LABEL)
 		bitmask[2] |= FATTR4_WORD2_SECURITY_LABEL;
-	if (cache_validity & NFS_INO_INVALID_CTIME)
+	if (cache_validity & NFS_INO_INVALID_CHANGE)
 		bitmask[0] |= FATTR4_WORD0_CHANGE;
+	if (cache_validity & NFS_INO_INVALID_CTIME)
+		bitmask[1] |= FATTR4_WORD1_TIME_METADATA;
 	if (cache_validity & NFS_INO_INVALID_MTIME)
 		bitmask[1] |= FATTR4_WORD1_TIME_MODIFY;
 	if (cache_validity & NFS_INO_INVALID_SIZE)
-- 
2.27.0



