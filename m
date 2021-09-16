Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F00C40E89D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356062AbhIPRpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355635AbhIPRly (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4450561A8F;
        Thu, 16 Sep 2021 16:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811208;
        bh=7hDOooAaSi2NI4ksDsB431R7/yksea1XrB/5UhGsLTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fsh0hGuG1BRYW3R5gXy77kHOEn/p7CH1n2g3EtrccM4mYwVPjsFfU4lpAsv7Y/B4i
         PxRyNpx9I6n0PfIVWQX6g1Rx0Vb6DBkr8PX0qPN9yp5xC4PgA77CVcB/UlhhD7xZeY
         ffDOyWkpivxNgAVAKFxcEnetXCOuZKjUHgyA0dhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 423/432] drm/amd/display: Update number of DCN3 clock states
Date:   Thu, 16 Sep 2021 18:02:52 +0200
Message-Id: <20210916155825.172597176@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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


