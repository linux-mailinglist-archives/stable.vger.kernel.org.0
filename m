Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 956E339D8B
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfFHLli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbfFHLlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:41:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83E6A214D8;
        Sat,  8 Jun 2019 11:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994080;
        bh=GwuOu9Wad7QfE3781L/fhBg8S+ksQM9htQI31ptw/qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UG3A1G8fT+vWB7cacLMbcYHVUTTSJXkGCRIaIfBIk7bc/0BA95BmYX0faFauRBIeH
         AIjoF71btkFBDVsyi4uv7Wp2/TNB7UmgUvpEtK8388gFv+oW1vU3MR9csBq0yO+2ca
         77Z/uR3zRG9Pt/p1Cw6ajuvjFuth7wQ3EwYgYxJw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gen Zhang <blackgod016574@gmail.com>,
        Paulo Alcantara <palcantara@suse.de>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 51/70] dfs_cache: fix a wrong use of kfree in flush_cache_ent()
Date:   Sat,  8 Jun 2019 07:39:30 -0400
Message-Id: <20190608113950.8033-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>

[ Upstream commit 50fbc13dc12666f3604dc2555a47fc8c4e29162b ]

In flush_cache_ent(), 'ce->ce_path' is allocated by kstrdup_const().
It should be freed by kfree_const(), rather than kfree().

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Reviewed-by: Paulo Alcantara <palcantara@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/dfs_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 09b7d0d4f6e4..007cfa39be5f 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -131,7 +131,7 @@ static inline void flush_cache_ent(struct dfs_cache_entry *ce)
 		return;
 
 	hlist_del_init_rcu(&ce->ce_hlist);
-	kfree(ce->ce_path);
+	kfree_const(ce->ce_path);
 	free_tgts(ce);
 	dfs_cache_count--;
 	call_rcu(&ce->ce_rcu, free_cache_entry);
@@ -421,7 +421,7 @@ alloc_cache_entry(const char *path, const struct dfs_info3_param *refs,
 
 	rc = copy_ref_data(refs, numrefs, ce, NULL);
 	if (rc) {
-		kfree(ce->ce_path);
+		kfree_const(ce->ce_path);
 		kmem_cache_free(dfs_cache_slab, ce);
 		ce = ERR_PTR(rc);
 	}
-- 
2.20.1

