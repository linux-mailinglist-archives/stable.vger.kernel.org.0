Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C1F33E4E8
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhCQBAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231211AbhCQA7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEDEB64FAE;
        Wed, 17 Mar 2021 00:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942784;
        bh=Z5Gk/GqZ8EDM2F88R9AbiJDBFO3W9Putmc7msa4fjZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgbAQ+FZCnIfrmdV1n2XA3spNOlFMKm7Xt4kiUK0cmodJb6enrMba4tB/tbvGHJXo
         8KY+3UEcEhWogagjluHVOnOZaL83EYEhbqAbLj9UJ4wBI8z0mM4Ca+zOdVkcSMjUku
         DgO0egcKpTbjM+zx3wLEq2tBwuRlpCpS8gRKEMEbADwFOjwUmtlXCj6cJCbdsOF5AS
         QnUKyz9zUqPclor9HWWz1fqgcxCpn7P+GRmBUU0B0AbAiLXXTLght2WP+9fROTM6kE
         Nyflgkb5uk0LKJngHFmS8ej3cOev/1q2wcr6F0Rfhsa7DNlb4gvB0PeS6ZCCnkHHYL
         Rwrpb9jRBiXSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 19/21] nfs: we don't support removing system.nfs4_acl
Date:   Tue, 16 Mar 2021 20:59:18 -0400
Message-Id: <20210317005920.726931-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005920.726931-1-sashal@kernel.org>
References: <20210317005920.726931-1-sashal@kernel.org>
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
index cbfea2c7d516..6d6c5123cbb6 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5255,6 +5255,9 @@ static int __nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t bufl
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

