Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB01137C4E8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhELPeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:34:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232461AbhELP2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA6AD61947;
        Wed, 12 May 2021 15:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832498;
        bh=5wl/9twl21FMEylK+vwAE5nQvQkmW1u5oomSYaj8YHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9H66uXBWgx46mbPhAklEWYcaMssI5EVjVT0ulghFe0XT0JdjQY8ZukSFpiZO2A/F
         PcSQGTuFZCMomNmJ+8rBpUog3EJ9V/w1QO+n0f9XV9f3PoxE3eJEO3LHATOUvYqOOJ
         YaDpJtUCHrAnYGFv9gVuCBNkwBHNGHzqB0OS4pFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/530] sata_mv: add IRQ checks
Date:   Wed, 12 May 2021 16:46:55 +0200
Message-Id: <20210512144829.818636595@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 664ef658a955..b62446ea5f40 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4097,6 +4097,10 @@ static int mv_platform_probe(struct platform_device *pdev)
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



