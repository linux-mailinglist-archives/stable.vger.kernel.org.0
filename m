Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08D52AD208
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 10:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgKJJFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 04:05:38 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:58402 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729902AbgKJJEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 04:04:21 -0500
X-UUID: 0d8bb3a431fb404e9bb9c1b01b7e6eb6-20201110
X-UUID: 0d8bb3a431fb404e9bb9c1b01b7e6eb6-20201110
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1250319375; Tue, 10 Nov 2020 17:04:17 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 10 Nov 2020 17:04:14 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Nov 2020 17:04:15 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexander Tsoy <alexander@tsoy.me>,
        Nicola Lunghi <nick83ola@gmail.com>,
        Christopher Swenson <swenson@swenson.io>,
        Nick Kossifidis <mickflemm@gmail.com>,
        <alsa-devel@alsa-project.org>
CC:     Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v3] ALSA: usb-audio: disable 96khz support for HUAWEI USB-C HEADSET
Date:   Tue, 10 Nov 2020 17:04:08 +0800
Message-ID: <1604999048-20294-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1604996266.2817.1.camel@mtkswgap22>
References: <1604996266.2817.1.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 3B1BA5211D1AEA1F9D389FD0B8F95556B1905E286E655FC53C5BEFF736FBB5782000:8
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The HUAWEI USB-C headset (VID:0x12d1, PID:0x3a07) reported it supports
96khz. However there will be some random issue under 96khz.
Not sure if there is any alternate setting could be applied.
Hence 48khz is suggested to be applied at this moment.

Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Signed-off-by: Eddie Hung <eddie.hung@mediatek.com>
Cc: stable@vger.kernel.org
---
Changes for v2:
  - Fix build error.
  - Add Cc: stable@vger.kernel.org
Changes for v3:
  - Replace "udev" with "chip->dev" according to Takashi's suggestion. Thanks.

 sound/usb/format.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index 1b28d01..0aff774 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -217,6 +217,11 @@ static int parse_audio_format_rates_v1(struct snd_usb_audio *chip, struct audiof
 			    (chip->usb_id == USB_ID(0x041e, 0x4064) ||
 			     chip->usb_id == USB_ID(0x041e, 0x4068)))
 				rate = 8000;
+			/* Huawei headset can't support 96kHz fully */
+			if (rate == 96000 &&
+			    chip->usb_id == USB_ID(0x12d1, 0x3a07) &&
+			    le16_to_cpu(chip->dev->descriptor.bcdDevice) == 0x49)
+				continue;
 
 			fp->rate_table[fp->nr_rates] = rate;
 			if (!fp->rate_min || rate < fp->rate_min)
-- 
1.7.9.5

