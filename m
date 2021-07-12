Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C643C55A2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhGLILZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353828AbhGLIDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFEAC61D0D;
        Mon, 12 Jul 2021 07:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076668;
        bh=dvT+46BeYcIweLUBtLz0tP8R4ak/r69IrFhf05nTBFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+v4ySPOJUFim32kUAZf0RV2mERaOiD5wplyBtXZVC8Z2Js3hbXf2V1x2PMjeNOg4
         TLdK0S6pru3ZJGhhud15Fhh0IfVnKo+ORvfLMoxPQyqSFi4cNSoIpGhmgxKDgpBlo1
         mDq8fplJy5tdblOT+TyQOcZ8I1LjRMmBbNozcw3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 740/800] ASoC: fsl_xcvr: disable all interrupts when suspend happens
Date:   Mon, 12 Jul 2021 08:12:43 +0200
Message-Id: <20210712061045.508332979@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit ea837090b388245744988083313f6e9c7c9b9699 ]

There is an unhandled interrupt after suspend, which cause endless
interrupt when system resume, so system may hang.

Disable all interrupts in runtime suspend callback to avoid above
issue.

Fixes: 28564486866f ("ASoC: fsl_xcvr: Add XCVR ASoC CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/1624019913-3380-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 6cb558165848..46f3f2c68756 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1233,6 +1233,16 @@ static __maybe_unused int fsl_xcvr_runtime_suspend(struct device *dev)
 	struct fsl_xcvr *xcvr = dev_get_drvdata(dev);
 	int ret;
 
+	/*
+	 * Clear interrupts, when streams starts or resumes after
+	 * suspend, interrupts are enabled in prepare(), so no need
+	 * to enable interrupts in resume().
+	 */
+	ret = regmap_update_bits(xcvr->regmap, FSL_XCVR_EXT_IER0,
+				 FSL_XCVR_IRQ_EARC_ALL, 0);
+	if (ret < 0)
+		dev_err(dev, "Failed to clear IER0: %d\n", ret);
+
 	/* Assert M0+ reset */
 	ret = regmap_update_bits(xcvr->regmap, FSL_XCVR_EXT_CTRL,
 				 FSL_XCVR_EXT_CTRL_CORE_RESET,
-- 
2.30.2



