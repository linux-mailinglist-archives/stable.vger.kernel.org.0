Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521AB2063C9
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393319AbgFWVLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391324AbgFWUca (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:32:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55D182072E;
        Tue, 23 Jun 2020 20:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944350;
        bh=94WxdoVU7+b9Qy1pyIxdy5ZyQ2U+ODdroBYxQ5xZTlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TL/kXCQOFH23k1qCc0u5e+LTUIFR4a/4g0UDY4UtdFEwfTfLJUm5Ez2Dd+WMVd5+E
         rwcbjRAG4oejfcWnk1KcymBpumd+n6kxxqTrTF24wIVq+CWBvywyYX9TB4HXKqrOXc
         JcLFia59pqQV8c5c7jiziH57HGtzH93EPEZpmyN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Botsch <botsch@cnf.cornell.edu>,
        Jeffrey Altman <jaltman@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 271/314] afs: Always include dir in bulk status fetch from afs_do_lookup()
Date:   Tue, 23 Jun 2020 21:57:46 +0200
Message-Id: <20200623195351.913172364@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 13fcc6356a94558a0a4857dc00cd26b3834a1b3e ]

When a lookup is done in an AFS directory, the filesystem will speculate
and fetch up to 49 other statuses for files in the same directory and fetch
those as well, turning them into inodes or updating inodes that already
exist.

However, occasionally, a callback break might go missing due to NAT timing
out, but the afs filesystem doesn't then realise that the directory is not
up to date.

Alleviate this by using one of the status slots to check the directory in
which the lookup is being done.

Reported-by: Dave Botsch <botsch@cnf.cornell.edu>
Suggested-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index d1e1caa23c8b3..3c486340b2208 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -658,7 +658,8 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry,
 
 	cookie->ctx.actor = afs_lookup_filldir;
 	cookie->name = dentry->d_name;
-	cookie->nr_fids = 1; /* slot 0 is saved for the fid we actually want */
+	cookie->nr_fids = 2; /* slot 0 is saved for the fid we actually want
+			      * and slot 1 for the directory */
 
 	read_seqlock_excl(&dvnode->cb_lock);
 	dcbi = rcu_dereference_protected(dvnode->cb_interest,
@@ -709,7 +710,11 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry,
 	if (!cookie->inodes)
 		goto out_s;
 
-	for (i = 1; i < cookie->nr_fids; i++) {
+	cookie->fids[1] = dvnode->fid;
+	cookie->statuses[1].cb_break = afs_calc_vnode_cb_break(dvnode);
+	cookie->inodes[1] = igrab(&dvnode->vfs_inode);
+
+	for (i = 2; i < cookie->nr_fids; i++) {
 		scb = &cookie->statuses[i];
 
 		/* Find any inodes that already exist and get their
-- 
2.25.1



