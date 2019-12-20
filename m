Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97FA8127E45
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfLTOjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:39:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727513AbfLTOaG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB692465E;
        Fri, 20 Dec 2019 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852206;
        bh=sHjZ0qd5CcSPOObcmrHAKFInCpvRbkdMC8s7KO+CHkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5V5ALxhRGdU5APeRX2NEJSWEaMnZHnXmrNURuFnS0YH9zPxr16ZLW7Fe3zysD5wn
         wZDmwV5aixgI3p1WtNUykJbSUDLPhM0zLVMJ93CK7p3OAFI0VNecA7cNGi+ycQdVXZ
         e5qVDMbQ/p4u7cPHdYg5fiSz6JGDZ4qOSrMAOgek=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Galiffi <David.Galiffi@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 08/52] drm/amd/display: Fixed kernel panic when booting with DP-to-HDMI dongle
Date:   Fri, 20 Dec 2019 09:29:10 -0500
Message-Id: <20191220142954.9500-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Galiffi <David.Galiffi@amd.com>

[ Upstream commit a51d9f8fe756beac51ce26ef54195da00a260d13 ]

[Why]
In dc_link_is_dp_sink_present, if dal_ddc_open fails, then
dal_gpio_destroy_ddc is called, destroying pin_data and pin_clock. They
are created only on dc_construct, and next aux access will cause a panic.

[How]
Instead of calling dal_gpio_destroy_ddc, call dal_ddc_close.

Signed-off-by: David Galiffi <David.Galiffi@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index ca20b150afcc2..6cb91a8eb2e0c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -373,7 +373,7 @@ bool dc_link_is_dp_sink_present(struct dc_link *link)
 
 	if (GPIO_RESULT_OK != dal_ddc_open(
 		ddc, GPIO_MODE_INPUT, GPIO_DDC_CONFIG_TYPE_MODE_I2C)) {
-		dal_gpio_destroy_ddc(&ddc);
+		dal_ddc_close(ddc);
 
 		return present;
 	}
-- 
2.20.1

