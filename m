Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58E633E4B9
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhCQBAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230452AbhCQA7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5884C64FC2;
        Wed, 17 Mar 2021 00:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942755;
        bh=5SjYFQdghaiaOZr6LqSuf4POlm9p1T31oMvQ7ufK9Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHMMow/hd/JGTik2Nh92RmFFCRDZ0vPPX6UrEnBVm9G/fteFY9BvoCppuEt2dl8FG
         xs2xgdw5yLgIqYnTrxu61m28RyFfGdngiiSM6S2758vs7uSaknQmpEy6XzyFYPDzM4
         Rh1KIWzdFjplcsSB/E/N9wyaFaK5NBzyU8ltD4oXCSO4Ka/+WArgNPuvhcpQrhA8g3
         6oPr+2YqPMJbtay6Nsr9l31++/M1WjnuzrrB0Bz3NDFVPORC0DrY9E8t8LBvhXrSow
         mvRLSWhMKtEhCjRFq2zzsU6yV4dKrvZaBgRdalnwx8ulbRih326oZ9DVb1r5dVzMYJ
         wjILESxAWsWMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/23] nfs: we don't support removing system.nfs4_acl
Date:   Tue, 16 Mar 2021 20:58:46 -0400
Message-Id: <20210317005850.726479-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005850.726479-1-sashal@kernel.org>
References: <20210317005850.726479-1-sashal@kernel.org>
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
index d89a815f7c31..f0dc5e0e5d5a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5535,6 +5535,9 @@ static int __nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t bufl
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

