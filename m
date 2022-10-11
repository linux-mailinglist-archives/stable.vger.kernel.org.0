Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734945FB5BB
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiJKO5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiJKO4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:56:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D659DD93;
        Tue, 11 Oct 2022 07:52:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17BD1611CA;
        Tue, 11 Oct 2022 14:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E71C433B5;
        Tue, 11 Oct 2022 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499927;
        bh=TlFvzsGM4Nex1avejFrjzErcNggEJVizUEc0EWbwmEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyjr+A0elPMBmIJLXxwz8xR/3bTIGSHy9oozGcqb7Lmw89HI8hWqvNaGETyevLFLt
         pOffDyyxMg1vU59PKCalHvBjl5FFvlZ7td6P6+C17t2BUGW54BN8ia7akTAlCN/+6a
         6TsB/N+liwNKsD2+k7f72WlU517XqC6wxgVS0v4mtUYVFT3MDzeizGzEAjDIx9n1/p
         04TpGeWZLnOWSuxU6XMAH8RarBu5bFPukBm5hNpIJ+0CZqgyDnGkFUWDG65TY8CSYe
         eidC/2xNGqTB/1mIR9M9tgcQKTypvs1mG/nByxp5Aq00sIXQ6Ppce5k3ACXMLTYuZA
         LZXOBk1V/jmrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 23/40] btrfs: dump extra info if one free space cache has more bitmaps than it should
Date:   Tue, 11 Oct 2022 10:51:12 -0400
Message-Id: <20221011145129.1623487-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 62cd9d4474282a1eb84f945955c56cbfc42e1ffe ]

There is an internal report on hitting the following ASSERT() in
recalculate_thresholds():

 	ASSERT(ctl->total_bitmaps <= max_bitmaps);

Above @max_bitmaps is calculated using the following variables:

- bytes_per_bg
  8 * 4096 * 4096 (128M) for x86_64/x86.

- block_group->length
  The length of the block group.

@max_bitmaps is the rounded up value of block_group->length / 128M.

Normally one free space cache should not have more bitmaps than above
value, but when it happens the ASSERT() can be triggered if
CONFIG_BTRFS_ASSERT is also enabled.

But the ASSERT() itself won't provide enough info to know which is going
wrong.
Is the bg too small thus it only allows one bitmap?
Or is there something else wrong?

So although I haven't found extra reports or crash dump to do further
investigation, add the extra info to make it more helpful to debug.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/free-space-cache.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index b1ae3ba2ca2c..16710d4571da 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -693,6 +693,12 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 
 	max_bitmaps = max_t(u64, max_bitmaps, 1);
 
+	if (ctl->total_bitmaps > max_bitmaps)
+		btrfs_err(block_group->fs_info,
+"invalid free space control: bg start=%llu len=%llu total_bitmaps=%u unit=%u max_bitmaps=%llu bytes_per_bg=%llu",
+			  block_group->start, block_group->length,
+			  ctl->total_bitmaps, ctl->unit, max_bitmaps,
+			  bytes_per_bg);
 	ASSERT(ctl->total_bitmaps <= max_bitmaps);
 
 	/*
-- 
2.35.1

