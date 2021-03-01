Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036D2328548
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbhCAQwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:52:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234327AbhCAQo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:44:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CE2E64EBE;
        Mon,  1 Mar 2021 16:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616243;
        bh=anHdZ+5TFnxJjkiuQRD7+q94L3erT+9EZD58+1yvUSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Km5qDC5p4emEtvpIMH27Zf4cbqzOh/ZpefF5Ld6BluTFrkEX7ym2av3JTe37oWBKP
         0zLWl09NVOGU60qL6QDif2w2hVAFSEb27ZhdHgVbQS6Sc9xnaTO6XB+NHJOtZVwoBa
         VRpFCXhKlVBKjUzpHuIiLXqbI1GboODR53JwJ6Fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 083/176] spi: atmel: Put allocated master before return
Date:   Mon,  1 Mar 2021 17:12:36 +0100
Message-Id: <20210301161025.091670092@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index 7b739c449227f..6c9ce7b24aa0c 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1582,7 +1582,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
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



