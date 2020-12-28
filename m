Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0B62E3EC0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503684AbgL1Oa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:30:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504035AbgL1OaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:30:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A75E320731;
        Mon, 28 Dec 2020 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165807;
        bh=+hN4M+no+Ki+hCMeeLsUCeOLOTSqIYfsmJH3+f51i1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAA5XhKTeGwqvWUqx4Gt3aDylszmN6OSpDpOEUhyo+lH3AbB6VjL6ByZmD5ZSGjbV
         4JwJ0lm1OknzIdPE0PJrL8149w3DKRu8mWCweSZTDxtD/93kKAukyZrWJSbKn9Lg7p
         evjawXkSQVNslWmY96RHO3aIe7lI/7fI0PZeg7dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 661/717] spi: atmel-quadspi: Disable clock in probe error path
Date:   Mon, 28 Dec 2020 13:50:59 +0100
Message-Id: <20201228125052.634491775@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 0e685017c7ba1a2fe9f6f1e7a9302890747d934c upstream.

If the call to of_device_get_match_data() fails on probe of the Atmel
QuadSPI driver, the clock "aq->pclk" is erroneously not unprepared and
disabled.  Fix it.

Fixes: 2e5c88887358 ("spi: atmel-quadspi: add support for sam9x60 qspi controller")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.1+
Cc: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/8f8dc2815aa97b2378528f08f923bf81e19611f0.1604874488.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/atmel-quadspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -591,7 +591,7 @@ static int atmel_qspi_probe(struct platf
 	if (!aq->caps) {
 		dev_err(&pdev->dev, "Could not retrieve QSPI caps\n");
 		err = -EINVAL;
-		goto exit;
+		goto disable_pclk;
 	}
 
 	if (aq->caps->has_qspick) {


