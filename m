Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5BD469D7C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350752AbhLFP34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44126 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348578AbhLFP1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:27:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69BDD612EB;
        Mon,  6 Dec 2021 15:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44807C341E7;
        Mon,  6 Dec 2021 15:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804211;
        bh=jK80ZHaxoeA8DYw/BapI3GJl6uWcr+lliEp3Ys1Uwmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVkYYPQ5CI4+DZ3FRgnBuwvIw2NPzlUU42mr0dbKlU3Yu22zM6Qep1hqI7z66eNZZ
         EfY3tzQ8mBtHaXCcOJwYqIgQze5PDOREjbXLq0/Dr2OO2k4UeS48MG5GqA9/lOJBzb
         D+rLg5RAyIqtGyua2c8MToJSpqdi1+7GNqcU65i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijo Lazar <lijo.lazar@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/207] drm/amd/pm: Remove artificial freq level on Navi1x
Date:   Mon,  6 Dec 2021 15:54:48 +0100
Message-Id: <20211206145611.403769524@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit be83a5676767c99c2417083c29d42aa1e109a69d ]

Print Navi1x fine grained clocks in a consistent manner with other SOCs.
Don't show aritificial DPM level when the current clock equals min or max.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index b1ad451af06bd..dfba0bc732073 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -1265,7 +1265,7 @@ static int navi10_print_clk_levels(struct smu_context *smu,
 			enum smu_clk_type clk_type, char *buf)
 {
 	uint16_t *curve_settings;
-	int i, size = 0, ret = 0;
+	int i, levels, size = 0, ret = 0;
 	uint32_t cur_value = 0, value = 0, count = 0;
 	uint32_t freq_values[3] = {0};
 	uint32_t mark_index = 0;
@@ -1319,14 +1319,17 @@ static int navi10_print_clk_levels(struct smu_context *smu,
 			freq_values[1] = cur_value;
 			mark_index = cur_value == freq_values[0] ? 0 :
 				     cur_value == freq_values[2] ? 2 : 1;
-			if (mark_index != 1)
-				freq_values[1] = (freq_values[0] + freq_values[2]) / 2;
 
-			for (i = 0; i < 3; i++) {
+			levels = 3;
+			if (mark_index != 1) {
+				levels = 2;
+				freq_values[1] = freq_values[2];
+			}
+
+			for (i = 0; i < levels; i++) {
 				size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n", i, freq_values[i],
 						i == mark_index ? "*" : "");
 			}
-
 		}
 		break;
 	case SMU_PCIE:
-- 
2.33.0



