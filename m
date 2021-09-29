Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26C341CD47
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 22:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346609AbhI2URA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 16:17:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346513AbhI2URA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 16:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632946518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=c1ABNFoBo1LgtH8KX+kiNf5MSzSI0rhiaZugaCCGFME=;
        b=U3Sw6Wfj1dGKqaAu7ZYt52W0NbpkZMMqEVeHe275TmG6DmYckwaBl3/7CjCHQ4iDkH5pCp
        0AQ96B70fZf9RHvrrQ8yGjvAn8y6W34flBdg2lGNPRRP+Bd7OddhvxZ3XUFOD442Kbs1rE
        m4xH8pTlkgiN8r07EEmyqBJ1DrSshbQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-OIOOsasNPbi_UcqAI0mVtg-1; Wed, 29 Sep 2021 16:15:17 -0400
X-MC-Unique: OIOOsasNPbi_UcqAI0mVtg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B32981450F;
        Wed, 29 Sep 2021 20:15:15 +0000 (UTC)
Received: from x1.localdomain (unknown [10.39.194.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4E4618EC5;
        Wed, 29 Sep 2021 20:15:13 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH regression fix] ASoC: nau8824: Fix headphone vs headset, button-press detection no longer working
Date:   Wed, 29 Sep 2021 22:15:12 +0200
Message-Id: <20210929201512.460360-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 sound/soc/codecs/nau8824.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/nau8824.c b/sound/soc/codecs/nau8824.c
index cea1d43e0cb8..77f647529354 100644
--- a/sound/soc/codecs/nau8824.c
+++ b/sound/soc/codecs/nau8824.c
@@ -874,8 +874,8 @@ static void nau8824_jdet_work(struct work_struct *work)
 	struct regmap *regmap = nau8824->regmap;
 	int adc_value, event = 0, event_mask = 0;
 
-	snd_soc_dapm_enable_pin(dapm, "MICBIAS");
-	snd_soc_dapm_enable_pin(dapm, "SAR");
+	snd_soc_dapm_force_enable_pin(dapm, "MICBIAS");
+	snd_soc_dapm_force_enable_pin(dapm, "SAR");
 	snd_soc_dapm_sync(dapm);
 
 	msleep(100);
-- 
2.31.1

