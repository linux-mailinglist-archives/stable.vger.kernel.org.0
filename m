Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E853288A5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238679AbhCARnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233446AbhCARfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:35:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB23E650AF;
        Mon,  1 Mar 2021 16:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617672;
        bh=96NTDA+OYK/Px4c45nUkM396t1LTy1nYrtKs3+38CF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cB4DFslZiJfDR9U+oPX4izQdG70vQOcnMFkSSqO0acXZTJ46a6Sz5gPaQTtzrNOOJ
         EMrd+UHl3GF3b3OuqMpz8aSmOT1u73WXfs3cYb/HFX8q00qKR6/gm149oh7iYIylwW
         un/Vz3vV1k/S2UCVVZ39DEfyhpsKMwuxMxe5NYS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 155/340] spi: atmel: Put allocated master before return
Date:   Mon,  1 Mar 2021 17:11:39 +0100
Message-Id: <20210301161055.943982856@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index abbc1582f457e..d9711ea5b01d3 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1569,7 +1569,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
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



