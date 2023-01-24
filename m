Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488A4679A2F
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbjAXNpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbjAXNos (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:44:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62818474C7;
        Tue, 24 Jan 2023 05:43:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF395B811EA;
        Tue, 24 Jan 2023 13:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CECC433EF;
        Tue, 24 Jan 2023 13:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567806;
        bh=aU13aZswrVBF+jlf0x4wFwaNBxGQzJ+noTS0NkOOf2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzVKW9BOs0LVuZnfezcVOir7QLHRKktuH15I31s7X9yLDeYCiWQztvbyHAjEQLA5k
         MKFfGpUr9eXZg+YpHAO+iKHsQHt3zK+1CVM3xT4r8Ma+moK+UgMuwFpx1husqNgakM
         axLhjxMGGiId5/8nq+t3h0AQ0TqAhZ/4qWQDz/VDhMbBX43q8V+S3QIpv+CclJeBcX
         dmGfzEyGMB/YuzjFzDi5GbBWxqlXRHLEXmQ3Iy8ZxfW/1mIO3d+ysV/qA9YC6zjWg3
         L0lakbQi0UrAJ094shZEjf+9M6JvnsdKCql5WFQfTwSQSL8tc0pay1HVoEUe/VNJrj
         6KdueM4CdDMCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, kernel test robot <lkp@intel.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.15 13/14] cifs: fix return of uninitialized rc in dfs_cache_update_tgthint()
Date:   Tue, 24 Jan 2023 08:42:56 -0500
Message-Id: <20230124134257.637523-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134257.637523-1-sashal@kernel.org>
References: <20230124134257.637523-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit d6a49e8c4ca4d399ed65ac219585187fc8c2e2b1 ]

Fix this by initializing rc to 0 as cache_refresh_path() would not set
it in case of success.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/all/202301190004.bEHvbKG6-lkp@intel.com/
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/dfs_cache.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 1f3efa7821a0..935c5781d878 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1046,10 +1046,10 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 			     const struct nls_table *cp, int remap, const char *path,
 			     const struct dfs_cache_tgt_iterator *it)
 {
-	int rc;
-	const char *npath;
-	struct cache_entry *ce;
 	struct cache_dfs_tgt *t;
+	struct cache_entry *ce;
+	const char *npath;
+	int rc = 0;
 
 	npath = dfs_cache_canonical_path(path, cp, remap);
 	if (IS_ERR(npath))
-- 
2.39.0

