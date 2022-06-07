Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85442540BA5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351390AbiFGSaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350488AbiFGS1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:27:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FD0171242;
        Tue,  7 Jun 2022 10:55:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 115D7617AE;
        Tue,  7 Jun 2022 17:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33DFC385A5;
        Tue,  7 Jun 2022 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624496;
        bh=kvqvrS7aBXFQLen3K2YQokr1nKqkLNmgu1NIMizyz9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDnxXDx2zd9BM8btPrJjRtva9NzKukSu+teFYey0FcTpdttR1uoZflyCO3hiNAnhq
         5a4qyWnAYgpcHNn0W029pkW1v1kPIPhIWEP1z/raH7cXIipDbm2tDp6L9mhV2f6vP2
         eA6GUdM7rJ7TMTXibbEXbHYBVO7aOJ6Fg4AcgJS53jvK2cTX/cKzB7r4JiI7qAe1/U
         /Tbc9Fcx9sT15comxLeaj7x5q+ee5cRCkbaYUaA98UqVzqxBuCeQFLrwrHhnwlQNUM
         7qwG/4bet64d4u00kIw1fObLY7VAn4HtFwOHjgs2UEeM4f4MKmMNmesXjQd3pAUBnY
         GNEQF00LMa3zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijo Lazar <lijo.lazar@amd.com>,
        Yang Wang <kevinyang.wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, evan.quan@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, kevin1.wang@amd.com, luben.tuikov@amd.com,
        Stanley.Yang@amd.com, tao.zhou1@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 44/60] drm/amd/pm: Fix missing thermal throttler status
Date:   Tue,  7 Jun 2022 13:52:41 -0400
Message-Id: <20220607175259.478835-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit b0f4d663fce6a4232d3c20ce820f919111b1c60b ]

On aldebaran, when thermal throttling happens due to excessive GPU
temperature, the reason for throttling event is missed in warning
message. This patch fixes it.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index 4885c4ae78b7..27a54145d352 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1643,6 +1643,7 @@ static const struct throttling_logging_label {
 	uint32_t feature_mask;
 	const char *label;
 } logging_label[] = {
+	{(1U << THROTTLER_TEMP_GPU_BIT), "GPU"},
 	{(1U << THROTTLER_TEMP_MEM_BIT), "HBM"},
 	{(1U << THROTTLER_TEMP_VR_GFX_BIT), "VR of GFX rail"},
 	{(1U << THROTTLER_TEMP_VR_MEM_BIT), "VR of HBM rail"},
-- 
2.35.1

