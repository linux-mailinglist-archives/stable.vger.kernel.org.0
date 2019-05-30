Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2752F4C9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbfE3Elo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbfE3DMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:23 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71C61218B6;
        Thu, 30 May 2019 03:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185942;
        bh=MU83gl83aJRinqmOR9ybTmHXWOWHcYU5xKkUMbZTKus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrFGBKmtKzrFyGMWoUlwGqyFmPQjE/+5tZjTtmLC76WLsxYHHInzFLxwuFRQVzlVc
         rpFfbK8SzTmZyPEkdxiSl4nmvC9cSgtlAfL7qnMiHRjpK5Gqj40iAjp0+VXnNcJlTQ
         833Jc7jmIgvujDH+SESc9ko/XK1+LhwU47PO379Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Francis <David.Francis@amd.com>,
        Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 349/405] drm/amd/display: Re-add custom degamma support
Date:   Wed, 29 May 2019 20:05:47 -0700
Message-Id: <20190530030558.330911326@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f91813992c343272813e707343b50f8d06383659 ]

[Why]
The dc_gamma_type CUSTOM_GAMMA is used to represent degamma
mappings passed in by drm. This type of gamma must be interpolated
into a transfer function by apply_1d_lut.  The line in
mod_color_calculate_degamma_params that handled this case
was erroneously removed.

[How]
For CUSTOM_GAMMA degamma, calculate the lut as before.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index 0fbc8fbc35416..a1055413bade6 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -1854,6 +1854,8 @@ bool mod_color_calculate_degamma_params(struct dc_transfer_func *input_tf,
 			coordinates_x, axis_x, curve,
 			MAX_HW_POINTS, tf_pts,
 			mapUserRamp && ramp && ramp->type == GAMMA_RGB_256);
+	if (ramp->type == GAMMA_CUSTOM)
+		apply_lut_1d(ramp, MAX_HW_POINTS, tf_pts);
 
 	ret = true;
 
-- 
2.20.1



