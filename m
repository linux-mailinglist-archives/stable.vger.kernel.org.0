Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF485052FE
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237942AbiDRMyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240253AbiDRMxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:53:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6702DAA4;
        Mon, 18 Apr 2022 05:34:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53C9161033;
        Mon, 18 Apr 2022 12:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48893C385A7;
        Mon, 18 Apr 2022 12:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285272;
        bh=9WpKRmzPIMz90Vitck4aKghxMNPz4j5Xq4Pusf3jXaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyWcGBC0JdwMFKm0OXqraamFtEc4IiWCI/tZc/jnLajmwOP80nTMQYBA/fF2jQvCt
         ctUnpzurJyWJYDg9+AtgEBAz5ZuF3LfNoIRhxvuPrbeYiUdyli1V4kxb+kQTv0xe3w
         IhrMdv9HZhIsk1OP3exAc2tH095Lr7VnYYNPp3zI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/189] Drivers: hv: balloon: Disable balloon and hot-add accordingly
Date:   Mon, 18 Apr 2022 14:12:29 +0200
Message-Id: <20220418121204.732426338@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



