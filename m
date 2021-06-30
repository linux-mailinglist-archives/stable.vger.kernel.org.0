Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D813B8027
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 11:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhF3JkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 05:40:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59637 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbhF3JkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 05:40:24 -0400
Received: from [222.129.34.206] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <aaron.ma@canonical.com>)
        id 1lyWfK-0001gm-5f; Wed, 30 Jun 2021 09:37:54 +0000
From:   Aaron Ma <aaron.ma@canonical.com>
To:     aaron.ma@canonical.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: [RESEND][PATCH] drm/i915: Force DPCD backlight mode for Samsung 16727 panel
Date:   Wed, 30 Jun 2021 17:37:21 +0800
Message-Id: <20210630093721.10887-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <YNwzlqgBF/54qFMX@kroah.com>
References: <YNwzlqgBF/54qFMX@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Another Samsung OLED panel needs DPCD to get control of backlight.
Kernel 5.12+ support the backlight via:
commit: <4a8d79901d5b> ("drm/i915/dp: Enable Intel's HDR backlight interface (only SDR for now)")
Only make backlight work on lower versions of kernel.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3474
Cc: stable@vger.kernel.org # 5.11-
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/gpu/drm/drm_dp_helper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index 5bd0934004e3..7b91d8a76cd6 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -1960,6 +1960,7 @@ static const struct edid_quirk edid_quirk_list[] = {
 	{ MFG(0x4d, 0x10), PROD_ID(0xe6, 0x14), BIT(DP_QUIRK_FORCE_DPCD_BACKLIGHT) },
 	{ MFG(0x4c, 0x83), PROD_ID(0x47, 0x41), BIT(DP_QUIRK_FORCE_DPCD_BACKLIGHT) },
 	{ MFG(0x09, 0xe5), PROD_ID(0xde, 0x08), BIT(DP_QUIRK_FORCE_DPCD_BACKLIGHT) },
+	{ MFG(0x4c, 0x83), PROD_ID(0x57, 0x41), BIT(DP_QUIRK_FORCE_DPCD_BACKLIGHT) },
 };
 
 #undef MFG
-- 
2.32.0

