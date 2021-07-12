Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175D03C5087
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245440AbhGLHd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244408AbhGLH1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:27:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2D9561455;
        Mon, 12 Jul 2021 07:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074630;
        bh=phhEe4LlJNVR/lyIkm8IPZzQOPz+dXcOTY6kbqYAFzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HuEpqfZt9o4wVdIBKK+0TuLtOd6bJsU78XXgW1gM/3dzuGR/0k+uEHRuKN8Xg3g98
         MxGdPXawtOi4olMNkRkSoojCL6HBRTym452FPfz8SzmLeAVC7x6YzEwoYbqKuzQe4L
         T/sRDJPF0XUjXagNdue1pd0SmKj68myz5dVoiOng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 644/700] ASoC: fsl_xcvr: disable all interrupts when suspend happens
Date:   Mon, 12 Jul 2021 08:12:07 +0200
Message-Id: <20210712061044.393621462@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 6dd0a5fcd455..070e3f32859f 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1236,6 +1236,16 @@ static __maybe_unused int fsl_xcvr_runtime_suspend(struct device *dev)
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



