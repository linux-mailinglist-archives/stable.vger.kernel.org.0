Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB0B37C1E0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhELPFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232618AbhELPDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:03:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40DFE61925;
        Wed, 12 May 2021 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831517;
        bh=/AgjfOrT7Mt9DjHDE0Dodd0FDUd6F7i8uh2P6FQQHrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGDEjpXB7lzQdqrm5KEXc0KpzMab7xi+bpxUvK4CCYRYmsRyoj0VW9GDK83z5YP96
         3m0oo2ejm22sSEIoId9RMcxDW4nJAJ5AWLJtH4tGNjqPh18VsiK90CoN9eJPKgyqA7
         eIuqoOiNAZ6WW1fBTx8EmXh5m/NWYufcgDYOevCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/244] ata: libahci_platform: fix IRQ check
Date:   Wed, 12 May 2021 16:48:41 +0200
Message-Id: <20210512144747.813412380@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index a1cbb894e5f0..416cfbf2f1c2 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -582,11 +582,13 @@ int ahci_platform_init_host(struct platform_device *pdev,
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



