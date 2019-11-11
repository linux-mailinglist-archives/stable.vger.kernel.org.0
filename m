Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D9CF7E41
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbfKKSt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:49:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbfKKSt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:49:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D27CF222BD;
        Mon, 11 Nov 2019 18:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498196;
        bh=iK708Y4UVN4POp1Ppw6wBYUv5yIiFcZyAUPTlAUzY9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZZ/wrMqIXpi/txsoYQXpHMUI84LzdOJNftvjnFuROOE0X+zLRW14PO2jJHbd0jTX
         Lfay8jQZXs+Vcvcg+bVfKM1/Sh8tSmKQyw6jWEtsfuq0Y2Ua2xVBtzL/C0RSne6Qax
         h6b72dInChFLcP8bahY0oNfjIpeo1NLsF1JzrCUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiada Wang <jiada_wang@mentor.com>,
        Timo Wischer <twischer@de.adit-jv.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.3 050/193] ASoC: rsnd: dma: fix SSI9 4/5/6/7 busif dma address
Date:   Mon, 11 Nov 2019 19:27:12 +0100
Message-Id: <20191111181504.664673614@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiada Wang <jiada_wang@mentor.com>

commit d10be65f87fc9d98ad3cbdc406e86745fe8c59e2 upstream.

Currently each SSI unit's busif dma address is calculated by
following calculation formula:
0xec540000 + 0x1000 * id + busif / 4 * 0xA000 + busif % 4 * 0x400

But according to R-Car3 HW manual 41.1.4 Register Configuration,
ssi9 4/5/6/7 busif data register address
(SSI9_4_BUSIF/SSI9_5_BUSIF/SSI9_6_BUSIF/SSI9_7_BUSIF)
are out of this rule.

This patch updates the calculation formula to correct
ssi9 4/5/6/7 busif data register address.

Fixes: 5e45a6fab3b9 ("ASoc: rsnd: dma: Calculate dma address with consider of BUSIF")
Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Signed-off-by: Timo Wischer <twischer@de.adit-jv.com>
[erosca: minor improvements in commit description]
Cc: Andrew Gabbasov <andrew_gabbasov@mentor.com>
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20191022185429.12769-1-erosca@de.adit-jv.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sh/rcar/dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/sh/rcar/dma.c
+++ b/sound/soc/sh/rcar/dma.c
@@ -508,10 +508,10 @@ static struct rsnd_mod_ops rsnd_dmapp_op
 #define RDMA_SSI_I_N(addr, i)	(addr ##_reg - 0x00300000 + (0x40 * i) + 0x8)
 #define RDMA_SSI_O_N(addr, i)	(addr ##_reg - 0x00300000 + (0x40 * i) + 0xc)
 
-#define RDMA_SSIU_I_N(addr, i, j) (addr ##_reg - 0x00441000 + (0x1000 * (i)) + (((j) / 4) * 0xA000) + (((j) % 4) * 0x400))
+#define RDMA_SSIU_I_N(addr, i, j) (addr ##_reg - 0x00441000 + (0x1000 * (i)) + (((j) / 4) * 0xA000) + (((j) % 4) * 0x400) - (0x4000 * ((i) / 9) * ((j) / 4)))
 #define RDMA_SSIU_O_N(addr, i, j) RDMA_SSIU_I_N(addr, i, j)
 
-#define RDMA_SSIU_I_P(addr, i, j) (addr ##_reg - 0x00141000 + (0x1000 * (i)) + (((j) / 4) * 0xA000) + (((j) % 4) * 0x400))
+#define RDMA_SSIU_I_P(addr, i, j) (addr ##_reg - 0x00141000 + (0x1000 * (i)) + (((j) / 4) * 0xA000) + (((j) % 4) * 0x400) - (0x4000 * ((i) / 9) * ((j) / 4)))
 #define RDMA_SSIU_O_P(addr, i, j) RDMA_SSIU_I_P(addr, i, j)
 
 #define RDMA_SRC_I_N(addr, i)	(addr ##_reg - 0x00500000 + (0x400 * i))


