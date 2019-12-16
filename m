Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7B81215CA
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbfLPSYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:24:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731875AbfLPSTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:19:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29A72206EC;
        Mon, 16 Dec 2019 18:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520339;
        bh=I/aQZOgdx/StfqxD/zjch/Q7mN7Mb/s/G1BBWN5EtvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6LePJr0asZSvtjG8vqqqS3j1NRoFmt4y4JmRqZijkPWAH5/duozshCO+HpABRbmx
         Ib4CGVwedv188nBwayWeeWdOhUPFmenqfOxjsiVCOxJZkJ26A0ZKRkRRz6xgEDmztD
         7Jzc+EYF1R6mt2exNAp4A22HUugMQmQrqf3PnKDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Rasmussen <jacobraz@google.com>,
        Ross Zwisler <zwisler@google.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 087/177] ASoC: rt5645: Fixed buddy jack support.
Date:   Mon, 16 Dec 2019 18:49:03 +0100
Message-Id: <20191216174838.656873901@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Rasmussen <jacobraz@chromium.org>

commit e7cfd867fd9842f346688f28412eb83dec342900 upstream.

The headphone jack on buddy was broken with the following commit:
commit 6b5da66322c5 ("ASoC: rt5645: read jd1_1 status for jd
detection").
This changes the jd_mode for buddy to 4 so buddy can read from the same
register that was used in the working version of this driver without
affecting any other devices that might use this, since no other device uses
jd_mode = 4. To test this I plugged and uplugged the headphone jack, verifying
audio works.

Signed-off-by: Jacob Rasmussen <jacobraz@google.com>
Reviewed-by: Ross Zwisler <zwisler@google.com>
Link: https://lore.kernel.org/r/20191111185957.217244-1-jacobraz@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/rt5645.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3270,6 +3270,9 @@ static void rt5645_jack_detect_work(stru
 		snd_soc_jack_report(rt5645->mic_jack,
 				    report, SND_JACK_MICROPHONE);
 		return;
+	case 4:
+		val = snd_soc_component_read32(rt5645->component, RT5645_A_JD_CTRL1) & 0x002;
+		break;
 	default: /* read rt5645 jd1_1 status */
 		val = snd_soc_component_read32(rt5645->component, RT5645_INT_IRQ_ST) & 0x1000;
 		break;
@@ -3603,7 +3606,7 @@ static const struct rt5645_platform_data
 static const struct rt5645_platform_data buddy_platform_data = {
 	.dmic1_data_pin = RT5645_DMIC_DATA_GPIO5,
 	.dmic2_data_pin = RT5645_DMIC_DATA_IN2P,
-	.jd_mode = 3,
+	.jd_mode = 4,
 	.level_trigger_irq = true,
 };
 
@@ -3999,6 +4002,7 @@ static int rt5645_i2c_probe(struct i2c_c
 					   RT5645_JD1_MODE_1);
 			break;
 		case 3:
+		case 4:
 			regmap_update_bits(rt5645->regmap, RT5645_A_JD_CTRL1,
 					   RT5645_JD1_MODE_MASK,
 					   RT5645_JD1_MODE_2);


