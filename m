Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7855B4980
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiIJVUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiIJVTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:19:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA1D4BD29;
        Sat, 10 Sep 2022 14:17:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2280D60E1F;
        Sat, 10 Sep 2022 21:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B5AC43470;
        Sat, 10 Sep 2022 21:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844676;
        bh=Dd+UuuvNPyzWXKk0/gNoM/1icn7LMspg1PySp2oJaq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+idS5xdUS2jVnSI4xAqUktKrGa8AYOsV3Z0dNJT9V0NM9WpakjXIKt/qE6E23Ivo
         +oT+B4eqBSJldspGD5fcqQcRxP7rHCSrMPplwOZkUP8wnUc/DsGuqg8AJa7arEo5MG
         NGDbAYWj/DKBKORtc8PRHuenpPN/hzpERubK6v13hq8qnR7BztscGe7QA+cztMlKTv
         EpwG8+8JIu6Rkxy1Sos5cmxxwlZy6mC6t8Aq3uHtYET61I6KHEhgPCyyuADyKzFaFQ
         v5++YYmfIcoIh9lq0JLhAdZqj+PaQzr2OWHQiUB1oj7UBR/ta4COvcoX8LClxn0s6K
         tazRM2STLjSLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 02/21] platform/surface: aggregator_registry: Add support for Surface Laptop Go 2
Date:   Sat, 10 Sep 2022 17:17:33 -0400
Message-Id: <20220910211752.70291-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211752.70291-1-sashal@kernel.org>
References: <20220910211752.70291-1-sashal@kernel.org>
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

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 84b8e403435c8fb94b872309673764a447961e00 ]

The Surface Laptop Go 2 seems to have the same SAM client devices as the
Surface Laptop Go 1, so re-use its node group.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20220810140133.99087-1-luzmaximilian@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surface_aggregator_registry.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 1679811eff502..5c0451c56ea83 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -558,6 +558,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Laptop Go 1 */
 	{ "MSHW0118", (unsigned long)ssam_node_group_slg1 },
 
+	/* Surface Laptop Go 2 */
+	{ "MSHW0290", (unsigned long)ssam_node_group_slg1 },
+
 	/* Surface Laptop Studio */
 	{ "MSHW0123", (unsigned long)ssam_node_group_sls },
 
-- 
2.35.1

