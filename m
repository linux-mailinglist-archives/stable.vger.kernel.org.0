Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63A659DCC3
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353364AbiHWKOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353639AbiHWKLq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:11:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26792719AF;
        Tue, 23 Aug 2022 01:57:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 494436153F;
        Tue, 23 Aug 2022 08:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F7EC433C1;
        Tue, 23 Aug 2022 08:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245071;
        bh=IYZO8npxWKcX2UbrOdmes4WW/OzWUgGzMI1e69PPBiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSYd3+ZCaSeBuDk5PzoBbHUl2ixMv5erPpclvp5CrvcJtycFzhu2vccmFcmaqETkp
         I4b+ECD68Nde1CwgkK0i8Hel0sv4vba82TGSrQKarLZQbleDTX0M+10eAi34J2DpOV
         SRTN/rCuGKNldahLsip9/EAMxErtYHNHfIZxspnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Kiselev <okiselev@amazon.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 205/244] ext4: avoid resizing to a partial cluster size
Date:   Tue, 23 Aug 2022 10:26:04 +0200
Message-Id: <20220823080106.344497069@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kiselev, Oleg <okiselev@amazon.com>

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
index fa3c854125bb..862cbbc01d6e 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1977,6 +1977,16 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
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



