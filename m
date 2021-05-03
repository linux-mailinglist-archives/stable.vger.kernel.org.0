Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAC7371A0E
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhECQig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231750AbhECQhl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:37:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D7B561278;
        Mon,  3 May 2021 16:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059781;
        bh=x6jVmx/J4JbZxJEqdMS3ZvsZJnhcow14iSOsNtD298I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4yU8yqSiClvGrYhOwHnv5k6cqHpX79sCKy3HDC5TmqJxvDNRwF95PodUIleHVMGX
         FTwUMLBVpwqBEsiYDjmA5XdWHb9BeozEr8cZMuj0VOQ7SFX8P3yTZhKEZdMhwHxgoM
         H0AcybwOOaZCngxm5Sb414x0Cx+1pQ4drRdrEzNcMxTsurdq8wHiHI3Eas/W88a5z8
         aQxXhQTQroU3BOUYpGv9QyYJZjKODRrFMaPS/Cba7KSTk/dG6uggUMSh88nGf6Gt4b
         Hgqia9UyaJ1pAhwHKmIa72seMpqi17RC0M/GmycvYRJhCYzcKyA7CKKSigIM65l8F3
         aKcqKdT1aAEaA==
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
Subject: [PATCH AUTOSEL 5.12 043/134] backlight: qcom-wled: Use sink_addr for sync toggle
Date:   Mon,  3 May 2021 12:33:42 -0400
Message-Id: <20210503163513.2851510-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
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
index 091f07e7c145..fc8b443d10fd 100644
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

