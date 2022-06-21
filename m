Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D71553CB0
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355733AbiFUVA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355634AbiFUU6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:58:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D862F3A3;
        Tue, 21 Jun 2022 13:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBC4D61874;
        Tue, 21 Jun 2022 20:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5A0C341C5;
        Tue, 21 Jun 2022 20:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844640;
        bh=n2+txuHaV0luaEh0g/RCXVIJELBEjdQC7YwHKghk+XA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0z9IYEUhml9fk+rIzLaED4+Wvelq92+1VLC2ji+RtMnzVROk5+l7QV01vlrU6JWt
         6vYTL09uJXFTg6tHKBy22pcUJ08M+Mz1D9g/Xvsj9AtcX2rBRVcO2QcLIsuUx1Sf4u
         U/oe6ljZU/V62Cn9/7q70SJYTUBSDNVImehPGZ/0Kks3+mpMU+nyekPKjIza6kmPM9
         yZJAslYzDbTzYQEtSxP8Doj39E0zzdG93He0E4nEMYbo+0hQZwnqwvCKFTnsTMHPEM
         wS0PH/2MrzUv9SduSg9Yb7E/xYZl+YnwRDmyylE/IcLU4fPFf6Hu1NvuBzaoPPxalq
         e5KYlL5rOxMSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baokun Li <libaokun1@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 20/20] ext4: correct the judgment of BUG in ext4_mb_normalize_request
Date:   Tue, 21 Jun 2022 16:50:10 -0400
Message-Id: <20220621205010.250185-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205010.250185-1-sashal@kernel.org>
References: <20220621205010.250185-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit cf4ff938b47fc5c00b0ccce53a3b50eca9b32281 ]

ext4_mb_normalize_request() can move logical start of allocated blocks
to reduce fragmentation and better utilize preallocation. However logical
block requested as a start of allocation (ac->ac_o_ex.fe_logical) should
always be covered by allocated blocks so we should check that by
modifying and to or in the assertion.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220528110017.354175-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 47a560d60d3e..1f328a5e2e3d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4171,7 +4171,22 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	}
 	rcu_read_unlock();
 
-	if (start + size <= ac->ac_o_ex.fe_logical &&
+	/*
+	 * In this function "start" and "size" are normalized for better
+	 * alignment and length such that we could preallocate more blocks.
+	 * This normalization is done such that original request of
+	 * ac->ac_o_ex.fe_logical & fe_len should always lie within "start" and
+	 * "size" boundaries.
+	 * (Note fe_len can be relaxed since FS block allocation API does not
+	 * provide gurantee on number of contiguous blocks allocation since that
+	 * depends upon free space left, etc).
+	 * In case of inode pa, later we use the allocated blocks
+	 * [pa_start + fe_logical - pa_lstart, fe_len/size] from the preallocated
+	 * range of goal/best blocks [start, size] to put it at the
+	 * ac_o_ex.fe_logical extent of this inode.
+	 * (See ext4_mb_use_inode_pa() for more details)
+	 */
+	if (start + size <= ac->ac_o_ex.fe_logical ||
 			start > ac->ac_o_ex.fe_logical) {
 		ext4_msg(ac->ac_sb, KERN_ERR,
 			 "start %lu, size %lu, fe_logical %lu",
-- 
2.35.1

