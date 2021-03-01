Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B1D328EB7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242114AbhCATfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:35:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241889AbhCAT3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08F6E651FB;
        Mon,  1 Mar 2021 17:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619202;
        bh=alnWrZccUvBfsoVvvdznE4kZl6VBD8rXoxUhfQ2/FF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuWqU+/i7Au7LEeh1ICEoB3+kpvFcgZx1vmqcBDOLcW5X6mozxnB9pi8tqvztrKUO
         o6vv2my9w9+0GXKXpLgUg+WtKZdNmysH41UpeMkDcgm6u06OuUowUVz3puUx2acHZI
         /9N6CVlK9vny8J0JWwjfpuOb4v0i/ZooIOEWgME8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 370/663] spi: Skip zero-length transfers in spi_transfer_one_message()
Date:   Mon,  1 Mar 2021 17:10:18 +0100
Message-Id: <20210301161200.154477680@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit b306320322c9cfaa465bc2c7367acf6072b1ac0e ]

With the introduction of 26751de25d25 ("spi: bcm2835: Micro-optimise
FIFO loops") it has become apparent that some users might initiate
zero-length SPI transfers. A fact the micro-optimization omitted, and
which turned out to cause crashes[1].

Instead of changing the micro-optimization itself, use a bigger hammer
and skip zero-length transfers altogether for drivers using the default
transfer_one_message() implementation.

Reported-by: Phil Elwell <phil@raspberrypi.com>
Fixes: 26751de25d25 ("spi: bcm2835: Micro-optimise FIFO loops")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[1] https://github.com/raspberrypi/linux/issues/4100
Link: https://lore.kernel.org/r/20210211180820.25757-1-nsaenzjulienne@suse.de

Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 7694e1ae5b0b2..4257a2d368f71 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1259,7 +1259,7 @@ static int spi_transfer_one_message(struct spi_controller *ctlr,
 			ptp_read_system_prets(xfer->ptp_sts);
 		}
 
-		if (xfer->tx_buf || xfer->rx_buf) {
+		if ((xfer->tx_buf || xfer->rx_buf) && xfer->len) {
 			reinit_completion(&ctlr->xfer_completion);
 
 fallback_pio:
-- 
2.27.0



