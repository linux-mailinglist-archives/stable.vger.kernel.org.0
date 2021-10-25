Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20D843A2A1
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238066AbhJYTun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238330AbhJYTsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:48:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF45C610F8;
        Mon, 25 Oct 2021 19:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190861;
        bh=rv2NPfVC2HSHDVBMPz7O055TEb+8/M5TGlQ4Vu98OEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tfgVomYRhUq5EUO3iE2eFzEw6iG1fq4tfAWjMSgi9UaUBzULaanr+A+gRAE4RNqV9
         mFU/b4Tvx8dUQtnhLsI9J+HSXDrZijz/qg5C6McCSMoZ/6TbO8188VdSrdMRAh6K6f
         GboNjpV7OXXedDFqt509npwBl1WYi4cA+vppP+3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.14 089/169] ASoC: nau8824: Fix headphone vs headset, button-press detection no longer working
Date:   Mon, 25 Oct 2021 21:14:30 +0200
Message-Id: <20211025191028.473126387@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 42871e95a3afea8956d8cc567ea725b33a837775 upstream.

Commit 1d25684e2251 ("ASoC: nau8824: Fix open coded prefix handling")
replaced the nau8824_dapm_enable_pin() helper with direct calls to
snd_soc_dapm_enable_pin(), but the helper was using
snd_soc_dapm_force_enable_pin() and not forcing the MICBIAS + SAR
supplies on breaks headphone vs headset and button-press detection.

Replace the snd_soc_dapm_enable_pin() calls with
snd_soc_dapm_force_enable_pin() to fix this.

Cc: stable@vger.kernel.org
Fixes: 1d25684e2251 ("ASoC: nau8824: Fix open coded prefix handling")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210929201512.460360-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/nau8824.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/nau8824.c
+++ b/sound/soc/codecs/nau8824.c
@@ -867,8 +867,8 @@ static void nau8824_jdet_work(struct wor
 	struct regmap *regmap = nau8824->regmap;
 	int adc_value, event = 0, event_mask = 0;
 
-	snd_soc_dapm_enable_pin(dapm, "MICBIAS");
-	snd_soc_dapm_enable_pin(dapm, "SAR");
+	snd_soc_dapm_force_enable_pin(dapm, "MICBIAS");
+	snd_soc_dapm_force_enable_pin(dapm, "SAR");
 	snd_soc_dapm_sync(dapm);
 
 	msleep(100);


