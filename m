Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2503413EB27
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391601AbgAPRsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:48:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406720AbgAPRqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:46:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ECD1246B8;
        Thu, 16 Jan 2020 17:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196795;
        bh=fPlNpHQvfkloCcuCGF/dUff98NWTDSU1o9YkuNNxshY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrnrYqVxzoEQlRmwjaDpfx3pt/mIJ1WJuSJFFjPdrwAk0fwLNES0GRH2Kh6jdLNjN
         vOXZdkwGuF9G+iGTKHnuXT+Bp477OUwV+p3tOzp3G8i/LTY34ve/7dGeArcXP6Gltr
         ATiEZZYUOoAcCQ7eYy710psBVjduG3WavhVuOVBc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mans Rullgard <mans@mansr.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 156/174] spi: atmel: fix handling of cs_change set on non-last xfer
Date:   Thu, 16 Jan 2020 12:42:33 -0500
Message-Id: <20200116174251.24326-156-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mans Rullgard <mans@mansr.com>

[ Upstream commit fed8d8c7a6dc2a76d7764842853d81c770b0788e ]

The driver does the wrong thing when cs_change is set on a non-last
xfer in a message.  When cs_change is set, the driver deactivates the
CS and leaves it off until a later xfer again has cs_change set whereas
it should be briefly toggling CS off and on again.

This patch brings the behaviour of the driver back in line with the
documentation and common sense.  The delay of 10 us is the same as is
used by the default spi_transfer_one_message() function in spi.c.
[gregory: rebased on for-5.5 from spi tree]
Fixes: 8090d6d1a415 ("spi: atmel: Refactor spi-atmel to use SPI framework queue")
Signed-off-by: Mans Rullgard <mans@mansr.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://lore.kernel.org/r/20191018153504.4249-1-gregory.clement@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-atmel.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 691c04b3e5b6..938840af9c50 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -315,7 +315,6 @@ struct atmel_spi {
 	struct atmel_spi_dma	dma;
 
 	bool			keep_cs;
-	bool			cs_active;
 
 	u32			fifo_size;
 };
@@ -1404,11 +1403,9 @@ static int atmel_spi_one_transfer(struct spi_master *master,
 				 &msg->transfers)) {
 			as->keep_cs = true;
 		} else {
-			as->cs_active = !as->cs_active;
-			if (as->cs_active)
-				cs_activate(as, msg->spi);
-			else
-				cs_deactivate(as, msg->spi);
+			cs_deactivate(as, msg->spi);
+			udelay(10);
+			cs_activate(as, msg->spi);
 		}
 	}
 
@@ -1431,7 +1428,6 @@ static int atmel_spi_transfer_one_message(struct spi_master *master,
 	atmel_spi_lock(as);
 	cs_activate(as, spi);
 
-	as->cs_active = true;
 	as->keep_cs = false;
 
 	msg->status = 0;
-- 
2.20.1

