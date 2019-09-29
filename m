Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F4DC1589
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbfI2OCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729534AbfI2OCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:02:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C03D2086A;
        Sun, 29 Sep 2019 14:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765731;
        bh=WteolVlV8xZa6ogzKxdo9wnP8h81ZVK+QRa798z6MtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtJLO1y+U6my/hKETjqVV+nEJBtysQLhovBJF9Eby1LBpiBrSEw/Nq2rkU+PXdA+b
         h70I5YXrY/JlbJg1yzZd2ZhcFf73V7G84YkhXmlDmH4v7G19ttpsp8wzNotbUieRge
         4VTLQ6wnj6aKbJZm3LKkLjKysCiwwzo8Yw6UmWeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S." <david@majinbuu.com>,
        Peteris Rudzusiks <peteris.rudzusiks@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.2 35/45] drm/dp: Add DP_DPCD_QUIRK_NO_SINK_COUNT
Date:   Sun, 29 Sep 2019 15:56:03 +0200
Message-Id: <20190929135032.577766771@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 7974033e527a5dd12d96126d09d4cff4f9b65c69 ]

CH7511 eDP->LVDS bridge doesn't seem to set SINK_COUNT properly
causing i915 to detect it as disconnected. Add a quirk to ignore
SINK_COUNT on these devices.

Cc: David S. <david@majinbuu.com>
Cc: Peteris Rudzusiks <peteris.rudzusiks@gmail.com>
Tested-by: Peteris Rudzusiks <peteris.rudzusiks@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=105406
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190528140650.19230-1-ville.syrjala@linux.intel.com
Acked-by: Jani Nikula <jani.nikula@intel.com> #irc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_helper.c | 4 +++-
 include/drm/drm_dp_helper.h     | 7 +++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index 54a6414c5d961..429c58ce56ced 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -1278,7 +1278,9 @@ static const struct dpcd_quirk dpcd_quirk_list[] = {
 	/* LG LP140WF6-SPM1 eDP panel */
 	{ OUI(0x00, 0x22, 0xb9), DEVICE_ID('s', 'i', 'v', 'a', 'r', 'T'), false, BIT(DP_DPCD_QUIRK_CONSTANT_N) },
 	/* Apple panels need some additional handling to support PSR */
-	{ OUI(0x00, 0x10, 0xfa), DEVICE_ID_ANY, false, BIT(DP_DPCD_QUIRK_NO_PSR) }
+	{ OUI(0x00, 0x10, 0xfa), DEVICE_ID_ANY, false, BIT(DP_DPCD_QUIRK_NO_PSR) },
+	/* CH7511 seems to leave SINK_COUNT zeroed */
+	{ OUI(0x00, 0x00, 0x00), DEVICE_ID('C', 'H', '7', '5', '1', '1'), false, BIT(DP_DPCD_QUIRK_NO_SINK_COUNT) },
 };
 
 #undef OUI
diff --git a/include/drm/drm_dp_helper.h b/include/drm/drm_dp_helper.h
index 97ce790a5b5aa..d6c89cbe127a3 100644
--- a/include/drm/drm_dp_helper.h
+++ b/include/drm/drm_dp_helper.h
@@ -1401,6 +1401,13 @@ enum drm_dp_quirk {
 	 * driver still need to implement proper handling for such device.
 	 */
 	DP_DPCD_QUIRK_NO_PSR,
+	/**
+	 * @DP_DPCD_QUIRK_NO_SINK_COUNT:
+	 *
+	 * The device does not set SINK_COUNT to a non-zero value.
+	 * The driver should ignore SINK_COUNT during detection.
+	 */
+	DP_DPCD_QUIRK_NO_SINK_COUNT,
 };
 
 /**
-- 
2.20.1



