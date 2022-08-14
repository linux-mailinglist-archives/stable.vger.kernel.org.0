Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED93359230B
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241752AbiHNPwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242118AbiHNPvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:51:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E861F1D31B;
        Sun, 14 Aug 2022 08:36:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 492F1B80B77;
        Sun, 14 Aug 2022 15:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501B8C433C1;
        Sun, 14 Aug 2022 15:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491412;
        bh=HDn0Qcz2gytPtLt5gyFK0rQWGhhoEna1MAc0S70Ab3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/GFh5zRhi+tj4LBDM6w45anT2Y30fYU40PTADfbbrXBQeWEpj1POQpEPIFQkIdVk
         K2Sgyth8FqcCgh8Nwxe+WQB/zGv92SaCJRxtGa0RUqDw4qQnsIqFCHNtctHEV2OTl8
         hCrgq0S1UThLwYXAnhZvkuq3yOSBS7m7VhAsw93Wqv6zpkBbNj8gC6Fl20iuwEDC7L
         bVY9NpVj9RZ9SkaLVbzmUMVlNAkm1DJMVBhvMAroinuJe64HKaMK0hOBKG2gpqMnhF
         HA9qPmdDa52BKeYTvEm9E9b2eVVL6XyE3d5iSI/ebcKI3w5ADoKjsi/7Jau3DgnQN5
         WSeDj2MpeQYeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Kiselev, Oleg" <okiselev@amazon.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 9/9] ext4: avoid resizing to a partial cluster size
Date:   Sun, 14 Aug 2022 11:36:36 -0400
Message-Id: <20220814153637.2380406-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153637.2380406-1-sashal@kernel.org>
References: <20220814153637.2380406-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Kiselev, Oleg" <okiselev@amazon.com>

[ Upstream commit 69cb8e9d8cd97cdf5e293b26d70a9dee3e35e6bd ]

This patch avoids an attempt to resize the filesystem to an
unaligned cluster boundary.  An online resize to a size that is not
integral to cluster size results in the last iteration attempting to
grow the fs by a negative amount, which trips a BUG_ON and leaves the fs
with a corrupted in-memory superblock.

Signed-off-by: Oleg Kiselev <okiselev@amazon.com>
Link: https://lore.kernel.org/r/0E92A0AB-4F16-4F1A-94B7-702CC6504FDE@amazon.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/resize.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 721a00767d0e..aab86205c056 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1950,6 +1950,16 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 	}
 	brelse(bh);
 
+	/*
+	 * For bigalloc, trim the requested size to the nearest cluster
+	 * boundary to avoid creating an unusable filesystem. We do this
+	 * silently, instead of returning an error, to avoid breaking
+	 * callers that blindly resize the filesystem to the full size of
+	 * the underlying block device.
+	 */
+	if (ext4_has_feature_bigalloc(sb))
+		n_blocks_count &= ~((1 << EXT4_CLUSTER_BITS(sb)) - 1);
+
 retry:
 	o_blocks_count = ext4_blocks_count(es);
 
-- 
2.35.1

