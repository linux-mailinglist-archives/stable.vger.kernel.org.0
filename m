Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919BA66CB5
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfGLMWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727305AbfGLMWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:22:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD59E208E4;
        Fri, 12 Jul 2019 12:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934154;
        bh=YRtuN/2H0rgjM6ilhMgMIYYR1DuAJ8TUFcq6UJ9NsLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8tJXjHPgCyJNnfHCeLG/veWiefpnIfRGen6i/vX5pT0ZNI71D3IPs8KirsBWzGWl
         9Ajry+VENawxGsjK5taB9T0Kq+SdL3RChbV77DnzedzqzTgHwEAHtIRd0Jcdlkc5NZ
         BbSK3NrOMnQRYN7QP8ijmxd8McV/ZgwszdjgOxZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trond Myklebust <trondmy@hammerspace.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/91] NFS4: Only set creation opendata if O_CREAT
Date:   Fri, 12 Jul 2019 14:18:57 +0200
Message-Id: <20190712121624.573994260@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 53cf8599a46e..1de855e0ae61 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1243,10 +1243,20 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
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
@@ -1270,7 +1280,6 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
 	p->o_arg.server = server;
 	p->o_arg.bitmask = nfs4_bitmask(server, label);
 	p->o_arg.open_bitmap = &nfs4_fattr_bitmap[0];
-	p->o_arg.label = nfs4_label_copy(p->a_label, label);
 	switch (p->o_arg.claim) {
 	case NFS4_OPEN_CLAIM_NULL:
 	case NFS4_OPEN_CLAIM_DELEGATE_CUR:
@@ -1283,13 +1292,6 @@ static struct nfs4_opendata *nfs4_opendata_alloc(struct dentry *dentry,
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



