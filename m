Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C3138A3ED
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbhETJ6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234607AbhETJ4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:56:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BFCF6140A;
        Thu, 20 May 2021 09:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503462;
        bh=OfqIR65GaFmcPl2O4Wzz767MIhstNVDSVcaJAJ7+a9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xd57rJBvF65mOeGq1/QrcYMbmqZwVI8B23k53UbIlTjyq/3CGcEiI4nbYJCRHyGkH
         3EFrAy98i7SCd9VHcNvkbzEMR5QBDTKwKY64Ap8RmBOFzQ5I922k4mPFmpdahXTf6w
         yzFAqucyCKnGTyGN2bmaMQy54JbXcClZzmed8pio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 233/425] sata_mv: add IRQ checks
Date:   Thu, 20 May 2021 11:20:02 +0200
Message-Id: <20210520092139.090357119@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit e6471a65fdd5efbb8dd2732dd0f063f960685ceb ]

The function mv_platform_probe() neglects to check the results of the
calls to platform_get_irq() and irq_of_parse_and_map() and blithely
passes them to ata_host_activate() -- while the latter only checks
for IRQ0 (treating it as a polling mode indicattion) and passes the
negative values to devm_request_irq() causing it to fail as it takes
unsigned values for the IRQ #...

Add to mv_platform_probe() the proper IRQ checks to pass the positive IRQ
#s to ata_host_activate(), propagate upstream the negative error codes,
and override the IRQ0 with -EINVAL (as we don't want the polling mode).

Fixes: f351b2d638c3 ("sata_mv: Support SoC controllers")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Link: https://lore.kernel.org/r/51436f00-27a1-e20b-c21b-0e817e0a7c86@omprussia.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_mv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 2910b22fac11..57ef11ecbb9b 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4110,6 +4110,10 @@ static int mv_platform_probe(struct platform_device *pdev)
 		n_ports = mv_platform_data->n_ports;
 		irq = platform_get_irq(pdev, 0);
 	}
+	if (irq < 0)
+		return irq;
+	if (!irq)
+		return -EINVAL;
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);
-- 
2.30.2



