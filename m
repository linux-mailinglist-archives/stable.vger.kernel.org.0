Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89983783D3
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhEJKro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233238AbhEJKpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 861E7617ED;
        Mon, 10 May 2021 10:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642930;
        bh=kkZn66uEtrWL5Vl4tdi9AGp/h8d/LWjsdeIG/LbGNL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avoVDl9i+/YGLlJWdK2W+T5r+SPpw0VBv61BwVYp4xz/z5pbCeMQAkUathUZ16Uag
         TttaI+wKtrgomMeNZO1Y2KXIQi+c1+3FoP2Bb2Ataw6Bh1tpRv7+mYKrtd2E6utEYo
         tFinyQnw++ONNHqdk6dq/9iQfy6BilNIwSjgahQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Bauer <mail@david-bauer.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/299] spi: sync up initial chipselect state
Date:   Mon, 10 May 2021 12:18:26 +0200
Message-Id: <20210510102008.538475522@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Bauer <mail@david-bauer.net>

[ Upstream commit d347b4aaa1a042ea528e385d9070b74c77a14321 ]

When initially probing the SPI slave device, the call for disabling an
SPI device without the SPI_CS_HIGH flag is not applied, as the
condition for checking whether or not the state to be applied equals the
one currently set evaluates to true.

This however might not necessarily be the case, as the chipselect might
be active.

Add a force flag to spi_set_cs which allows to override this
early exit condition. Set it to false everywhere except when called
from spi_setup to sync up the initial CS state.

Fixes commit d40f0b6f2e21 ("spi: Avoid setting the chip select if we don't
need to")

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://lore.kernel.org/r/20210416195956.121811-1-mail@david-bauer.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 4257a2d368f7..1eee8b3c1b38 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -787,7 +787,7 @@ int spi_register_board_info(struct spi_board_info const *info, unsigned n)
 
 /*-------------------------------------------------------------------------*/
 
-static void spi_set_cs(struct spi_device *spi, bool enable)
+static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
 {
 	bool enable1 = enable;
 
@@ -795,7 +795,7 @@ static void spi_set_cs(struct spi_device *spi, bool enable)
 	 * Avoid calling into the driver (or doing delays) if the chip select
 	 * isn't actually changing from the last time this was called.
 	 */
-	if ((spi->controller->last_cs_enable == enable) &&
+	if (!force && (spi->controller->last_cs_enable == enable) &&
 	    (spi->controller->last_cs_mode_high == (spi->mode & SPI_CS_HIGH)))
 		return;
 
@@ -1243,7 +1243,7 @@ static int spi_transfer_one_message(struct spi_controller *ctlr,
 	struct spi_statistics *statm = &ctlr->statistics;
 	struct spi_statistics *stats = &msg->spi->statistics;
 
-	spi_set_cs(msg->spi, true);
+	spi_set_cs(msg->spi, true, false);
 
 	SPI_STATISTICS_INCREMENT_FIELD(statm, messages);
 	SPI_STATISTICS_INCREMENT_FIELD(stats, messages);
@@ -1311,9 +1311,9 @@ fallback_pio:
 					 &msg->transfers)) {
 				keep_cs = true;
 			} else {
-				spi_set_cs(msg->spi, false);
+				spi_set_cs(msg->spi, false, false);
 				_spi_transfer_cs_change_delay(msg, xfer);
-				spi_set_cs(msg->spi, true);
+				spi_set_cs(msg->spi, true, false);
 			}
 		}
 
@@ -1322,7 +1322,7 @@ fallback_pio:
 
 out:
 	if (ret != 0 || !keep_cs)
-		spi_set_cs(msg->spi, false);
+		spi_set_cs(msg->spi, false, false);
 
 	if (msg->status == -EINPROGRESS)
 		msg->status = ret;
@@ -3400,11 +3400,11 @@ int spi_setup(struct spi_device *spi)
 		 */
 		status = 0;
 
-		spi_set_cs(spi, false);
+		spi_set_cs(spi, false, true);
 		pm_runtime_mark_last_busy(spi->controller->dev.parent);
 		pm_runtime_put_autosuspend(spi->controller->dev.parent);
 	} else {
-		spi_set_cs(spi, false);
+		spi_set_cs(spi, false, true);
 	}
 
 	mutex_unlock(&spi->controller->io_mutex);
-- 
2.30.2



