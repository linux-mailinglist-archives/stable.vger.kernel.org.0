Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CC527C727
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731137AbgI2Lvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731121AbgI2LsS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82F1F20702;
        Tue, 29 Sep 2020 11:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380098;
        bh=4dhuKEGjKN5Lugen+8MVSN9xqZT6R/7k0bNZwKsS9l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cE8h7oAvBcRT/3uxmFMDbuSv9oj4YcmFLVSui+lZfW4klqGfVG/YHXoXmx4B77YPt
         5g/w+VRAREF46kzgEdKIIMckCT9UinVJYjGA4wiXTLHEre2Pt7MQTm8/b/DAmn7dJu
         rr+fm9HJ4XDYf+n1kgmzd/Ye9OOHFh5mE/EQ+z60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ray Jui <ray.jui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 67/99] spi: bcm-qspi: Fix probe regression on iProc platforms
Date:   Tue, 29 Sep 2020 13:01:50 +0200
Message-Id: <20200929105933.025542564@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ray Jui <ray.jui@broadcom.com>

[ Upstream commit 00fb259c618ea1198fc51b53a6167aa0d78672a9 ]

iProc chips have QSPI controller that does not have the MSPI_REV
offset. Reading from that offset will cause a bus error. Fix it by
having MSPI_REV query disabled in the generic compatible string.

Fixes: 3a01f04d74ef ("spi: bcm-qspi: Handle lack of MSPI_REV offset")
Link: https://lore.kernel.org/linux-arm-kernel/20200909211857.4144718-1-f.fainelli@gmail.com/T/#u
Signed-off-by: Ray Jui <ray.jui@broadcom.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20200910152539.45584-3-ray.jui@broadcom.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index 681d090851756..9cfa15ec8b08c 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1295,7 +1295,7 @@ static const struct of_device_id bcm_qspi_of_match[] = {
 	},
 	{
 		.compatible = "brcm,spi-bcm-qspi",
-		.data = &bcm_qspi_rev_data,
+		.data = &bcm_qspi_no_rev_data,
 	},
 	{
 		.compatible = "brcm,spi-bcm7216-qspi",
-- 
2.25.1



