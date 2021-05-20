Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43A438A0E4
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhETJ0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:26:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231728AbhETJ02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DCA661279;
        Thu, 20 May 2021 09:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502706;
        bh=nh6yfeo9p8fhVXs4+VMW8XIogZNSnvO99hWLjAPOlf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSFqGHSX1V3DO4B0DDrD97e/ec+3HaZKaXkK+AoukiwLsjGVYlTpF0Qdq+kcJZ1th
         YAKHrGqRIdAW1mRJ+opLV/NGacPpz/rkuJvcQ3EyFKWtBTSyfsEK9cg6TeWBsbPSwk
         oxVEpseN16lvQlQDzln0T1gWFfXRsRUhNQ1EoiJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prashant Malani <pmalani@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 22/45] platform/chrome: cros_ec_typec: Add DP mode check
Date:   Thu, 20 May 2021 11:22:10 +0200
Message-Id: <20210520092054.240011519@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



