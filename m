Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5851675A4
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387508AbgBUIQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:16:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733018AbgBUIQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:16:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDE9924689;
        Fri, 21 Feb 2020 08:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272977;
        bh=z45Deq5jpfh5BBTwJ6zU+HtvdTraWuKGso37UKduEvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAP3fRC38+jhDC5oBFSBSbaoR9aqbhV+FcO1DyK5faqwF77jmftYpVZU33KEKEyR7
         xuprRA80FiUfy9xHsNoxvUQl6dhGNSu9/+bUZ0OUQmHk6JLJ0jgXc2VRxIEIPkzscq
         quUeIiTD1cyLxc3zd+WnsCewluQ//lfsuzy/jyOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 333/344] drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_latency
Date:   Fri, 21 Feb 2020 08:42:12 +0100
Message-Id: <20200221072420.612307785@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 4d0a72b66065dd7e274bad6aa450196d42fd8f84 ]

Only send non-0 clocks to DC for validation.  This mirrors
what the windows driver does.

Bug: https://gitlab.freedesktop.org/drm/amd/issues/963
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
index 1115761982a78..627a42e8fd318 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
@@ -1026,12 +1026,15 @@ static int smu10_get_clock_by_type_with_latency(struct pp_hwmgr *hwmgr,
 
 	clocks->num_levels = 0;
 	for (i = 0; i < pclk_vol_table->count; i++) {
-		clocks->data[i].clocks_in_khz = pclk_vol_table->entries[i].clk * 10;
-		clocks->data[i].latency_in_us = latency_required ?
-						smu10_get_mem_latency(hwmgr,
-						pclk_vol_table->entries[i].clk) :
-						0;
-		clocks->num_levels++;
+		if (pclk_vol_table->entries[i].clk) {
+			clocks->data[clocks->num_levels].clocks_in_khz =
+				pclk_vol_table->entries[i].clk * 10;
+			clocks->data[clocks->num_levels].latency_in_us = latency_required ?
+				smu10_get_mem_latency(hwmgr,
+						      pclk_vol_table->entries[i].clk) :
+				0;
+			clocks->num_levels++;
+		}
 	}
 
 	return 0;
-- 
2.20.1



