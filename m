Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D9D33E444
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhCQA66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231857AbhCQA6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 291DA64F97;
        Wed, 17 Mar 2021 00:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942675;
        bh=UMkaH5AWrOvPbcuMtsK6lnKbEbfB7sMJ0mT8mGnsty4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNbHb33bdkUizX3FcgwsujzWg6xGyWOVhAq4RaQ1paAnc32C8W31+2iwM7tY5NlmD
         O7YuwO2/5ee+dQ9fBNEoPIe+PVq76eDaO/31kKyJPhC7JMNFBZGgrTZSK1gjbcOyWE
         O6yABngUR0OTlp6GfjzWwccUk0B0br5PDI0pRVA0dLV2kCIyNj99o5wKaaQrZykhnN
         idp++Pn2J5ZTYAwNwzdq/urbth8PgJWCcvkQmbO3rTvAIq93GkFvSs1Gj8dnT/E5WX
         2dfcS8ghyL4C+J2+ZEcNrckED/o6k0BrPz5YV760sc5WApTJGF9amXytGTOQEUH1Yz
         Jcjfgh9v1q9Ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 50/54] nfs: we don't support removing system.nfs4_acl
Date:   Tue, 16 Mar 2021 20:56:49 -0400
Message-Id: <20210317005654.724862-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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
index a811d42ffbd1..603e24cfd118 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5891,6 +5891,9 @@ static int __nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t bufl
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

