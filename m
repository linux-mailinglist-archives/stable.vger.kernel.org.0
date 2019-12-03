Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB389111C06
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfLCWjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:39:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728232AbfLCWjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:39:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AC592073C;
        Tue,  3 Dec 2019 22:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412770;
        bh=bIMdWTVVXmga78CVUUepiAkLfk2lRuJIMByI9p4aMec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1ucBK4Ex5IEbtg4O7GFL71g0qR0t8YEBhH7PoCa22ULIfeyJnebMTmuVrxF63/QZ
         z25LGQ8VZxVWl+UW3wZyZX5v5nipTz4dp9oLBe39ujEdkl/O1FRyZqRrpaXKyDlWlc
         hAV/kJv5tcc/faW97ngkLtws3U04l1tFViWGWHms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 011/135] ASoC: msm8916-wcd-analog: Fix RX1 selection in RDAC2 MUX
Date:   Tue,  3 Dec 2019 23:34:11 +0100
Message-Id: <20191203213007.741201071@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 9110d1b0e229cebb1ffce0c04db2b22beffd513d ]

According to the PM8916 Hardware Register Description,
CDC_D_CDC_CONN_HPHR_DAC_CTL has only a single bit (RX_SEL)
to switch between RX1 (0) and RX2 (1). It is not possible to
disable it entirely to achieve the "ZERO" state.

However, at the moment the "RDAC2 MUX" mixer defines three possible
values ("ZERO", "RX2" and "RX1"). Setting the mixer to "ZERO"
actually configures it to RX1. Setting the mixer to "RX1" has
(seemingly) no effect.

Remove "ZERO" and replace it with "RX1" to fix this.

Fixes: 585e881e5b9e ("ASoC: codecs: Add msm8916-wcd analog codec")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20191020153007.206070-1-stephan@gerhold.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/msm8916-wcd-analog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/msm8916-wcd-analog.c b/sound/soc/codecs/msm8916-wcd-analog.c
index 368b6c09474bb..aa9a8ac987dc0 100644
--- a/sound/soc/codecs/msm8916-wcd-analog.c
+++ b/sound/soc/codecs/msm8916-wcd-analog.c
@@ -306,7 +306,7 @@ struct pm8916_wcd_analog_priv {
 };
 
 static const char *const adc2_mux_text[] = { "ZERO", "INP2", "INP3" };
-static const char *const rdac2_mux_text[] = { "ZERO", "RX2", "RX1" };
+static const char *const rdac2_mux_text[] = { "RX1", "RX2" };
 static const char *const hph_text[] = { "ZERO", "Switch", };
 
 static const struct soc_enum hph_enum = SOC_ENUM_SINGLE_VIRT(
@@ -321,7 +321,7 @@ static const struct soc_enum adc2_enum = SOC_ENUM_SINGLE_VIRT(
 
 /* RDAC2 MUX */
 static const struct soc_enum rdac2_mux_enum = SOC_ENUM_SINGLE(
-			CDC_D_CDC_CONN_HPHR_DAC_CTL, 0, 3, rdac2_mux_text);
+			CDC_D_CDC_CONN_HPHR_DAC_CTL, 0, 2, rdac2_mux_text);
 
 static const struct snd_kcontrol_new spkr_switch[] = {
 	SOC_DAPM_SINGLE("Switch", CDC_A_SPKR_DAC_CTL, 7, 1, 0)
-- 
2.20.1



