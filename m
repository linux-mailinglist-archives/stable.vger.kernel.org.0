Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006E7E66C2
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbfJ0VPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730560AbfJ0VO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:14:59 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA4C320B7C;
        Sun, 27 Oct 2019 21:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210898;
        bh=kZZgyc4DrtTaXEeJC0XmpsLaMMXypc6EHRuOwyLyH+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjYLxsC8NodJSq17VwtsGhLC88ATC5MozP3gZFMKlSl/pmuVziyw5GIYfIWaRlGwc
         KEYnbbZNFt/cOkZgvj/8UGLOj9Vk15oNLBLXAh1UWl0N0/4dBGbEHAlANRwcNHzba5
         VU7+izU+wwW31tsmcKtCLy7gyiT28OYPQK6m5J9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Timo Wischer <twischer@de.adit-jv.com>,
        Junya Monden <jmonden@jp.adit-jv.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 55/93] ASoC: rsnd: Reinitialize bit clock inversion flag for every format setting
Date:   Sun, 27 Oct 2019 22:01:07 +0100
Message-Id: <20191027203301.949691539@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junya Monden <jmonden@jp.adit-jv.com>

commit 22e58665a01006d05f0239621f7d41cacca96cc4 upstream.

Unlike other format-related DAI parameters, rdai->bit_clk_inv flag
is not properly re-initialized when setting format for new stream
processing. The inversion, if requested, is then applied not to default,
but to a previous value, which leads to SCKP bit in SSICR register being
set incorrectly.
Fix this by re-setting the flag to its initial value, determined by format.

Fixes: 1a7889ca8aba3 ("ASoC: rsnd: fixup SND_SOC_DAIFMT_xB_xF behavior")
Cc: Andrew Gabbasov <andrew_gabbasov@mentor.com>
Cc: Jiada Wang <jiada_wang@mentor.com>
Cc: Timo Wischer <twischer@de.adit-jv.com>
Cc: stable@vger.kernel.org # v3.17+
Signed-off-by: Junya Monden <jmonden@jp.adit-jv.com>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20191016124255.7442-1-erosca@de.adit-jv.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sh/rcar/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -674,6 +674,7 @@ static int rsnd_soc_dai_set_fmt(struct s
 	}
 
 	/* set format */
+	rdai->bit_clk_inv = 0;
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
 		rdai->sys_delay = 0;


