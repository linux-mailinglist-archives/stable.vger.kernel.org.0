Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D6F328C15
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240268AbhCASpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240500AbhCASjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E57C8650D9;
        Mon,  1 Mar 2021 17:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621069;
        bh=B/LfwtTqX2+R9AW+xh4hApe83TEcFbVsWkmSnG9EKZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0giOTgp2OuOB02rm6z7hnYFXj05NBjCoJR4IYTjKJV3wfH7soG3NasfxQFnge+V0O
         9Nh0vTWUkx/sykobsfw02Nfp0PrHrroy62TpyeuXOe9dST3okjVw6pISR5tBY+MmYz
         zFvomvi0+c4tJ7hurS538rx5BGcmyksAFldYHwpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 365/775] spi: atmel: Put allocated master before return
Date:   Mon,  1 Mar 2021 17:08:53 +0100
Message-Id: <20210301161219.657407840@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 948396b382d73..f429436082afa 100644
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



