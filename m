Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530F32E42BF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406669AbgL1N5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:57:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406665AbgL1N53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:57:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D36320738;
        Mon, 28 Dec 2020 13:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163808;
        bh=yZ8kIs7s2Sbudt+b2ZeXVSOIkJ9LAM4kxdtzlDiWQwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afOO1HRMxwZMjS0y/6yb2lgS4vRwqC5TB9b3Am2ba8rA77J6RVGJ3l/B3yNp6APTl
         usSek0nwFPDlD6CeJaduTbnsWdT0ToS3Vp2T3wGzRCLml5v/MCnz5qZAmzcSRkbpmq
         gVck3+wslheEyIjuC70ipuBHUZNJoomsW2zotX1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 415/453] spi: atmel-quadspi: Disable clock in probe error path
Date:   Mon, 28 Dec 2020 13:50:51 +0100
Message-Id: <20201228124957.190111003@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
@@ -510,7 +510,7 @@ static int atmel_qspi_probe(struct platf
 	if (!aq->caps) {
 		dev_err(&pdev->dev, "Could not retrieve QSPI caps\n");
 		err = -EINVAL;
-		goto exit;
+		goto disable_pclk;
 	}
 
 	if (aq->caps->has_qspick) {


