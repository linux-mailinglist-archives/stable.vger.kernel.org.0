Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48DC4B4AAB
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346407AbiBNKYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:24:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346323AbiBNKWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:22:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3944E6CA51;
        Mon, 14 Feb 2022 01:56:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD60BB80D83;
        Mon, 14 Feb 2022 09:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A34C340E9;
        Mon, 14 Feb 2022 09:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832564;
        bh=qTrfWGKcQwK9/K1vsVW9O6dZ74LUQqD2R9r8ZglHc68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RlayJZzaZqXjWyPvGZDw8ZTZGteDiUBa8NfN/PaPT8je9Xti273uqFWOmW1S14XA
         ys6PDXSYXxhTlmcvowu0HaiCKsSS5tKvghzulIBRluyOhI59mzfJhDqGE26+oeVpZa
         p780SQygq0mFlZ2ARv0BUTujFK6ZPp1acGejbYnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 055/203] drm/amdgpu/display: adjust msleep limit in dp_wait_for_training_aux_rd_interval
Date:   Mon, 14 Feb 2022 10:24:59 +0100
Message-Id: <20220214092512.114435140@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit dc919d670c6fd1ac81ebf31625cd19579f7b3d4c ]

Some architectures (e.g., ARM) have relatively low udelay limits.
On most architectures, anything longer than 2000us is not recommended.
Change the check to align with other similar checks in DC.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index ccd6cdbe46f43..b97be2e9088ce 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -201,7 +201,7 @@ void dp_wait_for_training_aux_rd_interval(
 	uint32_t wait_in_micro_secs)
 {
 #if defined(CONFIG_DRM_AMD_DC_DCN)
-	if (wait_in_micro_secs > 16000)
+	if (wait_in_micro_secs > 1000)
 		msleep(wait_in_micro_secs/1000);
 	else
 		udelay(wait_in_micro_secs);
-- 
2.34.1



