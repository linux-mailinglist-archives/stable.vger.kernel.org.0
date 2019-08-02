Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F047FB06
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405169AbfHBNg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393311AbfHBNUP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68BE821849;
        Fri,  2 Aug 2019 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752014;
        bh=MyptE6f8k+92LRAEm6ghXCPrsdPU0qjbt9hN9P9BSic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zk2qVf0Y8IHNjJh3bXA9+FLNCZ0dvxweamFczIF0OQZK5J2ywrS2cOKdsgH5JmUyn
         X2LTowJ+iCGmstPN8uUhPd8TFr6ExitEkgbKHBXPq4DpHtrBw5d2ia/JZrowmKaAQj
         7Es1Vs+U3ENH+heuzkby/0uYlICrXKWOn7EEigSo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     SivapiriyanKumarasamy <sivapiriyan.kumarasamy@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 18/76] drm/amd/display: Wait for backlight programming completion in set backlight level
Date:   Fri,  2 Aug 2019 09:18:52 -0400
Message-Id: <20190802131951.11600-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SivapiriyanKumarasamy <sivapiriyan.kumarasamy@amd.com>

[ Upstream commit c7990daebe71d11a9e360b5c3b0ecd1846a3a4bb ]

[WHY]
Currently we don't wait for blacklight programming completion in DMCU
when setting backlight level. Some sequences such as PSR static screen
event trigger reprogramming requires it to be complete.

[How]
Add generic wait for dmcu command completion in set backlight level.

Signed-off-by: SivapiriyanKumarasamy <sivapiriyan.kumarasamy@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
index 2959c3c9390b9..da30ae04e82bb 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_abm.c
@@ -234,6 +234,10 @@ static void dmcu_set_backlight_level(
 	s2 |= (backlight_8_bit << ATOM_S2_CURRENT_BL_LEVEL_SHIFT);
 
 	REG_WRITE(BIOS_SCRATCH_2, s2);
+
+	/* waitDMCUReadyForCmd */
+	REG_WAIT(MASTER_COMM_CNTL_REG, MASTER_COMM_INTERRUPT,
+			0, 1, 80000);
 }
 
 static void dce_abm_init(struct abm *abm)
-- 
2.20.1

