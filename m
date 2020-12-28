Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA34C2E643B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404172AbgL1NmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:42:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404165AbgL1NmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:42:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E7A82064B;
        Mon, 28 Dec 2020 13:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162902;
        bh=9TQ4wAfsTVm3x0u1dNI8FaIpIokiiOq6tpPP4Ai0wx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygLJUaxRwD2e8gCDe0LAIoQSRZKFmPAoVJcG0+QSd1eD5n2s9K2o8bg1/Kw/3Br/K
         5+tgceRzFwQ9wEziRwovVMpOUrW2alLBsnAWfefR/RWoThcTy+7+B4HTNN+xTe1wMa
         X44AeWj/drKWTVlu1FyTCs0wvmPpa4VLgrlsDM8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/453] drm/amdgpu: fix build_coefficients() argument
Date:   Mon, 28 Dec 2020 13:45:35 +0100
Message-Id: <20201228124941.984955049@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit dbb60031dd0c2b85f10ce4c12ae604c28d3aaca4 ]

gcc -Wextra warns about a function taking an enum argument
being called with a bool:

drivers/gpu/drm/amd/amdgpu/../display/modules/color/color_gamma.c: In function 'apply_degamma_for_user_regamma':
drivers/gpu/drm/amd/amdgpu/../display/modules/color/color_gamma.c:1617:29: warning: implicit conversion from 'enum <anonymous>' to 'enum dc_transfer_func_predefined' [-Wenum-conversion]
 1617 |  build_coefficients(&coeff, true);

It appears that a patch was added using the old calling conventions
after the type was changed, and the value should actually be 0
(TRANSFER_FUNCTION_SRGB) here instead of 1 (true).

Fixes: 55a01d4023ce ("drm/amd/display: Add user_regamma to color module")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index 51d07a4561ce9..e042d8ce05b4a 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -1576,7 +1576,7 @@ static void apply_degamma_for_user_regamma(struct pwl_float_data_ex *rgb_regamma
 	struct pwl_float_data_ex *rgb = rgb_regamma;
 	const struct hw_x_point *coord_x = coordinates_x;
 
-	build_coefficients(&coeff, true);
+	build_coefficients(&coeff, TRANSFER_FUNCTION_SRGB);
 
 	i = 0;
 	while (i != hw_points_num + 1) {
-- 
2.27.0



