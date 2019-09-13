Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D504B1ED5
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388710AbfIMNNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388696AbfIMNNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:13:16 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3023208C0;
        Fri, 13 Sep 2019 13:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380395;
        bh=aD8VtpCcJNxfCBKT8aY0eKIomDLB0IGe/8mpvYgVHLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Abn43D2vvB65BS5VsJ4p7DzKipzMprnC531H6re0vjVIfgJvzhMXbOXkuRGy2di+b
         U/sKWVxezwzmWUDfSAad/X7UAJMHop+OCxkQAtRoVF/esJgPHlR3sLsqL6QtQy289I
         iWHf+qw87kVbLf7j3YZzkUsIugxVz33OjYAh+N/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Francis <David.Francis@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/190] powerplay: Respect units on max dcfclk watermark
Date:   Fri, 13 Sep 2019 14:05:06 +0100
Message-Id: <20190913130603.859449994@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f191415b24a3ad3fa22088af7cd7fc328a2f469f ]

In a refactor, the watermark clock inputs to
powerplay from DC were changed from units of 10kHz to
kHz clocks.

One division by 100 was not converted into a division
by 1000.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
index 2aab1b4759459..a321c465b7dce 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
@@ -674,7 +674,7 @@ int smu_set_watermarks_for_clocks_ranges(void *wt_table,
 		table->WatermarkRow[1][i].MaxClock =
 			cpu_to_le16((uint16_t)
 			(wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_max_dcfclk_clk_in_khz) /
-			100);
+			1000);
 		table->WatermarkRow[1][i].MinUclk =
 			cpu_to_le16((uint16_t)
 			(wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_min_mem_clk_in_khz) /
-- 
2.20.1



