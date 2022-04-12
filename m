Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D574FCA72
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245142AbiDLAx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343652AbiDLAxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:53:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A00C33E38;
        Mon, 11 Apr 2022 17:48:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8004617E7;
        Tue, 12 Apr 2022 00:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9BDC385AA;
        Tue, 12 Apr 2022 00:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724489;
        bh=9WpKRmzPIMz90Vitck4aKghxMNPz4j5Xq4Pusf3jXaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nx0EiLq+GGDnJhc6GjqygV5RL/N0Mbeq5USKY7DVDu7XfpUkdd2IEQbiMDVnBKMZF
         rAvFsJ1fQ5DogUqEO+0vgg/VAyDfxbFQCOUbHR6juHv1JKhtZLvZUG+rm8ZUhPA6uO
         D5zJwajyyuwfBJqdlQXaNqmXS/VW8Ao1cvKzJUn0glhO74f798e40EeI8GshKmUVIA
         1BHIZCAQKoZejJAuhwAtizQUP3WTMrkLpgcqJgkXoSfD9Ie7ecB9BHxpNQVrhBPFuo
         mUkIrla+0Bb6JKmnZ5tzPvW8vNEnd8PBiUbofa+BHKOpsc0xArV2s3MY0+bc0BaPHV
         12nzx6zu77aPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boqun Feng <boqun.feng@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 25/41] Drivers: hv: balloon: Disable balloon and hot-add accordingly
Date:   Mon, 11 Apr 2022 20:46:37 -0400
Message-Id: <20220412004656.350101-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Boqun Feng <boqun.feng@gmail.com>

[ Upstream commit be5802795cf8d0b881745fa9ba7790293b382280 ]

Currently there are known potential issues for balloon and hot-add on
ARM64:

*	Unballoon requests from Hyper-V should only unballoon ranges
	that are guest page size aligned, otherwise guests cannot handle
	because it's impossible to partially free a page. This is a
	problem when guest page size > 4096 bytes.

*	Memory hot-add requests from Hyper-V should provide the NUMA
	node id of the added ranges or ARM64 should have a functional
	memory_add_physaddr_to_nid(), otherwise the node id is missing
	for add_memory().

These issues require discussions on design and implementation. In the
meanwhile, post_status() is working and essential to guest monitoring.
Therefore instead of disabling the entire hv_balloon driver, the
ballooning (when page size > 4096 bytes) and hot-add are disabled
accordingly for now. Once the issues are fixed, they can be re-enable in
these cases.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20220325023212.1570049-3-boqun.feng@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_balloon.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 439f99b8b5de..3cf334c46c31 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1653,6 +1653,38 @@ static void disable_page_reporting(void)
 	}
 }
 
+static int ballooning_enabled(void)
+{
+	/*
+	 * Disable ballooning if the page size is not 4k (HV_HYP_PAGE_SIZE),
+	 * since currently it's unclear to us whether an unballoon request can
+	 * make sure all page ranges are guest page size aligned.
+	 */
+	if (PAGE_SIZE != HV_HYP_PAGE_SIZE) {
+		pr_info("Ballooning disabled because page size is not 4096 bytes\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static int hot_add_enabled(void)
+{
+	/*
+	 * Disable hot add on ARM64, because we currently rely on
+	 * memory_add_physaddr_to_nid() to get a node id of a hot add range,
+	 * however ARM64's memory_add_physaddr_to_nid() always return 0 and
+	 * DM_MEM_HOT_ADD_REQUEST doesn't have the NUMA node information for
+	 * add_memory().
+	 */
+	if (IS_ENABLED(CONFIG_ARM64)) {
+		pr_info("Memory hot add disabled on ARM64\n");
+		return 0;
+	}
+
+	return 1;
+}
+
 static int balloon_connect_vsp(struct hv_device *dev)
 {
 	struct dm_version_request version_req;
@@ -1724,8 +1756,8 @@ static int balloon_connect_vsp(struct hv_device *dev)
 	 * currently still requires the bits to be set, so we have to add code
 	 * to fail the host's hot-add and balloon up/down requests, if any.
 	 */
-	cap_msg.caps.cap_bits.balloon = 1;
-	cap_msg.caps.cap_bits.hot_add = 1;
+	cap_msg.caps.cap_bits.balloon = ballooning_enabled();
+	cap_msg.caps.cap_bits.hot_add = hot_add_enabled();
 
 	/*
 	 * Specify our alignment requirements as it relates
-- 
2.35.1

