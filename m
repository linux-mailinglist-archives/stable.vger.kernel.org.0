Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F251676B1
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731679AbgBUIEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:04:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731675AbgBUIEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:04:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DEBB2467C;
        Fri, 21 Feb 2020 08:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272277;
        bh=NZZ++dKabZITguBBZrDnUclhdXCvf46rq0sMNW0akCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxE6Rqsbf3cOfCeIPPoeVrpygdXETzTdo0FD4kag43Ghg2SAy9fhDJntyB7xGtR+D
         TohrKmtTlmO5Dm2qkiGrCaK/0FE4wTsfLNzIGmBuolGJ9zB4CJdY2D/Zva5egFxLo6
         OrPPy6xuYNe1UL9qLAqq3mhNVEUInQSZVMfLDykI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Li <Ching-shih.Li@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/344] drm/amd/display: Retrain dongles when SINK_COUNT becomes non-zero
Date:   Fri, 21 Feb 2020 08:38:02 +0100
Message-Id: <20200221072356.496595415@linuxfoundation.org>
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

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit 3eb6d7aca53d81ce888624f09cd44dc0302161e8 ]

[WHY]
Two years ago the patch referenced by the Fixes tag stopped running
dp_verify_link_cap_with_retries during DP detection when the reason
for the detection was a short-pulse interrupt. This effectively meant
that we were no longer doing the verify_link_cap training on active
dongles when their SINK_COUNT changed from 0 to 1.

A year ago this was partly remedied with:
commit 80adaebd2d41 ("drm/amd/display: Don't skip link training for empty dongle")

This made sure that we trained the dongle on initial hotplug (without
connected downstream devices).

This is all fine and dandy if it weren't for the fact that there are
some dongles on the market that don't like link training when SINK_COUNT
is 0 These dongles will in fact indicate a SINK_COUNT of 0 immediately
after hotplug, even when a downstream device is connected, and then
trigger a shortpulse interrupt indicating a SINK_COUNT change to 1.

In order to play nicely we will need our policy to not link train an
active DP dongle when SINK_COUNT is 0 but ensure we train it when the
SINK_COUNT changes to 1.

[HOW]
Call dp_verify_link_cap_with_retries on detection even when the detection
is triggered from a short pulse interrupt.

With this change we can also revert this commit which we'll do in a separate
follow-up change:
commit 80adaebd2d41 ("drm/amd/display: Don't skip link training for empty dongle")

Fixes: 0301ccbaf67d ("drm/amd/display: DP Compliance 400.1.1 failure")
Suggested-by: Louis Li <Ching-shih.Li@amd.com>
Tested-by: Louis Li <Ching-shih.Li@amd.com>
Cc: Wenjing Liu <Wenjing.Liu@amd.com>
Cc: Hersen Wu <hersenxs.wu@amd.com>
Cc: Eric Yang <Eric.Yang2@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index c0f1c62c59b42..3aedc724241ef 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -948,8 +948,7 @@ bool dc_link_detect(struct dc_link *link, enum dc_detect_reason reason)
 			same_edid = is_same_edid(&prev_sink->dc_edid, &sink->dc_edid);
 
 		if (link->connector_signal == SIGNAL_TYPE_DISPLAY_PORT &&
-			sink_caps.transaction_type == DDC_TRANSACTION_TYPE_I2C_OVER_AUX &&
-			reason != DETECT_REASON_HPDRX) {
+			sink_caps.transaction_type == DDC_TRANSACTION_TYPE_I2C_OVER_AUX) {
 			/*
 			 * TODO debug why Dell 2413 doesn't like
 			 *  two link trainings
-- 
2.20.1



