Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1941B441848
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhKAJpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234075AbhKAJoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:44:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05E92613D3;
        Mon,  1 Nov 2021 09:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758961;
        bh=CWa7deH9BWuqDSoHTGAD3ALYtOrYo89AJzHorCfCwYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHAVHivmpA3yboDW7kycfmHSVlij3xUKy5jTSYv7Ti/yGp1AH3dCaVldT9a3ScHP8
         jLBk/uI6pslEN++RTLaowcdPxY2HW7MpB9kVTg7xxPUIABqTUzm2g57GeV01X04S82
         AlYa5qz60BXdNluyR42/fv/TmONQgI4q0KfEs1pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Strauss <michael.strauss@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 055/125] drm/amd/display: Fallback to clocks which meet requested voltage on DCN31
Date:   Mon,  1 Nov 2021 10:17:08 +0100
Message-Id: <20211101082543.594171666@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Strauss <michael.strauss@amd.com>

commit 54149d13f369e1ab02f36b91feee02069184c1d8 upstream.

[WHY]
On certain configs, SMU clock table voltages don't match which cause parser
to behave incorrectly by leaving dcfclk and socclk table entries unpopulated.

[HOW]
Currently the function that finds the corresponding clock for a given voltage
only checks for exact voltage level matches. In the case that no match gets
found, parser now falls back to searching for the max clock which meets the
requested voltage (i.e. its corresponding voltage is below requested).

Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c |   13 ++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
@@ -518,14 +518,21 @@ static unsigned int find_clk_for_voltage
 		unsigned int voltage)
 {
 	int i;
+	int max_voltage = 0;
+	int clock = 0;
 
 	for (i = 0; i < NUM_SOC_VOLTAGE_LEVELS; i++) {
-		if (clock_table->SocVoltage[i] == voltage)
+		if (clock_table->SocVoltage[i] == voltage) {
 			return clocks[i];
+		} else if (clock_table->SocVoltage[i] >= max_voltage &&
+				clock_table->SocVoltage[i] < voltage) {
+			max_voltage = clock_table->SocVoltage[i];
+			clock = clocks[i];
+		}
 	}
 
-	ASSERT(0);
-	return 0;
+	ASSERT(clock);
+	return clock;
 }
 
 void dcn31_clk_mgr_helper_populate_bw_params(


