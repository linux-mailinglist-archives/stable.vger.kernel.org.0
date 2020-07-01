Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E9F210E48
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 17:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbgGAPCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 11:02:32 -0400
Received: from first.geanix.com ([116.203.34.67]:51102 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731518AbgGAPCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 11:02:31 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 729292243300;
        Wed,  1 Jul 2020 14:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1593615422; bh=bVYNtopJ04VZEaf1UkhnNm6KZD1lcCfOyd/wbyQDgnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=NLm6qUfcMrMT4EehNEWaUPrLuDhC8zyspMuBJU9QwcTvAemifn1RvwhhwMitCk0zr
         GgiGxWTn1JOAtERQaQf9KTU15nqXOfcWkbPeM/wv+FsG3EPJ0A3W3Q/lI7WUve0Vrb
         7ZfI3flAT/xFC0Hw8vzg/ekNLBbgP0JpGVWZ+kcvqw1Cd21vCZ9GQMKxzyET1Sm1o6
         a2GfNkHiSnPY/g9CoBiy247z52+DVhXuu7HYEQ/XQWo3FH2mxXAHy9iYZjAENcE8lG
         vvXw44LtkK6eBQNqJG0MUSCyZYngP92kOVsu8ozyrT6qCS3G1zMdRYEcqEBTQisIXE
         YqILsh30udQGg==
From:   Esben Haabendal <esben@geanix.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/3] uio_pdrv_genirq: fix use without device tree and no interrupt
Date:   Wed,  1 Jul 2020 16:56:58 +0200
Message-Id: <20200701145659.3978-3-esben@geanix.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701145659.3978-1-esben@geanix.com>
References: <20200701145659.3978-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on ff3d05386fc5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While e3a3c3a20555 ("UIO: fix uio_pdrv_genirq with device tree but no
interrupt") added support for using uio_pdrv_genirq for devices without
interrupt for device tree platforms, the removal of uio_pdrv in
26dac3c49d56 ("uio: Remove uio_pdrv and use uio_pdrv_genirq instead")
broke the support for non device tree platforms.

This change fixes this, so that uio_pdrv_genirq can be used without
interrupt on all platforms.

This still leaves the support that uio_pdrv had for custom interrupt
handler lacking, as uio_pdrv_genirq does not handle it (yet).

Fixes: 26dac3c49d56 ("uio: Remove uio_pdrv and use uio_pdrv_genirq instead")
Signed-off-by: Esben Haabendal <esben@geanix.com>
Cc: stable@vger.kernel.org
---
 drivers/uio/uio_pdrv_genirq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 1d69dd49c6d2..b60173bc93ce 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -161,7 +161,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	if (!uioinfo->irq) {
 		ret = platform_get_irq_optional(pdev, 0);
 		uioinfo->irq = ret;
-		if (ret == -ENXIO && pdev->dev.of_node)
+		if (ret == -ENXIO)
 			uioinfo->irq = UIO_IRQ_NONE;
 		else if (ret == -EPROBE_DEFER)
 			return ret;
-- 
2.4.11

