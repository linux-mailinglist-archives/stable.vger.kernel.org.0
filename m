Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702B338A91F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbhETK6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238790AbhETKzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:55:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C8DA60FDA;
        Thu, 20 May 2021 10:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504892;
        bh=bQNP+xR4D/CqaoinGYqKOf6mmpPGEkX0HU28J4S4yoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2D0YoDpCrG4/ZWZbKVhS6Y5L2lAwE1L82f2/LrZHP6YBpkhA69Yf7i3yBdNgai8Oy
         hP+h8df9OazPtbgi4Qyb0kXDAKM3s/9GynsGCFkqj0wn7h2uks9HHsXtivWNf7nOP+
         6KpX622Nu/1IudhyXcGBRBZWT0W13NEQVNQdcXkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 128/240] ata: libahci_platform: fix IRQ check
Date:   Thu, 20 May 2021 11:22:00 +0200
Message-Id: <20210520092112.955347811@linuxfoundation.org>
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

[ Upstream commit b30d0040f06159de97ad9c0b1536f47250719d7d ]

Iff platform_get_irq() returns 0, ahci_platform_init_host() would return 0
early (as if the call was successful). Override IRQ0 with -EINVAL instead
as the 'libata' regards 0 as "no IRQ" (thus polling) anyway...

Fixes: c034640a32f8 ("ata: libahci: properly propagate return value of platform_get_irq()")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Link: https://lore.kernel.org/r/4448c8cc-331f-2915-0e17-38ea34e251c8@omprussia.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci_platform.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 0b80502bc1c5..bfa2e5eec263 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -518,11 +518,13 @@ int ahci_platform_init_host(struct platform_device *pdev,
 	int i, irq, n_ports, rc;
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
+	if (irq < 0) {
 		if (irq != -EPROBE_DEFER)
 			dev_err(dev, "no irq\n");
 		return irq;
 	}
+	if (!irq)
+		return -EINVAL;
 
 	hpriv->irq = irq;
 
-- 
2.30.2



