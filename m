Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AAE34C56F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhC2IAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhC2H76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 03:59:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5045E6196D;
        Mon, 29 Mar 2021 07:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004797;
        bh=AgKnqvbMvHroSMbkDBCToxD0TGA2FODh/W8M2DulD64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoEJF9zshVFXJJS2F3TPGztBnXK7B+TdCif3h79HO+MrauULEs9w3Yb+Ur+s9/nkx
         cysu7cShZ2f4ro38ahqrZPViCZT4I0tfZ8dkHOoPyadK0tGNFU2hPewP0drPiIsdq1
         MW3ld8hpVvsrErfVhrNQKeSPX4G+e1vVkgJvAETU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 12/33] nfs: we dont support removing system.nfs4_acl
Date:   Mon, 29 Mar 2021 09:57:57 +0200
Message-Id: <20210329075605.668884309@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075605.290845195@linuxfoundation.org>
References: <20210329075605.290845195@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

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
index 0c9386978d9d..92ca753723b5 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4848,6 +4848,9 @@ static int __nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t bufl
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



