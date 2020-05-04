Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3A21C4596
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730753AbgEDSP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730694AbgEDR7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C668C2078C;
        Mon,  4 May 2020 17:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615148;
        bh=Yl+InBKkRRTfPj7fX77sydsZUxlVXdAhpgkoZZ8rwIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3Bdqeyh1/2ZPc+18cut792F1lCkWQXqOI1WQbrEwebAAyyO20FlqKWC6qkFzjkdO
         pGJ2LhhYzEJX0EgSxnBgZVTLUFZ3oEaTkSmEk0xsmrVBvm+KtS/fgVLALz2llSxICd
         et6EXgKIdc2/c23GJ6CMW33qZ7HIzoxWiGN+k3PY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stuart Henderson <stuart.henderson@cirrus.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 15/18] ASoC: wm8960: Fix WM8960_SYSCLK_PLL mode
Date:   Mon,  4 May 2020 19:57:13 +0200
Message-Id: <20200504165444.659934157@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
References: <20200504165441.533160703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stuart Henderson <stuart.henderson@cirrus.com>

commit 6bb7451429084cefcb3a18fff809f7992595d2af upstream.

With the introduction of WM8960_SYSCLK_AUTO mode, WM8960_SYSCLK_PLL mode was
made unusable.  Ensure we're not PLL mode before trying to use MCLK.

Fixes: 3176bf2d7ccd ("ASoC: wm8960: update pll and clock setting function")
Signed-off-by: Stuart Henderson <stuart.henderson@cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8960.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -631,29 +631,31 @@ static int wm8960_configure_clocking(str
 		return -EINVAL;
 	}
 
-	/* check if the sysclk frequency is available. */
-	for (i = 0; i < ARRAY_SIZE(sysclk_divs); ++i) {
-		if (sysclk_divs[i] == -1)
-			continue;
-		sysclk = freq_out / sysclk_divs[i];
-		for (j = 0; j < ARRAY_SIZE(dac_divs); ++j) {
-			if (sysclk == dac_divs[j] * lrclk) {
+	if (wm8960->clk_id != WM8960_SYSCLK_PLL) {
+		/* check if the sysclk frequency is available. */
+		for (i = 0; i < ARRAY_SIZE(sysclk_divs); ++i) {
+			if (sysclk_divs[i] == -1)
+				continue;
+			sysclk = freq_out / sysclk_divs[i];
+			for (j = 0; j < ARRAY_SIZE(dac_divs); ++j) {
+				if (sysclk != dac_divs[j] * lrclk)
+					continue;
 				for (k = 0; k < ARRAY_SIZE(bclk_divs); ++k)
 					if (sysclk == bclk * bclk_divs[k] / 10)
 						break;
 				if (k != ARRAY_SIZE(bclk_divs))
 					break;
 			}
+			if (j != ARRAY_SIZE(dac_divs))
+				break;
 		}
-		if (j != ARRAY_SIZE(dac_divs))
-			break;
-	}
 
-	if (i != ARRAY_SIZE(sysclk_divs)) {
-		goto configure_clock;
-	} else if (wm8960->clk_id != WM8960_SYSCLK_AUTO) {
-		dev_err(codec->dev, "failed to configure clock\n");
-		return -EINVAL;
+		if (i != ARRAY_SIZE(sysclk_divs)) {
+			goto configure_clock;
+		} else if (wm8960->clk_id != WM8960_SYSCLK_AUTO) {
+			dev_err(codec->dev, "failed to configure clock\n");
+			return -EINVAL;
+		}
 	}
 	/* get a available pll out frequency and set pll */
 	for (i = 0; i < ARRAY_SIZE(sysclk_divs); ++i) {


