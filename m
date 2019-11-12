Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71ADDF96DB
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 18:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfKLRQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 12:16:27 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:39464 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfKLRQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 12:16:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=uH5W4LkNdtmlBfQoOHJn/edsAOkKzKLZXq5jRsDbWtE=; b=DAxpL/uxjJcP
        lC8CSzjXVLzRXISiIMv6CaJYX61YHMYEijss9PmYIKd8VmgCJNN2n7ROsGSgmdXPoI+sxpZsgd2UT
        CkPrL/dFJPnUzl7wQMGedFAW6blx4EKzl2U7xUhmdz0T3slc3fQA0uqh5OV57c/dC6Cr7/GO5k2MC
        gYJhQ=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iUZm7-0008Ik-IP; Tue, 12 Nov 2019 17:16:19 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id AD4AE274299F; Tue, 12 Nov 2019 17:16:18 +0000 (GMT)
From:   Mark Brown <broonie@kernel.org>
To:     Pawel Harlozinski <pawel.harlozinski@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, broonie@kernel.org,
        cezary.rojewski@intel.com, lgirdwood@gmail.com,
        Mark Brown <broonie@kernel.org>, patch@alsa-project.org,
        pierre-louis.bossart@linux.intel.com, stable@vger.kernel.org,
        tiwai@suse.de
Subject: Applied "ASoC: Jack: Fix NULL pointer dereference in snd_soc_jack_report" to the asoc tree
In-Reply-To: <20191112130237.10141-1-pawel.harlozinski@linux.intel.com>
X-Patchwork-Hint: ignore
Message-Id: <20191112171618.AD4AE274299F@ypsilon.sirena.org.uk>
Date:   Tue, 12 Nov 2019 17:16:18 +0000 (GMT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: Jack: Fix NULL pointer dereference in snd_soc_jack_report

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-5.4

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From 8f157d4ff039e03e2ed4cb602eeed2fd4687a58f Mon Sep 17 00:00:00 2001
From: Pawel Harlozinski <pawel.harlozinski@linux.intel.com>
Date: Tue, 12 Nov 2019 14:02:36 +0100
Subject: [PATCH] ASoC: Jack: Fix NULL pointer dereference in
 snd_soc_jack_report

Check for existance of jack before tracing.
NULL pointer dereference has been reported by KASAN while unloading
machine driver (snd_soc_cnl_rt274).

Signed-off-by: Pawel Harlozinski <pawel.harlozinski@linux.intel.com>
Link: https://lore.kernel.org/r/20191112130237.10141-1-pawel.harlozinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 sound/soc/soc-jack.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/soc-jack.c b/sound/soc/soc-jack.c
index a71d2340eb05..b5748dcd490f 100644
--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -82,10 +82,9 @@ void snd_soc_jack_report(struct snd_soc_jack *jack, int status, int mask)
 	unsigned int sync = 0;
 	int enable;
 
-	trace_snd_soc_jack_report(jack, mask, status);
-
 	if (!jack)
 		return;
+	trace_snd_soc_jack_report(jack, mask, status);
 
 	dapm = &jack->card->dapm;
 
-- 
2.20.1

