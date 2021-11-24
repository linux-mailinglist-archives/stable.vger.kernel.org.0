Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1E945BF23
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346012AbhKXMz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:55:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:56468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345072AbhKXMwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:52:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94E4D61151;
        Wed, 24 Nov 2021 12:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757036;
        bh=ma63CkDqxciwZ18JmhCEtgkiaH5TchaXeqhGu8ZzZak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXTSpf9soJVH9BhRqUye2/YazdWHpykkuE6+SD3X3fnV7e7GHMHsqNIpfwzNG5yoJ
         5ZtF68pnOoua6wIEyawki2QblirzYsjnCuPgAzZHgfZ+yRdNo4uRciI2zL6Elvjb84
         DwSRvN665WFX7NPN41982pSOc9Ny3qopIb9IyYYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Perrot <thomas.perrot@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 035/323] spi: spl022: fix Microwire full duplex mode
Date:   Wed, 24 Nov 2021 12:53:45 +0100
Message-Id: <20211124115720.054336399@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index 1af8c96b940e2..aa04ff6e01b9d 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1703,12 +1703,13 @@ static int verify_controller_parameters(struct pl022 *pl022,
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



