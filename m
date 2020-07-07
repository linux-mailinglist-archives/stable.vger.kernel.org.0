Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A740C21724C
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbgGGPbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728868AbgGGPXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6EFE2065D;
        Tue,  7 Jul 2020 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135384;
        bh=dV0gNCmUrXIR5SUldbObEaG2LXR9tG3iUZCJCixlu5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aD/nkA8gOTxofOdjuWDuclbTibK5exTa+DFtl+1P/FqpYKfgFKIP+cQ8m7Go59cMV
         fLmgaP/kBC8YerXKzSDugFO8LnamkeVNHW179/5jsWaCcr6Swk68P5kUpnlpDqR56k
         To5WYvXvuods0y/b772AaEE0FSjPX1ZFXsD0wZ48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Elfring <Markus.Elfring@web.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 002/112] exfat: add missing brelse() calls on error paths
Date:   Tue,  7 Jul 2020 17:16:07 +0200
Message-Id: <20200707145801.048188269@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e8dd3cda8667118b70d9fe527f61fe22623de04d ]

If the second exfat_get_dentry() call fails then we need to release
"old_bh" before returning.  There is a similar bug in exfat_move_file().

Fixes: 5f2aa075070c ("exfat: add inode operations")
Reported-by: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index a2659a8a68a14..3bf1dbadab691 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1089,10 +1089,14 @@ static int exfat_rename_file(struct inode *inode, struct exfat_chain *p_dir,
 
 		epold = exfat_get_dentry(sb, p_dir, oldentry + 1, &old_bh,
 			&sector_old);
+		if (!epold)
+			return -EIO;
 		epnew = exfat_get_dentry(sb, p_dir, newentry + 1, &new_bh,
 			&sector_new);
-		if (!epold || !epnew)
+		if (!epnew) {
+			brelse(old_bh);
 			return -EIO;
+		}
 
 		memcpy(epnew, epold, DENTRY_SIZE);
 		exfat_update_bh(sb, new_bh, sync);
@@ -1173,10 +1177,14 @@ static int exfat_move_file(struct inode *inode, struct exfat_chain *p_olddir,
 
 	epmov = exfat_get_dentry(sb, p_olddir, oldentry + 1, &mov_bh,
 		&sector_mov);
+	if (!epmov)
+		return -EIO;
 	epnew = exfat_get_dentry(sb, p_newdir, newentry + 1, &new_bh,
 		&sector_new);
-	if (!epmov || !epnew)
+	if (!epnew) {
+		brelse(mov_bh);
 		return -EIO;
+	}
 
 	memcpy(epnew, epmov, DENTRY_SIZE);
 	exfat_update_bh(sb, new_bh, IS_DIRSYNC(inode));
-- 
2.25.1



