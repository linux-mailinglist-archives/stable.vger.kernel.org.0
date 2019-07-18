Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176ED6CF44
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 15:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfGRN6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 09:58:43 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:35723 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfGRN6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 09:58:43 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M9nhF-1hl4eX1Xhl-005qbW; Thu, 18 Jul 2019 15:58:04 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Marek Vasut <marek.vasut@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Rob Herring <robh@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] iio: adc: gyroadc: fix uninitialized return code
Date:   Thu, 18 Jul 2019 15:57:49 +0200
Message-Id: <20190718135758.2672152-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:JM097cnzQGpfM+Hac/hIIG18mQ4HhPRLCct4KRqjzaqPdDuTAip
 a0teCL3H3dp3EMCe9olVLWPa9ScXCIcwvQzKUGYLmXS7jV3cOxd4eVz5o5kpxHJZC3zL+J1
 kQonRFDz2hHhtkbK3UF33RLHpOdu/RRcEtwlVR297PXgvROZFINfzHbNJ6OYK1wpRJwOexU
 +IT5M0UICY1B9/AHhO7IQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ea3UsClCFDc=:zarfWa2lxFcPnH2AYhrGdB
 32iDl6jPFkxcAidEffksfGFkkj2kYn3u2/gMUg0Doe3hOOW2T/QqLNVmsvXeqysrBp3MMRb42
 zuPBPBFxfeuBZdrPnYkuruNVOFgpRLnvSZ9AjrnhbtCWODJ0l90vdW7gK6dhmyiirICIZ/NDc
 WUuMfBJw/2m0QJJn1SXo7tj/FLDfiNzsYizszTQeCmpgcztdJMGDDM3kwrApYSaa5/C/Wd/8x
 tZjCVud/c/wpUhmPQ4RG4x/Deh4Jdt3gmgic1puDtZexUhmm7kf2t0I52ZcQCOOPfh1EDtRzX
 HyxHLQKVJ+oS7G/AsfN6VRQ38HF3KvD1uTx6ZBCernb0AksprPf5vKsnDQn79nLDQaezXtWna
 qI+5QpUXUHrkIEUxpzkAJd5VaiAdpy69RJnlddNbQYuYfdG7C4uYytsEbi6z1uNO4vBhJA0PN
 eIWMh2Wvl1ilc0Vp+ctVlU+COOMZlCeTYkdEh64ssy6yboz49XmFHpZQ2vRZaF5R9CACJoZqM
 rrAMlc+4pBeZmfmS8BgF10s8uAQ0yhwBS2sQ60LO1mg4/u2veXuuEAs7cvJNT7WNTtWmUcTsf
 MBPc0zX5JY9Y2S9Pdjf5ojp0qf3AV/OqboKbo2kVG5+Lc1o6fYcQ50/UX4jbheYrvZ8qcDCj1
 C99zbhn1c38ll08ZYrxidsvWaoZ5g00IpMfRWZrO9HnWzRgxLHqpTZ1Qw+J4nUrmxxCvvpL4D
 1dZ5NB7vc5NN8rUC82V0bYYSAM8wHhSLbdURzw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

gcc-9 complains about a blatant uninitialized variable use that
all earlier compiler versions missed:

drivers/iio/adc/rcar-gyroadc.c:510:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]

Return -EINVAL instead here and a few lines above it where
we accidentally return 0 on failure.

Cc: stable@vger.kernel.org
Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: fix the second return code as well
---
 drivers/iio/adc/rcar-gyroadc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/rcar-gyroadc.c b/drivers/iio/adc/rcar-gyroadc.c
index 2d685730f867..c37f201294b2 100644
--- a/drivers/iio/adc/rcar-gyroadc.c
+++ b/drivers/iio/adc/rcar-gyroadc.c
@@ -382,7 +382,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 				dev_err(dev,
 					"Only %i channels supported with %pOFn, but reg = <%i>.\n",
 					num_channels, child, reg);
-				return ret;
+				return -EINVAL;
 			}
 		}
 
@@ -391,7 +391,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 			dev_err(dev,
 				"Channel %i uses different ADC mode than the rest.\n",
 				reg);
-			return ret;
+			return -EINVAL;
 		}
 
 		/* Channel is valid, grab the regulator. */
-- 
2.20.0

