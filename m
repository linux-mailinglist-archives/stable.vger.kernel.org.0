Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EB940E11A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbhIPQ1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:27:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241194AbhIPQZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:25:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56F1A6127A;
        Thu, 16 Sep 2021 16:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809002;
        bh=bzVyH0WygYFynfdGZJOFwl3JxrjxYE8Z4Ea6+S+LLT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrnJd206PtO+r7B4tW10m5vSnS6UiPCITl3PHPopYj/qXvKgBWc2IBPA5fHyc8ybB
         GcU48oXZ629nzyKTeY7450wZicpGGuJEmWu8neQDXobWXJRmR8WlT52rTLafhYSHXL
         aOOLuNBYSh29Rxuak1JsKU9u1wYbf7FzzpA7hE3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 301/306] drm/amd/display: Update number of DCN3 clock states
Date:   Thu, 16 Sep 2021 18:00:46 +0200
Message-Id: <20210916155804.347854380@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
@@ -2522,6 +2522,7 @@ void dcn30_update_bw_bounding_box(struct
 			dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 		}
 
+		dcn3_0_soc.num_states = num_states;
 		for (i = 0; i < dcn3_0_soc.num_states; i++) {
 			dcn3_0_soc.clock_limits[i].state = i;
 			dcn3_0_soc.clock_limits[i].dcfclk_mhz = dcfclk_mhz[i];


