Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281A7440E2
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388382AbfFMQKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:32942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731252AbfFMIn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:43:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68F352063F;
        Thu, 13 Jun 2019 08:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415435;
        bh=HbA5eCN6xurGIQ6BGkFFfMgHr7GRTlSAQnHbchCGmoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPYIolrnUYjZmwgb7kBHVnE1dG/pcendQd/6jQ8CUzbhknlmvNNVpgz0vZmyT7Z3a
         28OWpqN7o/HABv5f4rgdVslK6iEA68itV+oqVL+Zcbefbx7J9GBLKJAnCmjxeUvpps
         hv3rWJhFOvJwlx0epghKvxwqmlgygcIVIVdYCsdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christoph=20Vogtl=C3=A4nder?= 
        <c.vogtlaender@sigma-surface-science.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/118] pwm: tiehrpwm: Update shadow register for disabling PWMs
Date:   Thu, 13 Jun 2019 10:34:04 +0200
Message-Id: <20190613075650.237590427@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b00ef53053191d3025c15e8041699f8c9d132daf ]

It must be made sure that immediate mode is not already set, when
modifying shadow register value in ehrpwm_pwm_disable(). Otherwise
modifications to the action-qualifier continuous S/W force
register(AQSFRC) will be done in the active register.
This may happen when both channels are being disabled. In this case,
only the first channel state will be recorded as disabled in the shadow
register. Later, when enabling the first channel again, the second
channel would be enabled as well. Setting RLDCSF to zero, first, ensures
that the shadow register is updated as desired.

Fixes: 38dabd91ff0b ("pwm: tiehrpwm: Fix disabling of output of PWMs")
Signed-off-by: Christoph Vogtländer <c.vogtlaender@sigma-surface-science.com>
[vigneshr@ti.com: Improve commit message]
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tiehrpwm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index f7b8a86fa5c5..ad4a40c0f27c 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -382,6 +382,8 @@ static void ehrpwm_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	}
 
 	/* Update shadow register first before modifying active register */
+	ehrpwm_modify(pc->mmio_base, AQSFRC, AQSFRC_RLDCSF_MASK,
+		      AQSFRC_RLDCSF_ZRO);
 	ehrpwm_modify(pc->mmio_base, AQCSFRC, aqcsfrc_mask, aqcsfrc_val);
 	/*
 	 * Changes to immediate action on Action Qualifier. This puts
-- 
2.20.1



