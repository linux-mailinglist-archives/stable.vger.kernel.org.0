Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16F726F3ED
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgIRDKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbgIRCCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21EF722211;
        Fri, 18 Sep 2020 02:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394564;
        bh=kvljy/+dKd5hVOBCgeK3ADPEBHeF/kDaMYGcYzXQcjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2M8ZSs8dPKaXlTLyyqTSsGcztx/u+DBwbR4YMLdG6fuDvwcK6Kyb+/+SfovXKFu+
         1dOKpJ7jLpcTY4oL1HLSz5LQmjVYeaVhhDfmBe7lsK1M+BqV56oOi5fNwemUKyWuvs
         quve2Hk4vh/sty9gVDcSRF2ljJ5ZPVqmTFNeDGsA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 077/330] ALSA: hda: enable regmap internal locking
Date:   Thu, 17 Sep 2020 21:56:57 -0400
Message-Id: <20200918020110.2063155-77-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 8e85def5723eccea30ebf22645673692ab8cb3e2 ]

This reverts commit 42ec336f1f9d ("ALSA: hda: Disable regmap
internal locking").

Without regmap locking, there is a race between snd_hda_codec_amp_init()
and PM callbacks issuing regcache_sync(). This was caught by
following kernel warning trace:

<4> [358.080081] WARNING: CPU: 2 PID: 4157 at drivers/base/regmap/regcache.c:498 regcache_cache_only+0xf5/0x130
[...]
<4> [358.080148] Call Trace:
<4> [358.080158]  snd_hda_codec_amp_init+0x4e/0x100 [snd_hda_codec]
<4> [358.080169]  snd_hda_codec_amp_init_stereo+0x40/0x80 [snd_hda_codec]

Suggested-by: Takashi Iwai <tiwai@suse.de>
BugLink: https://gitlab.freedesktop.org/drm/intel/issues/592
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200108180856.5194-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_regmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/hda/hdac_regmap.c b/sound/hda/hdac_regmap.c
index 2596a881186fa..49780399c2849 100644
--- a/sound/hda/hdac_regmap.c
+++ b/sound/hda/hdac_regmap.c
@@ -363,7 +363,6 @@ static const struct regmap_config hda_regmap_cfg = {
 	.reg_write = hda_reg_write,
 	.use_single_read = true,
 	.use_single_write = true,
-	.disable_locking = true,
 };
 
 /**
-- 
2.25.1

