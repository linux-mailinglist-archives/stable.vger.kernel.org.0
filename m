Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38AA5F747
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 13:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfGDLio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 07:38:44 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:37417 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbfGDLio (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 07:38:44 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MMGAg-1hzyic1MGM-00JKWZ; Thu, 04 Jul 2019 13:38:08 +0200
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
        Rob Herring <robh@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iio: adc: gyroadc: fix uninitialized return code
Date:   Thu,  4 Jul 2019 13:37:47 +0200
Message-Id: <20190704113800.3299636-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:h9aKGiMAS6Xlil+2UxkJhJCnUoDDgR+JZ2AvN4jHsrCx8ckyZuS
 yTEZldLJ/UP6OFu9DOsy4VetZ/N0GFIf9RT57cxc+NW20LzRCQC2iRf4QEYCBTQtaQBnhZs
 Qej58IDikUem+RSWapqZYEEPHFnIdfcBlPm6CdrxZCiXwsHI9nhtiidJFXsoxZ9sssiflqh
 O+kzS9bxP3uF49LI2VnMg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:CrZfIuHva64=:k5xMOa0IWCAKm3yNcyNVYf
 dL5/tWOzmLrqTaBpZz3j4i+7oSpo/kGE+TRdCrBIy+mRYkOoR66SojF8+bHRg4tJmlIfTB4bu
 /LJUeYEPmBC3TzvvYEgGQM1F/aYhqm5l3wIzgrv8mrZB5DVaM0wZZMVlPR+vDO7cUXoaH6/VZ
 LbFl4Lm+dMElV2jR36wM/iCSk5x6yf/BD+6XB14vBrcwjcPVSsIVlAg5wKr0CHKYOz9Q9OKZj
 JVd4WiEXAsjI6a69+zqa/CiiaC62QObwPoTbMP1SopA9WfgeAF0BroPsPwspNF4U3vNABxXLj
 1/lR+ZDvw459rku6B4R1FWzmwbJPJekjIZI5kpmHS4A73dfsSGEUfi0Hh8fzCC6L7h714Tgui
 3r4gZDBtTkTnyA8TqQiLuHChbrCwxN6tHWWzg4SsRY+kM4f/nTV2Pm+gPijhs0iyT56qjyAkw
 W5KecNpVD7qDDFm1tGLhbIpwko9PXKHQJelmmwNFPyaQyUCWCQbt3voWVUVELVT5OGSN7GSdX
 Ynb7N2FBnyhCOu5U1TFVMFu2XT26DQSA+t84FLiVWnGQftDxeQO3P2wEtATD0rOYnviddIQ5r
 Lyv5E1qOtJUtPG/cDAQNbCZGyftkfo8NkGD4cgLH5Yv9Wnb3rXplqvvNLsQgypquy1CSXBewI
 kuYBADE90oIOKvH/zTSckq/DIM+erVVlYoXIjcSI5TDQwNiCq66CIQg0AOJITqJ2vbVH/yRMN
 g7aB2O8660O6uSLOGvd7Rh67ds0fc0ijiMBmHA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

gcc-9 complains about a blatant uninitialized variable use that
all earlier compiler versions missed:

drivers/iio/adc/rcar-gyroadc.c:510:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]

Return -EINVAL instead here.

Cc: stable@vger.kernel.org
Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/iio/adc/rcar-gyroadc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/rcar-gyroadc.c b/drivers/iio/adc/rcar-gyroadc.c
index 2d685730f867..aec73cc43e23 100644
--- a/drivers/iio/adc/rcar-gyroadc.c
+++ b/drivers/iio/adc/rcar-gyroadc.c
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

