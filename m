Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207D63286FC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237929AbhCARST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237266AbhCARLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:11:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1D9164E12;
        Mon,  1 Mar 2021 16:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616969;
        bh=q23Yn/2bnRoMhkx4BWbXvglPxQFuwP3BCt+qTP86S20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VM0gFJXjWimUaaZGu5QV6l8I+0gCMchYMYjYLhYTRkm9R4fGwm6LnoV4aSA2Z9xta
         1aLtwZb/mNz3LnHU3ccszABbadhjSFhNrvSy1nZZaf11lBDsp/wO5Jf6A+MFJKZp0K
         sn33E2LRH1ZM9mXVsHDZaYam6wA7rsy+/K5jQoYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 127/247] spi: atmel: Put allocated master before return
Date:   Mon,  1 Mar 2021 17:12:27 +0100
Message-Id: <20210301161037.892043389@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index 5a9d7e252a77c..2254e36c7f468 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1605,7 +1605,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
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



