Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792732E63A4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405567AbgL1NrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:47:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405559AbgL1NrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:47:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B46F9208B3;
        Mon, 28 Dec 2020 13:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163190;
        bh=JKuNHLdCxP/ujmthzwURtFPlov/5wrSVMjmrtwOEHVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mldyWWbjQf47dRNzWbh1NY53vhdEvQBRiLB9qZRMtN1HGjF8eEOri4ZvNuMusflbu
         i+buVEXa5+91kOw/ga3Le9LrGG/mz0MJr6AaTTNNeoIt3Q2yPovoK2OrCerYMUROjV
         QHx1NbR2qhPHpymnMfplEOGz5tcv0lBbxGiuC22Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Scott Mayhew <smayhew@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 200/453] NFSv4.2: condition READDIRs mask for security label based on LSM state
Date:   Mon, 28 Dec 2020 13:47:16 +0100
Message-Id: <20201228124946.836436297@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 05ad917561fca39a03338cb21fe9622f998b0f9c ]

Currently, the client will always ask for security_labels if the server
returns that it supports that feature regardless of any LSM modules
(such as Selinux) enforcing security policy. This adds performance
penalty to the READDIR operation.

Client adjusts superblock's support of the security_label based on
the server's support but also current client's configuration of the
LSM modules. Thus, prior to using the default bitmask in READDIR,
this patch checks the server's capabilities and then instructs
READDIR to remove FATTR4_WORD2_SECURITY_LABEL from the bitmask.

v5: fixing silly mistakes of the rushed v4
v4: simplifying logic
v3: changing label's initialization per Ondrej's comment
v2: dropping selinux hook and using the sb cap.

Suggested-by: Ondrej Mosnacek <omosnace@redhat.com>
Suggested-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Fixes: 2b0143b5c986 ("VFS: normal filesystems (and lustre): d_inode() annotations")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ddc900df461c8..8598eba3fc234 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4899,12 +4899,12 @@ static int _nfs4_proc_readdir(struct dentry *dentry, const struct cred *cred,
 		u64 cookie, struct page **pages, unsigned int count, bool plus)
 {
 	struct inode		*dir = d_inode(dentry);
+	struct nfs_server	*server = NFS_SERVER(dir);
 	struct nfs4_readdir_arg args = {
 		.fh = NFS_FH(dir),
 		.pages = pages,
 		.pgbase = 0,
 		.count = count,
-		.bitmask = NFS_SERVER(d_inode(dentry))->attr_bitmask,
 		.plus = plus,
 	};
 	struct nfs4_readdir_res res;
@@ -4919,9 +4919,15 @@ static int _nfs4_proc_readdir(struct dentry *dentry, const struct cred *cred,
 	dprintk("%s: dentry = %pd2, cookie = %Lu\n", __func__,
 			dentry,
 			(unsigned long long)cookie);
+	if (!(server->caps & NFS_CAP_SECURITY_LABEL))
+		args.bitmask = server->attr_bitmask_nl;
+	else
+		args.bitmask = server->attr_bitmask;
+
 	nfs4_setup_readdir(cookie, NFS_I(dir)->cookieverf, dentry, &args);
 	res.pgbase = args.pgbase;
-	status = nfs4_call_sync(NFS_SERVER(dir)->client, NFS_SERVER(dir), &msg, &args.seq_args, &res.seq_res, 0);
+	status = nfs4_call_sync(server->client, server, &msg, &args.seq_args,
+			&res.seq_res, 0);
 	if (status >= 0) {
 		memcpy(NFS_I(dir)->cookieverf, res.verifier.data, NFS4_VERIFIER_SIZE);
 		status += args.pgbase;
-- 
2.27.0



