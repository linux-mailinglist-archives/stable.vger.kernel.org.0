Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6934378F6
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 16:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbhJVOXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 10:23:31 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:40559 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbhJVOXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 10:23:31 -0400
Received: (Authenticated sender: thomas.perrot@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id A203F1BF214;
        Fri, 22 Oct 2021 14:21:12 +0000 (UTC)
From:   Thomas Perrot <thomas.perrot@bootlin.com>
To:     linux-spi@vger.kernel.org
Cc:     broonie@kernel.org, linus.walleij@linaro.org,
        stable@vger.kernel.org, Thomas Perrot <thomas.perrot@bootlin.com>
Subject: [PATCH] spi: spl022: fix Microwire full duplex mode
Date:   Fri, 22 Oct 2021 16:21:04 +0200
Message-Id: <20211022142104.1386379-1-thomas.perrot@bootlin.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are missing braces in the function that verify controller parameters,
then an error is always returned when the parameter to select Microwire
frames operation is used on devices allowing it.

Signed-off-by: Thomas Perrot <thomas.perrot@bootlin.com>
---
 drivers/spi/spi-pl022.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index feebda66f56e..e4484ace584e 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1716,12 +1716,13 @@ static int verify_controller_parameters(struct pl022 *pl022,
 				return -EINVAL;
 			}
 		} else {
-			if (chip_info->duplex != SSP_MICROWIRE_CHANNEL_FULL_DUPLEX)
+			if (chip_info->duplex != SSP_MICROWIRE_CHANNEL_FULL_DUPLEX) {
 				dev_err(&pl022->adev->dev,
 					"Microwire half duplex mode requested,"
 					" but this is only available in the"
 					" ST version of PL022\n");
-			return -EINVAL;
+				return -EINVAL;
+			}
 		}
 	}
 	return 0;
-- 
2.31.1

