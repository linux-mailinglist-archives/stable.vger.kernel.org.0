Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3281111E1B
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbfLCW6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730698AbfLCW6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:58:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9665720803;
        Tue,  3 Dec 2019 22:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413927;
        bh=SvzaFeAxpeoL+zdlUG6I1lgdAc3aDHVgtvV/3KsVv38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0jrwo7bRhgJfe0kyGjGslcxETVO1z2oV7dFhuYsrFXPYO+zgQmNP8LrmfYc8LClF
         FsZ6K3R6VwGfe1Hu73fLh1gYQ0Ob006G2Q/HCcNOOWEpB7xh+HChUlCsPr/8lWcDQn
         OG/LSSIhKPgyrIl8wxNbBUm9B27kzomVcx+gJF6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.19 316/321] ASoC: stm32: i2s: fix 16 bit format support
Date:   Tue,  3 Dec 2019 23:36:22 +0100
Message-Id: <20191203223443.583798369@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
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


