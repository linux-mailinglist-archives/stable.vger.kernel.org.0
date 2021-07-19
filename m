Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B4D3CDAED
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242960AbhGSOkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244217AbhGSOho (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:37:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DC6461220;
        Mon, 19 Jul 2021 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707846;
        bh=fAySR2GxltjBMCs0mwVQzIM8EBH+3hm24OaJlIaGlVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4fqghTIRK/8eDQkItgpU/EZPHrVNt9hxTEu8BukIgrG7HCCt0jqV1S13gXIqqkMo
         1lWYzvD9I6SddKW7eyObhBHVrS6jOaYZxw/8o/zUdTIV/lH8bdMUcEx+Pt2f+rQvPf
         OOGW2DOkSw6hTIuoTlCjf0KbG1cuBuxW2akNclFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 081/315] pata_octeon_cf: avoid WARN_ON() in ata_host_activate()
Date:   Mon, 19 Jul 2021 16:49:30 +0200
Message-Id: <20210719144945.539114445@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit bfc1f378c8953e68ccdbfe0a8c20748427488b80 ]

Iff platform_get_irq() fails (or returns IRQ0) and thus the polling mode
has to be used, ata_host_activate() hits the WARN_ON() due to 'irq_handler'
parameter being non-NULL if the polling mode is selected.  Let's only set
the pointer to the driver's IRQ handler if platform_get_irq() returns a
valid IRQ # -- this should avoid the unnecessary WARN_ON()...

Fixes: 43f01da0f279 ("MIPS/OCTEON/ata: Convert pata_octeon_cf.c to use device tree.")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/3a241167-f84d-1d25-5b9b-be910afbe666@omp.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_octeon_cf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index d3d851b014a3..ac3b1fda820f 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -898,10 +898,11 @@ static int octeon_cf_probe(struct platform_device *pdev)
 					return -EINVAL;
 				}
 
-				irq_handler = octeon_cf_interrupt;
 				i = platform_get_irq(dma_dev, 0);
-				if (i > 0)
+				if (i > 0) {
 					irq = i;
+					irq_handler = octeon_cf_interrupt;
+				}
 			}
 			of_node_put(dma_node);
 		}
-- 
2.30.2



