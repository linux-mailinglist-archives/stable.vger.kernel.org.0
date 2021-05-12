Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E94F37D24B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237805AbhELSIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352168AbhELSCj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:02:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6678D6142D;
        Wed, 12 May 2021 18:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842491;
        bh=nh6yfeo9p8fhVXs4+VMW8XIogZNSnvO99hWLjAPOlf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPLmhIFbxjGFD6rPsFmrvKvtD6m2yDVyG8bzkzKUCUbhkZJAGa/nme8Pm1Ma479Gw
         /i5YOUADNUlYRjigFHxe5Gl9iUHD6Zzb59fadoTukRlagO8sJoJeIzE7D6pTG82gla
         rpScw7inoQz7QcOw5MzhiElQVWJ5KmyDYc+YNBV62ryasok4c6d8APinUiSLdP5fxz
         +7hWBtBT6lOSeXC7QOAKa7oshRhvkhed+yLas/TKCJJdNpWvPrjecA+Rx85FXACdMm
         4FsLyEr5ZTfS3WEKNENotYkJH2/wolo9MiLw93Y7C1cOT0pNlwHbN9/bz5/p5rICNP
         XXYWM1t5it0Qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prashant Malani <pmalani@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 18/37] platform/chrome: cros_ec_typec: Add DP mode check
Date:   Wed, 12 May 2021 14:00:45 -0400
Message-Id: <20210512180104.664121-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180104.664121-1-sashal@kernel.org>
References: <20210512180104.664121-1-sashal@kernel.org>
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
index 0811562deecc..24be8f550ae0 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -483,6 +483,11 @@ static int cros_typec_enable_dp(struct cros_typec_data *typec,
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

