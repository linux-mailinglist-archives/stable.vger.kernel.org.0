Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F756D8C64
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 11:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfJPJUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 05:20:32 -0400
Received: from mail1.skidata.com ([91.230.2.99]:19987 "EHLO mail1.skidata.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfJPJUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 05:20:31 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Oct 2019 05:20:31 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=skidata.com; i=@skidata.com; q=dns/txt; s=selector1;
  t=1571217631; x=1602753631;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kKIuy6KHImHHQv8CRduIvGuN6BHhgWA18/nOgMiEItI=;
  b=FXSR/VScbb5tNM8MrimcwM3Q7tm6rhZSNuUIRFcxht8nf7CEav/bDEZl
   Of1/qsSt4hsNbYOU0SCpBd0yKuyl76HxHTQZsy7cytRX/+umNoodxWQhq
   5Cw4RfKvYY097TIyo7xA+8FT1eoI1PRwUCxiyfP+6zmHja5ItQsw2bjAO
   er6MF/wAykqrxaMVMTdYgKSHnlf756/DPYGDQrJ9atlY/cJN64+qNx+Zc
   5GAXOIYwiTSl0D+dXhUgofTPZSazkkyNmEjflZgg9L/vXH56arp2o+Q9U
   L4qoI8wIP6yUhFC5YauyVzSxNnVfOtRnR4d2QOqnDYepH+NWqI5faPgzk
   A==;
IronPort-SDR: qNGUlV/AfLiwMs+w8r2vA/UExC2ZaWjO5V1PGrkkN2PW4suNle81PyESJSG1SHJoEx1+Cccpmq
 rb+mimXGlno5cekbWkx+/zEepLdrMNkoVJAARODs5e5rB9QZV5g/cCT/2VOq7lF8OKfE1KvGwn
 b8TLl7EIsFA9yvU6BteH1gx99B8yElHm1LK2vmz0wbmCkG9eMWbXdjYsJTN7Mwzg7vhMHUl3xi
 ra/UI6lVoyvtiDB6DtLVLVimLTfeNRgzJobvrhLnunlSsBYBfTTQzK0LCwm6QG+aNpwCPG618L
 o+E=
X-IronPort-AV: E=Sophos;i="5.67,303,1566856800"; 
   d="scan'208";a="20289456"
From:   Richard Leitner <richard.leitner@skidata.com>
To:     <stable@vger.kernel.org>
CC:     <festevam@gmail.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Richard Leitner <richard.leitner@skidata.com>
Subject: [PATCH v5.3] ASoC: sgtl5000: add ADC mute control
Date:   Wed, 16 Oct 2019 11:13:04 +0200
Message-ID: <20191016091304.15870-1-richard.leitner@skidata.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [192.168.111.252]
X-ClientProxiedBy: sdex5srv.skidata.net (192.168.111.83) To
 sdex5srv.skidata.net (192.168.111.83)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>

Upstream commit 631bc8f0134a ("ASoC: sgtl5000: Fix of unmute outputs on
probe"), which is e9f621efaebd in v5.3 replaced snd_soc_component_write
with snd_soc_component_update_bits and therefore no longer cleared the
MUTE_ADC flag. This caused the ADC to stay muted and recording doesn't
work any longer. This patch fixes this problem by adding a Switch control
for MUTE_ADC.

commit 694b14554d75 ("ASoC: sgtl5000: add ADC mute control") upstream

This control mute/unmute the ADC input of SGTL5000
using its CHIP_ANA_CTRL register.

Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Reviewed-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Reviewed-by: Igor Opaniuk <igor.opaniuk@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20190719100524.23300-5-oleksandr.suvorov@toradex.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Richard Leitner <richard.leitner@skidata.com>
Fixes: e9f621efaebd ("ASoC: sgtl5000: Fix of unmute outputs on probe")
---
 sound/soc/codecs/sgtl5000.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 3f28e7862b5b..b65232521ea8 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -720,6 +720,7 @@ static const struct snd_kcontrol_new sgtl5000_snd_controls[] = {
 			SGTL5000_CHIP_ANA_ADC_CTRL,
 			8, 1, 0, capture_6db_attenuate),
 	SOC_SINGLE("Capture ZC Switch", SGTL5000_CHIP_ANA_CTRL, 1, 1, 0),
+	SOC_SINGLE("Capture Switch", SGTL5000_CHIP_ANA_CTRL, 0, 1, 1),
 
 	SOC_DOUBLE_TLV("Headphone Playback Volume",
 			SGTL5000_CHIP_ANA_HP_CTRL,
-- 
2.21.0

