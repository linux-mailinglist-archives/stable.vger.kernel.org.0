Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D2237D29C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351557AbhELSKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234717AbhELSEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:04:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D997261459;
        Wed, 12 May 2021 18:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842612;
        bh=EQPb0LS5yS0txYFmXo3IrXYTpn1bwE76ZcoCtOqEZjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0gmKMe6iAGFdj6QKqxXynfS7VzFxS3Gq9glzuSnZXk83rPs6PpYKA9x22IkPnO8r
         /VY/VnwpDSOboEzxNQz7DyFRVTpzBRGENOIgYx5qMaGioxsNI6zWETp1ZxTEQjDMhS
         8qAwBRGpSCYn8W365Xl9OJ5cqYgQcB941rjbGmxeo7fmvOBEYweKPRAOODyIz/L1Ti
         HQ2193bG94Ry1j3/8L0q0YiXMqzMQWlD7RS/JvFUFYEwfD1o7HFnS/mkAgWG1Kx8xh
         dpy0QbkCSJXSYUatM7QBUs6nPX6J2bB6REWpQP58znBzcUEtkL+x8EYmSNXK03LthN
         Jwy/sS5F1hsLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prashant Malani <pmalani@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 15/34] platform/chrome: cros_ec_typec: Add DP mode check
Date:   Wed, 12 May 2021 14:02:46 -0400
Message-Id: <20210512180306.664925-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180306.664925-1-sashal@kernel.org>
References: <20210512180306.664925-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit c5bb32f57bf3a30ed03be51f7be0840325ba8b4a ]

There are certain transitional situations where the dp_mode field in the
PD_CONTROL response might not be populated with the right DP pin
assignment value yet. Add a check for that to avoid sending an invalid
value to the Type C mode switch.

Signed-off-by: Prashant Malani <pmalani@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20210421042108.2002-1-pmalani@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 31be31161350..036d54dc52e2 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -475,6 +475,11 @@ static int cros_typec_enable_dp(struct cros_typec_data *typec,
 		return -ENOTSUPP;
 	}
 
+	if (!pd_ctrl->dp_mode) {
+		dev_err(typec->dev, "No valid DP mode provided.\n");
+		return -EINVAL;
+	}
+
 	/* Status VDO. */
 	dp_data.status = DP_STATUS_ENABLED;
 	if (port->mux_flags & USB_PD_MUX_HPD_IRQ)
-- 
2.30.2

