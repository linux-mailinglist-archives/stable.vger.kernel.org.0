Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05413C4D36
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245378AbhGLHMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241121AbhGLHIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:08:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 609276121F;
        Mon, 12 Jul 2021 07:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073504;
        bh=/N163FbOFkeOnHGwWMlvRyt7ZOWldUnix3Qi+8OqLzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tjd7YIMcpULfhAXPuh6e/EM3SmSRn/4cVhHW7HYCgH04C0Bdfwc4skSm0dmNOM79X
         sFN3Lmwx8y4c0SIQP8LcgMRvTFIquPB17dqsoeFF/c+TcNxz5kR6iMjJOVraTkFdKc
         XS+pftJrDys+eQp9ohUvJYHOg6IlyMGFDneNtJwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 257/700] sata_highbank: fix deferred probing
Date:   Mon, 12 Jul 2021 08:05:40 +0200
Message-Id: <20210712061003.378009486@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit 4a24efa16e7db02306fb5db84518bb0a7ada5a46 ]

The driver overrides the error codes returned by platform_get_irq() to
-EINVAL, so if it returns -EPROBE_DEFER, the driver would fail the probe
permanently instead of the deferred probing. Switch to propagating the
error code upstream, still checking/overriding IRQ0 as libata regards it
as "no IRQ" (thus polling) anyway...

Fixes: 9ec36cafe43b ("of/irq: do irq resolution in platform_get_irq")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Link: https://lore.kernel.org/r/105b456d-1199-f6e9-ceb7-ffc5ba551d1a@omprussia.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_highbank.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index 64b2ef15ec19..8440203e835e 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -469,10 +469,12 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
+	if (irq < 0) {
 		dev_err(dev, "no irq\n");
-		return -EINVAL;
+		return irq;
 	}
+	if (!irq)
+		return -EINVAL;
 
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv) {
-- 
2.30.2



