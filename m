Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2F3371BAE
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhECQrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232334AbhECQpr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:45:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B75D56161E;
        Mon,  3 May 2021 16:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059952;
        bh=+8Ak/gQ7R3xd2xD7Jm1k0nim9o8CSWY+VD9ZmUUgU00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6bx7hAS1C1a3pP+xUIlnUhzYM8f2tGhy3cO6DfWAvqVxGIalL8ouDl5q1bPj2HGL
         rOST2gT1rCyjSOydLH3+ktLBdikg50vnvAvFtrVwbaYfi50AMnFV7DcvtoQ5IUkH2J
         8v0dsq45z9MkSA3eh6EZgVgdjTcSe339lsPZzPomTrsNv8mzBItxO18VUl8lv6RU2D
         ON6IA9CvJIyc4+k7EaJOn1Avv0SOL4oTarcQ7py6+6dkvfePX5GB+Kr9HVJI1ZcgkB
         30M/T1JNOH8p43iKypgiABmgzJfxGoEtxb3KfSsg06peDylYxt6hXxeX/yesZdthaj
         rJpBY/xbkfrYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Obeida Shamoun <oshmoun100@googlemail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 028/100] backlight: qcom-wled: Use sink_addr for sync toggle
Date:   Mon,  3 May 2021 12:37:17 -0400
Message-Id: <20210503163829.2852775-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Obeida Shamoun <oshmoun100@googlemail.com>

[ Upstream commit cdfd4c689e2a52c313b35ddfc1852ff274f91acb ]

WLED3_SINK_REG_SYNC is, as the name implies, a sink register offset.
Therefore, use the sink address as base instead of the ctrl address.

This fixes the sync toggle on wled4, which can be observed by the fact
that adjusting brightness now works.

It has no effect on wled3 because sink and ctrl base addresses are the
same.  This allows adjusting the brightness without having to disable
then reenable the module.

Signed-off-by: Obeida Shamoun <oshmoun100@googlemail.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Kiran Gunda <kgunda@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 3bc7800eb0a9..83a187fdaa1d 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -336,13 +336,13 @@ static int wled3_sync_toggle(struct wled *wled)
 	unsigned int mask = GENMASK(wled->max_string_count - 1, 0);
 
 	rc = regmap_update_bits(wled->regmap,
-				wled->ctrl_addr + WLED3_SINK_REG_SYNC,
+				wled->sink_addr + WLED3_SINK_REG_SYNC,
 				mask, mask);
 	if (rc < 0)
 		return rc;
 
 	rc = regmap_update_bits(wled->regmap,
-				wled->ctrl_addr + WLED3_SINK_REG_SYNC,
+				wled->sink_addr + WLED3_SINK_REG_SYNC,
 				mask, WLED3_SINK_REG_SYNC_CLEAR);
 
 	return rc;
-- 
2.30.2

