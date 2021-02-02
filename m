Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B05530C52B
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 17:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhBBQOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 11:14:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235131AbhBBPJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:09:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C602D64E06;
        Tue,  2 Feb 2021 15:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278384;
        bh=XYduWC12K8v5Yxck2JmTQP182pOqQ9sVEGNrfm3Bilo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FVY8bZaiIk3bMa/cDdya67ND8EzBq2AHxQgauwecDu11CESGNWZKcT6g9UaSfoX0g
         lX0CDdifF4UQYhVFx0Zq72YeYNn5dfX55BYivUaUwhSq317uK3ct6QPv1WurtU7HZ/
         vCkhOtwJ6MXrGPboR1qpCttAkR8KaXXPQmslBa42vEu0wRfx/Hn5Bz5JWeir6opzO2
         GigfHNRXGteOZQDSgmGQBCiAwKImNDKlELW5g1rFdHqxF/dB8mVkcYTE6w4YbFc5aa
         5yP1UlrBDBI17TLpv+G9JSKX9B0vCN/7+3iq51d7xFpDJuvQG1SDkQBFR4JV8kx4AI
         V2pax2UezS46g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 06/25] ASoC: Intel: Skylake: Zero snd_ctl_elem_value
Date:   Tue,  2 Feb 2021 10:05:56 -0500
Message-Id: <20210202150615.1864175-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 1d8fe0648e118fd495a2cb393a34eb8d428e7808 ]

Clear struct snd_ctl_elem_value before calling ->put() to avoid any data
leak.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210121171644.131059-2-ribalda@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl-topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/skylake/skl-topology.c
index 40bee10b0c65a..1bde9ce04de33 100644
--- a/sound/soc/intel/skylake/skl-topology.c
+++ b/sound/soc/intel/skylake/skl-topology.c
@@ -3631,7 +3631,7 @@ static void skl_tplg_complete(struct snd_soc_component *component)
 		sprintf(chan_text, "c%d", mach->mach_params.dmic_num);
 
 		for (i = 0; i < se->items; i++) {
-			struct snd_ctl_elem_value val;
+			struct snd_ctl_elem_value val = {};
 
 			if (strstr(texts[i], chan_text)) {
 				val.value.enumerated.item[0] = i;
-- 
2.27.0

