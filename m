Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3313F62509D
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbiKKChL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbiKKCgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018CFCE23;
        Thu, 10 Nov 2022 18:35:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7D1AB823E2;
        Fri, 11 Nov 2022 02:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44EFC433D6;
        Fri, 11 Nov 2022 02:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134115;
        bh=QxUeB5WV+GSnRxYS4vTC0gkrV3wabEgLbnL4EVSYrEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gl2zGEQL95LolZIexQ9U83wl5NJ39JrviZJSG77y5ePvrcqFuaSUS1REvUz//1fF5
         vYQcByZxfvhUxT3ncpqYQvwG0gwMlEBNm5m6pHvQWXCp1iqb8EzTPd/hbth7E1arUZ
         WdqwyDCBrREvizjtX5hEJrL9vdTMoy4jyVn3oqtrZ8BqbLru2ykZT6NF0oLXHFnv9p
         VtsNFLSI+6NurKyZkYgh6yDDHCd9VZSggvaTspf3YTxhUVhMsTXwK5P5keW0D2hs+N
         NFvFKUarXbaf8b+c4RCx/RmSlxsoAyoaF9ROMGQyIc1kQZlqyptnEDIMfSV4zneefZ
         4jT2SABcplV7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 02/11] btrfs: raid56: properly handle the error when unable to find the missing stripe
Date:   Thu, 10 Nov 2022 21:35:02 -0500
Message-Id: <20221111023511.227800-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023511.227800-1-sashal@kernel.org>
References: <20221111023511.227800-1-sashal@kernel.org>
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

[ Upstream commit f15fb2cd979a07fbfc666e2f04b8b30ec9233b2a ]

In raid56_alloc_missing_rbio(), if we can not determine where the
missing device is inside the full stripe, we just BUG_ON().

This is not necessary especially the only caller inside scrub.c is
already properly checking the return value, and will treat it as a
memory allocation failure.

Fix the error handling by:

- Add an extra warning for the reason
  Although personally speaking it may be better to be an ASSERT().

- Properly free the allocated rbio

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/raid56.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 3157a26ddf7e..5b27c289139a 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2728,8 +2728,10 @@ raid56_alloc_missing_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
 
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
 	if (rbio->faila == -1) {
-		BUG();
-		kfree(rbio);
+		btrfs_warn_rl(fs_info,
+	"can not determine the failed stripe number for full stripe %llu",
+			      bioc->raid_map[0]);
+		__free_raid_bio(rbio);
 		return NULL;
 	}
 
-- 
2.35.1

