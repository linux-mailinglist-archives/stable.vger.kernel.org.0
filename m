Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21E93A84F6
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbhFOPwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:52:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232230AbhFOPvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EF4F6162A;
        Tue, 15 Jun 2021 15:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772190;
        bh=wS3VcZXp4P18gbG9RtHlDEtp4jeWD3RNiZ7RWKuP4M0=;
        h=From:To:Cc:Subject:Date:From;
        b=DByPRe75xDZpjsOMzGw/WyXDhtbIj6S9af6wf4JsFK5z0KbnwDPGUnTA/7UA3uUeM
         ilBmVcVqWKLpGB4j4v/aQnVRdWssDiKIRmvax76slQUxBMFuhOVXV6njt56TMfc3zu
         FAMgZyjguKUYApN39jg5P0Q28JNXJZHGtcpnL6nV6KKm8aZW8bI94zezGNE0tcaOYq
         UTeM67m6gVikqY5hiqjZYaSOq390xD60rxntF0J4skcVrVe9KUDjghYPeYJi1oY0ls
         pSEKaypXp8cFe3jbynPtQnPm7uiUUJkr29wTpQGs88pA0jF2RSdU07aKvX/KN6lxTn
         0P8/ceLLJ5Bfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-power@fi.rohmeurope.com
Subject: [PATCH AUTOSEL 5.4 01/15] regulator: bd70528: Fix off-by-one for buck123 .n_voltages setting
Date:   Tue, 15 Jun 2021 11:49:33 -0400
Message-Id: <20210615154948.62711-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 0514582a1a5b4ac1a3fd64792826d392d7ae9ddc ]

The valid selectors for bd70528 bucks are 0 ~ 0xf, so the .n_voltages
should be 16 (0x10). Use 0x10 to make it consistent with BD70528_LDO_VOLTS.
Also remove redundant defines for BD70528_BUCK_VOLTS.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/20210523071045.2168904-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/rohm-bd70528.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/mfd/rohm-bd70528.h b/include/linux/mfd/rohm-bd70528.h
index b0109ee6dae2..1c3014d2f28b 100644
--- a/include/linux/mfd/rohm-bd70528.h
+++ b/include/linux/mfd/rohm-bd70528.h
@@ -25,9 +25,7 @@ struct bd70528_data {
 	struct mutex rtc_timer_lock;
 };
 
-#define BD70528_BUCK_VOLTS 17
-#define BD70528_BUCK_VOLTS 17
-#define BD70528_BUCK_VOLTS 17
+#define BD70528_BUCK_VOLTS 0x10
 #define BD70528_LDO_VOLTS 0x20
 
 #define BD70528_REG_BUCK1_EN	0x0F
-- 
2.30.2

