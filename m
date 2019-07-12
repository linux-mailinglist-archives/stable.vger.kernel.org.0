Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7F466E70
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfGLMig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728886AbfGLM2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:28:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C653A21019;
        Fri, 12 Jul 2019 12:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934531;
        bh=H6I2/ksPnVbn5p9q6Yu9BDSMuPFeLGvZrFTXPm23iHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDiwCvCCSvqjPhpAMYTHeXueHCp7rur69PL6OLZmwzmWp8LfTfrwZArLQ0+ZzU+LB
         1aEHyJw990XA+CQ1KXMT0n3QFI9QkuamOeopEwOpZrenF4tZCCEPzXI9N/0E/TCYo9
         rp1Cn+9GzaVispXgViki3Lz1TUb2sO2Qc5Ps/OM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trond Myklebust <trondmy@hammerspace.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 087/138] NFS4: Only set creation opendata if O_CREAT
Date:   Fri, 12 Jul 2019 14:19:11 +0200
Message-Id: <20190712121632.082259484@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
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



