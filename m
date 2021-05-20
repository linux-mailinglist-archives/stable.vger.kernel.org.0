Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC84538A3EE
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbhETJ6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234613AbhETJ4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:56:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E83D61405;
        Thu, 20 May 2021 09:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503465;
        bh=tVTv+aXED1UpheeDz+k8kU9g/uaMaGmFqE3wfhfqOXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jk7eLQhQtmUFxfjFprOKHzcDjhrgSmHX56LVhr1unJGTPruieG5/GzMDs0ca3RpoG
         8abNj7cFnpLx4n5sBWfuhv1zONwCeihsZRFx3WuIU7EdE3I2UOvutpOcw2XFrfNfq5
         K9mtiwqSe4E9H4o3oCCoBEHty98MBDEqF/G+nLd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 234/425] ata: libahci_platform: fix IRQ check
Date:   Thu, 20 May 2021 11:20:03 +0200
Message-Id: <20210520092139.121732005@linuxfoundation.org>
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
index 522b543f718d..6a55aac0c60f 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -544,11 +544,13 @@ int ahci_platform_init_host(struct platform_device *pdev,
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



