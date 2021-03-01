Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB42329040
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242780AbhCAUDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242578AbhCATyF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C27E264FDA;
        Mon,  1 Mar 2021 17:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621261;
        bh=PbN+itfetpLApp7M9o6j/JCahEK2pCKdog1Q38riV3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fU4RG62+8AWC7M5+H9F359pF8wLb2sPgsLFZ26Z/wD+WyzSH99zhcpZGTUSkdqQoZ
         AMXkSN9rVSPt3M/aGofe6sBeOsQDjxSxq8q3Cb1/EdszR0qeyDKoq7vzRVqxGHbgkh
         wGYhmMdHmWxl/Ccis3gCY4PFLh2BEEFQk9B3SyWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 451/775] spi: Skip zero-length transfers in spi_transfer_one_message()
Date:   Mon,  1 Mar 2021 17:10:19 +0100
Message-Id: <20210301161223.834895577@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 720ab34784c1d..ccca3a7409fac 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1267,7 +1267,7 @@ static int spi_transfer_one_message(struct spi_controller *ctlr,
 			ptp_read_system_prets(xfer->ptp_sts);
 		}
 
-		if (xfer->tx_buf || xfer->rx_buf) {
+		if ((xfer->tx_buf || xfer->rx_buf) && xfer->len) {
 			reinit_completion(&ctlr->xfer_completion);
 
 fallback_pio:
-- 
2.27.0



