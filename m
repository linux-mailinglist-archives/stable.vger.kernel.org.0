Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3DB450CCC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238629AbhKORnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:43:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238531AbhKORlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:41:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 073F2632F1;
        Mon, 15 Nov 2021 17:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997231;
        bh=dznoPEksPZO0Q3PzLYCLc7siCGASutxA5Lx95pffJL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhr32yF73lDXX0KCBrUhQeN9asPIqdBvyjvgU3A5iaTGyoAg7++BfoC8WFam0WC74
         XobRQxIGNbodKkSLyKwZ03trcCnIY9X4OaW4wc9Yjvp9pINwAlHoRZqL+ORSx7OUjo
         yiwpHUFyVaes7lR6Hu/kcXRXLkkGlxwi/JZGTyu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Perrot <thomas.perrot@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/575] spi: spl022: fix Microwire full duplex mode
Date:   Mon, 15 Nov 2021 17:56:36 +0100
Message-Id: <20211115165346.090990810@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Perrot <thomas.perrot@bootlin.com>

[ Upstream commit d81d0e41ed5fe7229a2c9a29d13bad288c7cf2d2 ]

There are missing braces in the function that verify controller parameters,
then an error is always returned when the parameter to select Microwire
frames operation is used on devices allowing it.

Signed-off-by: Thomas Perrot <thomas.perrot@bootlin.com>
Link: https://lore.kernel.org/r/20211022142104.1386379-1-thomas.perrot@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pl022.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index d1776fea287e5..e4ee8b0847993 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1723,12 +1723,13 @@ static int verify_controller_parameters(struct pl022 *pl022,
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
2.33.0



