Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D54328E08
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241363AbhCATWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241341AbhCATRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:17:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C673B651CC;
        Mon,  1 Mar 2021 17:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619039;
        bh=6SS7QfvSohixE/vYd+rfNUFfqM2T6pEu0bvCKQVBOgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXdhARPmEVNwrBLHet4xaPtu4BUXmY8T/C3w33AAdCqNNY3awIj/ZjALXLPXI5k2k
         INfPnTn40RinPRioQZM4v96NQ033hB/atgiimsJ8GvM40YS+dwPPsLaautvBLJfsEl
         x77RZTElxZdvKzFp6HOcMg/ylNG3Yw0njuB8n7jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 310/663] spi: atmel: Put allocated master before return
Date:   Mon,  1 Mar 2021 17:09:18 +0100
Message-Id: <20210301161157.179947968@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 21ea2743f015dbacec1831bdc8afc848db9c2b8c ]

The allocated master is not released. Goto error handling label rather
than directly return.

Fixes: 5e9af37e46bc ("spi: atmel: introduce probe deferring")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Fixes: 5e9af37e46bc ("spi: atmel: introduce probe deferring")
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20210120050025.25426-1-bianpan2016@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-atmel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 0e5e64a80848d..1db43cbead575 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1590,7 +1590,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
 		if (ret == 0) {
 			as->use_dma = true;
 		} else if (ret == -EPROBE_DEFER) {
-			return ret;
+			goto out_unmap_regs;
 		}
 	} else if (as->caps.has_pdc_support) {
 		as->use_pdc = true;
-- 
2.27.0



