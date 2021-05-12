Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAAE37D274
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348095AbhELSJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:09:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352593AbhELSDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:03:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88FB461412;
        Wed, 12 May 2021 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842552;
        bh=rab2UtRqDZD7ZZ8okoZQ2shR0h8DoPfnYuvXNZV7+C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4ecIn0KSAJy37k+jqJTVO1RtzwbLKBuWWyY8cNOKSTPJDUxwPJFeXeoGiagaqW06
         qFY0gz8OupO/XNinDe04WofDmkPLIbWFBF5a9buKW1trbTcHK25xuphurppqfLqXYt
         PSl4d+owGUM7UUaxDXmqgU+CMcd76tNINXpltbr6BZlfgiHF8HDGXZQiODDhv20zWg
         0DwoeMC83c9ZP7xjMOfgrHrrD6TcBAcq1sLDa0PPavwTSH2dnwnVTtU6yo7x5Atz1M
         I9lhmve5FUEdc3XdeaJryBwUQUkOSFh6H7OVvYPd1haXFYzEohIsK2wV1Q43IX1qkM
         gROdYUC9JKoyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prashant Malani <pmalani@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 16/35] platform/chrome: cros_ec_typec: Add DP mode check
Date:   Wed, 12 May 2021 14:01:46 -0400
Message-Id: <20210512180206.664536-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
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
index c43868615790..d254c88aea1d 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -447,6 +447,11 @@ static int cros_typec_enable_dp(struct cros_typec_data *typec,
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

