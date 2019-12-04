Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECA91133DA
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbfLDSJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:09:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731037AbfLDSJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:09:21 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2571720833;
        Wed,  4 Dec 2019 18:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482960;
        bh=SvzaFeAxpeoL+zdlUG6I1lgdAc3aDHVgtvV/3KsVv38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eBdQBwR7+1o/0JstZIYwcdGl3ROPr57r3oVxah2+nbtjQqcbt3lHb4QIoihSlHwB
         4RMoUaUshJSrCmgsXtRdVjWofCP2lC5Z6ZD5x0Fpo0khGjRtZ+zESOwY8plSfm6yox
         +ponyiTQPGW8hdJe0e5Lq30ZSPWK0xoL4WBqRZtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 205/209] ASoC: stm32: i2s: fix 16 bit format support
Date:   Wed,  4 Dec 2019 18:56:57 +0100
Message-Id: <20191204175337.600265937@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit 0c4c68d6fa1bae74d450e50823c24fcc3cd0b171 upstream.

I2S supports 16 bits data in 32 channel length.
However the expected driver behavior, is to
set channel length to 16 bits when data format is 16 bits.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/stm/stm32_i2s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -501,7 +501,7 @@ static int stm32_i2s_configure(struct sn
 	switch (format) {
 	case 16:
 		cfgr = I2S_CGFR_DATLEN_SET(I2S_I2SMOD_DATLEN_16);
-		cfgr_mask = I2S_CGFR_DATLEN_MASK;
+		cfgr_mask = I2S_CGFR_DATLEN_MASK | I2S_CGFR_CHLEN;
 		break;
 	case 32:
 		cfgr = I2S_CGFR_DATLEN_SET(I2S_I2SMOD_DATLEN_32) |


