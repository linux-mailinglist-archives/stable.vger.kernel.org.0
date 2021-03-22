Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7144C3441F5
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhCVMhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231316AbhCVMfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:35:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A4D4619AA;
        Mon, 22 Mar 2021 12:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416539;
        bh=ZB97km9wZK85oCKCyWjxtmlx6xbYJF/8/5iRqzEhMIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmTNmwmnlaMHwld+fZgYhSMvAeFFaHM3HgOkPhQFceHiKFuAXXISW20Vylah43bGp
         VVi0zZ9SkBqvTNmr0sgCs6fXtMFKXrK/9aaUfUvvHvVNZxUuAQtiIpmE1ZCnNetBDt
         5HDTsT2tj3Bp3GxRYH68YZxNam/rJtuhFN79P/qY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Shiyan <shc_work@mail.ru>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 024/157] ASoC: fsl_ssi: Fix TDM slot setup for I2S mode
Date:   Mon, 22 Mar 2021 13:26:21 +0100
Message-Id: <20210322121934.537422227@linuxfoundation.org>
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

From: Alexander Shiyan <shc_work@mail.ru>

commit 87263968516fb9507d6215d53f44052627fae8d8 upstream.

When using the driver in I2S TDM mode, the _fsl_ssi_set_dai_fmt()
function rewrites the number of slots previously set by the
fsl_ssi_set_dai_tdm_slot() function to 2 by default.
To fix this, let's use the saved slot count value or, if TDM
is not used and the slot count is not set, proceed as before.

Fixes: 4f14f5c11db1 ("ASoC: fsl_ssi: Fix number of words per frame for I2S-slave mode")
Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/20210216114221.26635-1-shc_work@mail.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_ssi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -878,6 +878,7 @@ static int fsl_ssi_hw_free(struct snd_pc
 static int _fsl_ssi_set_dai_fmt(struct fsl_ssi *ssi, unsigned int fmt)
 {
 	u32 strcr = 0, scr = 0, stcr, srcr, mask;
+	unsigned int slots;
 
 	ssi->dai_fmt = fmt;
 
@@ -909,10 +910,11 @@ static int _fsl_ssi_set_dai_fmt(struct f
 			return -EINVAL;
 		}
 
+		slots = ssi->slots ? : 2;
 		regmap_update_bits(ssi->regs, REG_SSI_STCCR,
-				   SSI_SxCCR_DC_MASK, SSI_SxCCR_DC(2));
+				   SSI_SxCCR_DC_MASK, SSI_SxCCR_DC(slots));
 		regmap_update_bits(ssi->regs, REG_SSI_SRCCR,
-				   SSI_SxCCR_DC_MASK, SSI_SxCCR_DC(2));
+				   SSI_SxCCR_DC_MASK, SSI_SxCCR_DC(slots));
 
 		/* Data on rising edge of bclk, frame low, 1clk before data */
 		strcr |= SSI_STCR_TFSI | SSI_STCR_TSCKP | SSI_STCR_TEFS;


