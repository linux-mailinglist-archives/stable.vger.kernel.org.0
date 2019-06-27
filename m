Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B6757624
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfF0Afb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728257AbfF0Af2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:35:28 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12ADB217F9;
        Thu, 27 Jun 2019 00:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595728;
        bh=W8E55/JUU/4r0GfUmrRvJfE3rh51U4A7gM70pjbkrZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9jSyzT0591CHVTqt9a8t2ubfyTuexxYCLA6zhtr5O5FylnK5wZZiqDaWw/OBuxja
         258SPcClNkixF8ju22FQ43jLL5Gj8spQtDCH0RoghYg9SSosW6lLXpURksbcP8fzlo
         eboXEfNqiaAqH6jPDpVFFSQWifB/6N4q2+fvZEoU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 94/95] NFS4: Only set creation opendata if O_CREAT
Date:   Wed, 26 Jun 2019 20:30:19 -0400
Message-Id: <20190627003021.19867-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 909105199a682cb09c500acd443d34b182846c9c ]

We can end up in nfs4_opendata_alloc during task exit, in which case
current->fs has already been cleaned up.  This leads to a crash in
current_umask().

Fix this by only setting creation opendata if we are actually doing an open
with O_CREAT.  We can drop the check for NULL nfs4_open_createattrs, since
O_CREAT will never be set for the recovery path.

Suggested-by: Trond Myklebust <trondmy@hammerspace.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index eeee100785a5..fd2c19eea647 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1234,10 +1234,20 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
 	atomic_inc(&sp->so_count);
 	p->o_arg.open_flags = flags;
 	p->o_arg.fmode = fmode & (FMODE_READ|FMODE_WRITE);
-	p->o_arg.umask = current_umask();
 	p->o_arg.claim = nfs4_map_atomic_open_claim(server, claim);
 	p->o_arg.share_access = nfs4_map_atomic_open_share(server,
 			fmode, flags);
+	if (flags & O_CREAT) {
+		p->o_arg.umask = current_umask();
+		p->o_arg.label = nfs4_label_copy(p->a_label, label);
+		if (c->sattr != NULL && c->sattr->ia_valid != 0) {
+			p->o_arg.u.attrs = &p->attrs;
+			memcpy(&p->attrs, c->sattr, sizeof(p->attrs));
+
+			memcpy(p->o_arg.u.verifier.data, c->verf,
+					sizeof(p->o_arg.u.verifier.data));
+		}
+	}
 	/* don't put an ACCESS op in OPEN compound if O_EXCL, because ACCESS
 	 * will return permission denied for all bits until close */
 	if (!(flags & O_EXCL)) {
@@ -1261,7 +1271,6 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
 	p->o_arg.server = server;
 	p->o_arg.bitmask = nfs4_bitmask(server, label);
 	p->o_arg.open_bitmap = &nfs4_fattr_bitmap[0];
-	p->o_arg.label = nfs4_label_copy(p->a_label, label);
 	switch (p->o_arg.claim) {
 	case NFS4_OPEN_CLAIM_NULL:
 	case NFS4_OPEN_CLAIM_DELEGATE_CUR:
@@ -1274,13 +1283,6 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
 	case NFS4_OPEN_CLAIM_DELEG_PREV_FH:
 		p->o_arg.fh = NFS_FH(d_inode(dentry));
 	}
-	if (c != NULL && c->sattr != NULL && c->sattr->ia_valid != 0) {
-		p->o_arg.u.attrs = &p->attrs;
-		memcpy(&p->attrs, c->sattr, sizeof(p->attrs));
-
-		memcpy(p->o_arg.u.verifier.data, c->verf,
-				sizeof(p->o_arg.u.verifier.data));
-	}
 	p->c_arg.fh = &p->o_res.fh;
 	p->c_arg.stateid = &p->o_res.stateid;
 	p->c_arg.seqid = p->o_arg.seqid;
-- 
2.20.1

