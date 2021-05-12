Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4570137D295
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350955AbhELSKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352902AbhELSEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:04:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4818C6143C;
        Wed, 12 May 2021 18:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842602;
        bh=87QF4bpE+TrOiFnwHiGuEXOOECaIDbHO7Lw38C5X4X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihf/5f77IBUXpc7dDnmHSoEdxlxse5EXj31xW34osoSUdpP+0F2zMtDw3Uk5FeL6n
         5XERSZhqFAMAE/kSnRW9ACEt79laiIgDOSESUCzSI0hZuOfeQ2Up52QQx/tAyVC+xN
         z3XTjKQ3vX0cd3xB+Jyluf5HQTQnRvdNob9SDm0+TFJqKjOTKtanoMG3gZBQChqAi9
         /gMnV9ytaNaTp4DCXHsT58q1ETdHlF0odcuB9C+cSFw5EMIFM8Me1hLZiaLHsukzuB
         32ilA+Hsm3b1hlw2f/GY6cs5fkiXif8YqRRZokjQSwnBiP3muQQjO/ACsmGY4H8fkj
         y+cg7FCeQUFhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/34] NFS: NFS_INO_REVAL_PAGECACHE should mark the change attribute invalid
Date:   Wed, 12 May 2021 14:02:41 -0400
Message-Id: <20210512180306.664925-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180306.664925-1-sashal@kernel.org>
References: <20210512180306.664925-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 50c7a7994dd20af56e4d47e90af10bab71b71001 ]

When we're looking to revalidate the page cache, we should just ensure
that we mark the change attribute invalid.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 43af053f467a..fe3ecf72cc2a 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -207,7 +207,8 @@ static void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
 				| NFS_INO_INVALID_SIZE
 				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_INVALID_XATTR);
-	}
+	} else if (flags & NFS_INO_REVAL_PAGECACHE)
+		flags |= NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_SIZE;
 
 	if (inode->i_mapping->nrpages == 0)
 		flags &= ~(NFS_INO_INVALID_DATA|NFS_INO_DATA_INVAL_DEFER);
-- 
2.30.2

