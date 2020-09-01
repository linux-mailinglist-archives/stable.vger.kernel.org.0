Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B482595A2
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732044AbgIAPyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731948AbgIAPqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:46:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EC8E206EF;
        Tue,  1 Sep 2020 15:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975198;
        bh=28qg86Fv2yHSlE6KxT+YVbBILfN1ppMYun3R6tD+i5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtmT8xLi+Rn4TxynZiBUIND7JTBL4XqQ7rGafWyBcPQEE5Zn2LG34GSsL9BRQivwu
         bHsR8RyTEFkt5nGELCvmaweRf4eOXsIUrlo4zcZfVk0Y/rjrStLKco+HnxvlgdiTFq
         10sczAEQbS2oQUoNCZdMgGXlyBAH+ysJr1x8NjQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>
Subject: [PATCH 5.8 217/255] drm/amd/powerplay: Fix hardmins not being sent to SMU for RV
Date:   Tue,  1 Sep 2020 17:11:13 +0200
Message-Id: <20200901151011.098452723@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit e2bf3723db563457c0abe4eaeedac25bbbbd1d76 upstream.

[Why]
DC uses these to raise the voltage as needed for higher dispclk/dppclk
and to ensure that we have enough bandwidth to drive the displays.

There's a bug preventing these from actuially sending messages since
it's checking the actual clock (which is 0) instead of the incoming
clock (which shouldn't be 0) when deciding to send the hardmin.

[How]
Check the clocks != 0 instead of the actual clocks.

Fixes: 9ed9203c3ee7 ("drm/amd/powerplay: rv dal-pplib interface refactor powerplay part")
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
@@ -204,8 +204,7 @@ static int smu10_set_min_deep_sleep_dcef
 {
 	struct smu10_hwmgr *smu10_data = (struct smu10_hwmgr *)(hwmgr->backend);
 
-	if (smu10_data->need_min_deep_sleep_dcefclk &&
-		smu10_data->deep_sleep_dcefclk != clock) {
+	if (clock && smu10_data->deep_sleep_dcefclk != clock) {
 		smu10_data->deep_sleep_dcefclk = clock;
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 					PPSMC_MSG_SetMinDeepSleepDcefclk,
@@ -219,8 +218,7 @@ static int smu10_set_hard_min_dcefclk_by
 {
 	struct smu10_hwmgr *smu10_data = (struct smu10_hwmgr *)(hwmgr->backend);
 
-	if (smu10_data->dcf_actual_hard_min_freq &&
-		smu10_data->dcf_actual_hard_min_freq != clock) {
+	if (clock && smu10_data->dcf_actual_hard_min_freq != clock) {
 		smu10_data->dcf_actual_hard_min_freq = clock;
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 					PPSMC_MSG_SetHardMinDcefclkByFreq,
@@ -234,8 +232,7 @@ static int smu10_set_hard_min_fclk_by_fr
 {
 	struct smu10_hwmgr *smu10_data = (struct smu10_hwmgr *)(hwmgr->backend);
 
-	if (smu10_data->f_actual_hard_min_freq &&
-		smu10_data->f_actual_hard_min_freq != clock) {
+	if (clock && smu10_data->f_actual_hard_min_freq != clock) {
 		smu10_data->f_actual_hard_min_freq = clock;
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 					PPSMC_MSG_SetHardMinFclkByFreq,


