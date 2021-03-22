Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031ED34434B
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhCVMtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231808AbhCVMf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C741619AF;
        Mon, 22 Mar 2021 12:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416541;
        bh=ugRlXikPfnsrw0I0DH5ZXQL9LcMyehcl8O9LBW1uq3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjLYA5XzqtYTIdcvlclQA0ffJEB5Orb1a6cdlQL+ZB51JcFB4yohaoT3wIMzugJc8
         /SBKFQX4b+USxfcCjyvvMykwrHrccmVPNXQ/M4pfT1AZP7Hvcc7vj7mU3cJ9aOidWn
         Y+NsC5tMjtyeIgMt0e5XJW0Tds8+LCj+vSiHkd5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 025/157] ASoC: Intel: bytcr_rt5640: Fix HP Pavilion x2 10-p0XX OVCD current threshold
Date:   Mon, 22 Mar 2021 13:26:22 +0100
Message-Id: <20210322121934.567621487@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit ca08ddfd961d2a17208d9182e0ee5791b39bd8bf upstream.

When I added the quirk for the "HP Pavilion x2 10-p0XX" I copied the
byt_rt5640_quirk_table[] entry for the HP Pavilion x2 10-k0XX / 10-n0XX
models since these use almost the same settings.

While doing this I accidentally also copied and kept the non-standard
OVCD_TH_1500UA setting used on those models. This too low threshold is
causing headsets to often be seen as headphones (without a headset-mic)
and when correctly identified it is causing ghost play/pause
button-presses to get detected.

Correct the HP Pavilion x2 10-p0XX quirk to use the default OVCD_TH_2000UA
setting, fixing these problems.

Fixes: fbdae7d6d04d ("ASoC: Intel: bytcr_rt5640: Fix HP Pavilion x2 Detachable quirks")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210224105052.42116-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -577,7 +577,7 @@ static const struct dmi_system_id byt_rt
 		},
 		.driver_data = (void *)(BYT_RT5640_DMIC1_MAP |
 					BYT_RT5640_JD_SRC_JD1_IN4P |
-					BYT_RT5640_OVCD_TH_1500UA |
+					BYT_RT5640_OVCD_TH_2000UA |
 					BYT_RT5640_OVCD_SF_0P75 |
 					BYT_RT5640_MCLK_EN),
 	},


