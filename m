Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E67038A91E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbhETK6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238643AbhETKzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:55:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47E7661CCC;
        Thu, 20 May 2021 10:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504890;
        bh=vxA1XaYA287KLjIQ2/awwXiBZCP0QkSCvg0ZQec5Z4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5WJAg57Eo+n0RCvKjS0wjbTYBQwv+Tm0yL2PMsacjhX+irzMM7NIZJg/4Tr/UbmJ
         FnVLWqSjyovJ+JkNOkicAObgkGN1CFtCdp0cBaunsrvisnXFZenMYZp+mhvW0q+fku
         59n7H7ULZLVbI4lIJfENrkxvQdVPiH+HmySVeLao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 127/240] sata_mv: add IRQ checks
Date:   Thu, 20 May 2021 11:21:59 +0200
Message-Id: <20210520092112.921359937@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index 513ef298dd96..ded3a66049d2 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4112,6 +4112,10 @@ static int mv_platform_probe(struct platform_device *pdev)
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



