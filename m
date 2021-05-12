Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B5337D23E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237311AbhELSHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352032AbhELSCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:02:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19FFE61428;
        Wed, 12 May 2021 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842473;
        bh=GVEiyiTtf48gz+ukeAM4SXTOHF2CEVuOVTqVQXbLxPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WxnbHvriM/aTKjpL9aor8h8H687O50PcKO25n3Gb8zi1PBaou8MVgLUCYuSYeOjsk
         hMsHT6Ep5rXQbePC6xHcDubokO7vJf15dU4jWl0P4ls8hTJwnNYtYcT32OzkjVXtQ7
         uQThGVQ69Mj2+aU+LtFaA25ApaSmOMkCp+KWyV0z3hi/EhEiNb3n1YRhAf/+H76xo6
         BFiXTBteuoJuaSmkR1kdm2xQjsiyGs7i7dNVFNs86Mr9u9QAzcpLORP83EWkcazWc9
         KBr/0+uzi4moXWvv/CIEFeguiIHKEvtecfgiJS+2ehMM5Jp4BIn/IxuOakqhEITDzs
         h9vhJVqLVwXpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 06/37] NFS: Fix fscache invalidation in nfs_set_cache_invalid()
Date:   Wed, 12 May 2021 14:00:33 -0400
Message-Id: <20210512180104.664121-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180104.664121-1-sashal@kernel.org>
References: <20210512180104.664121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit beab450d8ea93cdf4c6cb7714bdc31a9e0f34738 ]

Ensure that we invalidate the fscache before we strip the
NFS_INO_INVALID_DATA flag.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index a7fb076a5f44..ff737be559dc 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -223,11 +223,11 @@ void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
 
 	if (!nfs_has_xattr_cache(nfsi))
 		flags &= ~NFS_INO_INVALID_XATTR;
+	if (flags & NFS_INO_INVALID_DATA)
+		nfs_fscache_invalidate(inode);
 	if (inode->i_mapping->nrpages == 0)
 		flags &= ~(NFS_INO_INVALID_DATA|NFS_INO_DATA_INVAL_DEFER);
 	nfsi->cache_validity |= flags;
-	if (flags & NFS_INO_INVALID_DATA)
-		nfs_fscache_invalidate(inode);
 }
 EXPORT_SYMBOL_GPL(nfs_set_cache_invalid);
 
-- 
2.30.2

