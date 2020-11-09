Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4C32ABB0F
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387870AbgKINUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387874AbgKINUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:20:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5079206D8;
        Mon,  9 Nov 2020 13:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928001;
        bh=QIZEqvD2h/I2HvtgB4hTMz3vjJb6nXdCQk+CbZKlPBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDbPqprgk+XY1jJ/VjS8hnIHp+fONsXhtpoTHJRaTIDD07B5sBK4OfFAJTyFKSPKk
         TG1Fr3zR6SwMl5BXDfXLbBLYpyWmLU5A51C2d+XuOKfKtA4GjtrRltkbqO3SQT1SMb
         E/1lbojKg3tL3sbUsNJdXrnUZYfbEMnhEJcrVyFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Galiffi <David.Galiffi@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 092/133] drm/amd/display: Fixed panic during seamless boot.
Date:   Mon,  9 Nov 2020 13:55:54 +0100
Message-Id: <20201109125035.127432677@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Galiffi <David.Galiffi@amd.com>

[ Upstream commit 866e09f0110c6e86071954033e3067975946592a ]

[why]
get_pixel_clk_frequency_100hz is undefined in clock_source_funcs.

[how]
set function pointer: ".get_pixel_clk_frequency_100hz = get_pixel_clk_frequency_100hz"

Signed-off-by: David Galiffi <David.Galiffi@amd.com>
Reviewed-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
index 9cc65dc1970f8..49ae5ff12da63 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
@@ -1149,7 +1149,8 @@ static uint32_t dcn3_get_pix_clk_dividers(
 static const struct clock_source_funcs dcn3_clk_src_funcs = {
 	.cs_power_down = dce110_clock_source_power_down,
 	.program_pix_clk = dcn3_program_pix_clk,
-	.get_pix_clk_dividers = dcn3_get_pix_clk_dividers
+	.get_pix_clk_dividers = dcn3_get_pix_clk_dividers,
+	.get_pixel_clk_frequency_100hz = get_pixel_clk_frequency_100hz
 };
 #endif
 /*****************************************/
-- 
2.27.0



