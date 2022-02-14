Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063234B4A9C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347079AbiBNKYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:24:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346959AbiBNKWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:22:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839586CA52;
        Mon, 14 Feb 2022 01:56:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2150D61456;
        Mon, 14 Feb 2022 09:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD1EC340E9;
        Mon, 14 Feb 2022 09:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832567;
        bh=1A7IgsR91FTYPNF5tJ+NY0HRqWFFQHbPO3KHIvT7IJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrzNkclxCdP0Tm/eSEVtwRs9J43b7Oe3kgk2QvocAZ04Nuwqnxx8LFxFacGc/CpiX
         p2bBFJLWs6VG077I2TnuCJVQCP0eunFh26U8SEdATAU9moI1qhWvDqFo+wXe2XSA1T
         DVNpd2L98YSLRIJAqMgbSS9bzrrDIrzy0xh8R53g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 056/203] drm/amdgpu/display: use msleep rather than udelay for long delays
Date:   Mon, 14 Feb 2022 10:25:00 +0100
Message-Id: <20220214092512.153253157@linuxfoundation.org>
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

[ Upstream commit 98fdcacb45f7cd2092151d6af2e60152811eb79c ]

Some architectures (e.g., ARM) throw an compilation error if the
udelay is too long.  In general udelays of longer than 2000us are
not recommended on any architecture.  Switch to msleep in these
cases.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index b97be2e9088ce..94e75199d9428 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -6058,7 +6058,7 @@ bool dpcd_write_128b_132b_sst_payload_allocation_table(
 			}
 		}
 		retries++;
-		udelay(5000);
+		msleep(5);
 	}
 
 	if (!result && retries == max_retries) {
@@ -6110,7 +6110,7 @@ bool dpcd_poll_for_allocation_change_trigger(struct dc_link *link)
 			break;
 		}
 
-		udelay(5000);
+		msleep(5);
 	}
 
 	if (result == ACT_FAILED) {
-- 
2.34.1



