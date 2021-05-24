Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A03438EB2B
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbhEXPA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233186AbhEXO6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:58:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B66846145B;
        Mon, 24 May 2021 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867775;
        bh=xREFaCMaLWM/2YnYtITeZ1ZRzmhMIEUflE2ubsuIT8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqRxSmSrMTGrTnFyC3cAagOP5RVTMchylx1slY8v04UZm8w+ujQn7OysT3Tye40g/
         4G944hcZPaLVFyEBKHOcMT76sct6RP/qnFuA58uRTdSUd4b/969qtMpEifRQP9ZuYs
         xRGYz+IaG6DQsqc1SFaNveWdCAK4cisPKLG/CbIvspFxjkzPRWkDuXbWlx0tsq+j3y
         dfAZjUWmDouCCkdDA7bVZqtPUd5JFeRXIOorRepevY+AjPnHpzfHdx+32N+2OYU6Vo
         kHsLeucX9gASbIk9+Zo0ijH7DsG9Xiymug36+I4TGR9UU2KcMCGAJ/upB/kjzmUbzD
         T1GEJChbQqn7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 26/52] Revert "ASoC: rt5645: fix a NULL pointer dereference"
Date:   Mon, 24 May 2021 10:48:36 -0400
Message-Id: <20210524144903.2498518-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 1e0ce84215dbfd6065872e5d3755352da34f198b ]

This reverts commit 51dd97d1df5fb9ac58b9b358e63e67b530f6ae21.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

Lots of things seem to be still allocated here and must be properly
cleaned up if an error happens here.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-55-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index c83f7f5da96b..44e88d0dbb7a 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3419,9 +3419,6 @@ static int rt5645_probe(struct snd_soc_component *component)
 		RT5645_HWEQ_NUM, sizeof(struct rt5645_eq_param_s),
 		GFP_KERNEL);
 
-	if (!rt5645->eq_param)
-		return -ENOMEM;
-
 	return 0;
 }
 
-- 
2.30.2

