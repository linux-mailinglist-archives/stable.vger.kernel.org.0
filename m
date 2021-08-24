Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFC23F662A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239816AbhHXRVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238456AbhHXRTE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:19:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91D0661ADF;
        Tue, 24 Aug 2021 17:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824582;
        bh=tKts5oqwewSpXX9bihIZgbewZ3j3CQ8VSZOceKI322s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icBEbJ8kSVh07rTJC9PQek2z8q3T4GW51gdcvyZe8uLd0YLFlkkdfSofft9aBsjZ6
         gEFVoBNy3lCocWqTynUZbiSpmuFp68sWVR3QGCiglvCyy+1xmtT8MrQrdzsBMPGEh8
         SbAXZdSgQ3QypwcIsKbSLsoXs5D7CpLz6NbyNrk/rBNxSSEWqePzeM/jR5mnzjOWst
         OnlIVy6SvayVFTOONq6eGKcwGHZ4HHWbfmoB2XhoCv02cPvY49n+pGua/tbxc4G9kG
         OjznDgrGg63IkLQoqW/KMaZipkZwgRVSBRlYn5bBV+ecOr55aUXeS1oZBxhjLp8oOp
         js/SmlIPnv9nA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/84] ASoC: cs42l42: Fix inversion of ADC Notch Switch control
Date:   Tue, 24 Aug 2021 13:01:36 -0400
Message-Id: <20210824170250.710392-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 30615bd21b4cc3c3bb5ae8bd70e2a915cc5f75c7 ]

The underlying register field has inverted sense (0 = enabled) so
the control definition must be marked as inverted.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Link: https://lore.kernel.org/r/20210803160834.9005-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index ca6541ac59e1..c11e60e9fe4e 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -436,7 +436,7 @@ static SOC_ENUM_SINGLE_DECL(cs42l42_wnf05_freq_enum, CS42L42_ADC_WNF_HPF_CTL,
 static const struct snd_kcontrol_new cs42l42_snd_controls[] = {
 	/* ADC Volume and Filter Controls */
 	SOC_SINGLE("ADC Notch Switch", CS42L42_ADC_CTL,
-				CS42L42_ADC_NOTCH_DIS_SHIFT, true, false),
+				CS42L42_ADC_NOTCH_DIS_SHIFT, true, true),
 	SOC_SINGLE("ADC Weak Force Switch", CS42L42_ADC_CTL,
 				CS42L42_ADC_FORCE_WEAK_VCM_SHIFT, true, false),
 	SOC_SINGLE("ADC Invert Switch", CS42L42_ADC_CTL,
-- 
2.30.2

