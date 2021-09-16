Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F49440E4E4
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349546AbhIPRGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348472AbhIPRC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:02:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7B1B61251;
        Thu, 16 Sep 2021 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810036;
        bh=7hDOooAaSi2NI4ksDsB431R7/yksea1XrB/5UhGsLTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xk9FjQjI+hH8Nhj02faYNT0GZkx0XyUo+YFetqWHAy+BNQRsxi2zIBCxkqBTS7AHl
         uQlwiOQARwQwM5nFxm4IBnRAyf3jpsRRHrSyVElHo/c+++AsQBtfJk/JbouyaKu0vD
         /dzi5X8CxQ47imezvYi0OK3ZhbJ2h9vXXht4wCgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 374/380] drm/amd/display: Update number of DCN3 clock states
Date:   Thu, 16 Sep 2021 18:02:11 +0200
Message-Id: <20210916155816.768804058@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit 0bbf06d888734041e813b916d7821acd4f72005a upstream.

[Why & How]
The DCN3 SoC parameter num_states was calculated but not saved into the
object.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1403
Cc: stable@vger.kernel.org
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -2467,6 +2467,7 @@ void dcn30_update_bw_bounding_box(struct
 			dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 		}
 
+		dcn3_0_soc.num_states = num_states;
 		for (i = 0; i < dcn3_0_soc.num_states; i++) {
 			dcn3_0_soc.clock_limits[i].state = i;
 			dcn3_0_soc.clock_limits[i].dcfclk_mhz = dcfclk_mhz[i];


