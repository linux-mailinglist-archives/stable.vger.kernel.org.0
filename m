Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907DC45B9E4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241485AbhKXMGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:06:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:60568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232580AbhKXMFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:05:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F6D9600EF;
        Wed, 24 Nov 2021 12:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755324;
        bh=c/A9rEv6MEbfdXuo8hHkDH6YxoXTEtFVR+YJmv66wck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zsJkNbOc03Wuopw3/T+lvpX+p+4AnqsKF97IsnMgBGMuG0FimxNpnH/SrXWs+ikre
         WMu0Cv1hQGp3r/c/e8zlLBWEA6tWuGygyZW+xwjs28p5qqMH4rYGTu6PGo/8KTFFRv
         V+p5TCGPgfly04/EustVHHlAEOpHgOoo/V8PyW3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Perrot <thomas.perrot@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 021/162] spi: spl022: fix Microwire full duplex mode
Date:   Wed, 24 Nov 2021 12:55:24 +0100
Message-Id: <20211124115659.019104477@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
index 5e5fd77e27119..e294f21db2068 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1710,12 +1710,13 @@ static int verify_controller_parameters(struct pl022 *pl022,
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



