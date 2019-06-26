Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD2C560EC
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfFZDuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbfFZDmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:42:45 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0EAC205ED;
        Wed, 26 Jun 2019 03:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520564;
        bh=AarvZG2NZ422+D4FObF+VfCAtcqlVfY3f9aW0cHglZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqUJ9GEaAabHGvakQgZngp2sMeqR0X3sHPALu0je+UcIBqOlMWWsKc1+G7Zox3S1w
         zH7C/wQyCQCTaGh5crwGJx/1pZlHydUJUvQH6Lh5xfuzqcRQ5bw9N4JhidxQ2QnGfU
         pF8B4q2mZt7CRn4HHCKIvLXAjEG6O2pKooRbm/34=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 30/51] ASoC: Intel: cht_bsw_rt5672: fix kernel oops with platform_name override
Date:   Tue, 25 Jun 2019 23:40:46 -0400
Message-Id: <20190626034117.23247-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 9bbc799318a34061703f2a980e2b6df7fc6760f0 ]

The platform override code uses devm_ functions to allocate memory for
the new name but the card device is not initialized. Fix by moving the
init earlier.

Fixes: f403906da05cd ("ASoC: Intel: cht_bsw_rt5672: platform name fixup support")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/cht_bsw_rt5672.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/cht_bsw_rt5672.c b/sound/soc/intel/boards/cht_bsw_rt5672.c
index 3d5a2b3a06f0..87ce3857376d 100644
--- a/sound/soc/intel/boards/cht_bsw_rt5672.c
+++ b/sound/soc/intel/boards/cht_bsw_rt5672.c
@@ -425,6 +425,7 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 	}
 
 	/* override plaform name, if required */
+	snd_soc_card_cht.dev = &pdev->dev;
 	platform_name = mach->mach_params.platform;
 
 	ret_val = snd_soc_fixup_dai_links_platform_name(&snd_soc_card_cht,
@@ -442,7 +443,6 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 	snd_soc_card_set_drvdata(&snd_soc_card_cht, drv);
 
 	/* register the soc card */
-	snd_soc_card_cht.dev = &pdev->dev;
 	ret_val = devm_snd_soc_register_card(&pdev->dev, &snd_soc_card_cht);
 	if (ret_val) {
 		dev_err(&pdev->dev,
-- 
2.20.1

