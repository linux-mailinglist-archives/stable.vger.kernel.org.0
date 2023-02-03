Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137E76895F3
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbjBCKYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjBCKYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:24:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295E4A07FF
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:23:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0CB62CE2FBE
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4457DC433EF;
        Fri,  3 Feb 2023 10:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419825;
        bh=qk5tTsGIO8023rVFYdm44Dfw3q3U3Zcp9VWIK+8jgcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/1jwv9Q0kMq8C3qUE2pFeko0dO0G7ozjSP/ME3uW/+U60xvFAT5u064rdSKqadYM
         F2clLV271seB30/9anaFQHe9K0GXiwjS8auvn8eMTDjHbH/VlZepl4/u7pFeMGV7/X
         yOA+WSEdasewBX0M93jAVm85ARSgwkLZX3/M5NNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/20] cifs: fix return of uninitialized rc in dfs_cache_update_tgthint()
Date:   Fri,  3 Feb 2023 11:13:38 +0100
Message-Id: <20230203101008.486859284@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
References: <20230203101007.985835823@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8c98fa507768..1864bdadf3dd 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1050,10 +1050,10 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
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



