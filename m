Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1562333E3AB
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhCQA5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231240AbhCQA4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43B2C64FB4;
        Wed, 17 Mar 2021 00:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942605;
        bh=nV3ayq95eKEymLPuLam7wmH8009qcnNKR9AP8PNetRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=by7Wz0rtUe23BC96qIKRl5B3Mbave+A49NYtYvZ2P9KBmxw6uatAoW1tMuK2HscK1
         riLdeYVhm1zQPyTBkeYYfXk25s6emMInLDJ4jcoL2kwAl050RL8EteZ8zwn//r7vxj
         0xto9U7PdH4twEGZuwOFlq8NoE5MvaKT9zjg1Eqqs5luNpmCllGkEKGIR1wyb/BdA7
         XMvKG0EQfZMtBioNjvHrX7cX0lg6JowwLGi+K0V1iDoiTmHiJqCtEosTFKNoU2JqKr
         93sWdYevo5wWtZsAyTE2fB7xT3nIDn9TZJavu3yR9oRc+KLiqJSIR4NLSz7gJlQQII
         g42fs5wdWytpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 56/61] nfs: we don't support removing system.nfs4_acl
Date:   Tue, 16 Mar 2021 20:55:30 -0400
Message-Id: <20210317005536.724046-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit 4f8be1f53bf615102d103c0509ffa9596f65b718 ]

The NFSv4 protocol doesn't have any notion of reomoving an attribute, so
removexattr(path,"system.nfs4_acl") doesn't make sense.

There's no documented return value.  Arguably it could be EOPNOTSUPP but
I'm a little worried an application might take that to mean that we
don't support ACLs or xattrs.  How about EINVAL?

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index fc8bbfd9beb3..2bd64bfcc11a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5896,6 +5896,9 @@ static int __nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t bufl
 	unsigned int npages = DIV_ROUND_UP(buflen, PAGE_SIZE);
 	int ret, i;
 
+	/* You can't remove system.nfs4_acl: */
+	if (buflen == 0)
+		return -EINVAL;
 	if (!nfs4_server_supports_acls(server))
 		return -EOPNOTSUPP;
 	if (npages > ARRAY_SIZE(pages))
-- 
2.30.1

