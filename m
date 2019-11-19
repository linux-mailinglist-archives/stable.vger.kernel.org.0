Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737AF1013A6
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfKSF0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:26:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbfKSF0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:26:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1BC4222A2;
        Tue, 19 Nov 2019 05:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141166;
        bh=GFSVBNLPJtFDTvTDouENezti5bv31KmrpDsn995p2Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2JSjJSQYYiFaFgJ7AJztaa/30yiJiMY1w+2Ycci5OS+k5lUNIW68r8seruIc5mTl
         uRQmWz4nHao/qGkQEO1GNEPMa8/tt44MmxrIyeqUimaomcix3sVv8gZWppJxHU2b5c
         q2oMwBi4YK7UhJVWNzL/ond8iUl4opsYAMelyR/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 068/422] ASoC: meson: axg-fifo: report interrupt request failure
Date:   Tue, 19 Nov 2019 06:14:25 +0100
Message-Id: <20191119051404.060509734@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit dadfab7272b13ca441efdb9aa9117bc669680b05 ]

Return value of request_irq() was irgnored. Fix this and report
the failure if any

Fixes: 6dc4fa179fb8 ("ASoC: meson: add axg fifo base driver")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-fifo.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/meson/axg-fifo.c b/sound/soc/meson/axg-fifo.c
index 30262550e37b1..0e4f65e654c4b 100644
--- a/sound/soc/meson/axg-fifo.c
+++ b/sound/soc/meson/axg-fifo.c
@@ -203,6 +203,8 @@ static int axg_fifo_pcm_open(struct snd_pcm_substream *ss)
 
 	ret = request_irq(fifo->irq, axg_fifo_pcm_irq_block, 0,
 			  dev_name(dev), ss);
+	if (ret)
+		return ret;
 
 	/* Enable pclk to access registers and clock the fifo ip */
 	ret = clk_prepare_enable(fifo->pclk);
-- 
2.20.1



