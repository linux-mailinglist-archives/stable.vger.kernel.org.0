Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30D13A845E
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhFOPud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231807AbhFOPud (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:50:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C470B6142E;
        Tue, 15 Jun 2021 15:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772108;
        bh=O2XPWVWlhWU/2tR7FC3Y/YzLoTfXutzXfOlO4TyzjLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmQVrkMTWsHkY428FqvWUYxwuCxV/ykS/B7Z24WVnv8EMNUdblJU3hbQ49weimZKY
         ny7EziLLSeS3oyjZ3C6Y53Oq/wOgBVBt5kMhhLTrBF/G+C7nKt1sK9bvy9CvaKdP8m
         qJHN0zTQb8epcgHGaldeLMIqafLrnFK+/6IaCRYLlsfhASwKL76SiICKNiRiIKdGYB
         u3OvaGXJyzjQH9iIA4kQHBCY5eTEfOEnHP0MZQFdNbnwd8V6c26M/MmIJ1rGRMV+Gk
         ReZ7fXWU3fk2SqrBiP9vnA/tyOlo8SjEzuniILhZvD3umT2tx8HHTq0f0mMArc0FhR
         DwuOzPebIrBIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-power@fi.rohmeurope.com
Subject: [PATCH AUTOSEL 5.12 03/33] regulator: bd70528: Fix off-by-one for buck123 .n_voltages setting
Date:   Tue, 15 Jun 2021 11:47:54 -0400
Message-Id: <20210615154824.62044-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
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
index a57af878fd0c..4a5966475a35 100644
--- a/include/linux/mfd/rohm-bd70528.h
+++ b/include/linux/mfd/rohm-bd70528.h
@@ -26,9 +26,7 @@ struct bd70528_data {
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

