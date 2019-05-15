Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F4A1F418
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfEOK7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfEOK7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:59:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B0CF21726;
        Wed, 15 May 2019 10:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917973;
        bh=jm02f6r3ja8E6ZgprEgR7RUosz5EhAKEbLMC+rj/3Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCjIKCzc+XooxsdY6h7f/z4VbzdNxSee+rBbMtVyoYxJ4NvNlCf/d86z4PltYzIc5
         DGRWN+41GvXUNHYOtIImuo/KctS50T8aRA+LyszfKHbGlXP9zBOqQ0dnHSEM3yr6h8
         J/Ry3dD++U4Y1ZFOFaYXstOB8q1ZcEnCTEJC2axY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Frank Pavlic <f.pavlic@kunbus.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Nishanth Menon <nm@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 3.18 18/86] net: ks8851: Reassert reset pin if chip ID check fails
Date:   Wed, 15 May 2019 12:54:55 +0200
Message-Id: <20190515090646.270274808@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 761cfa979a0c177d6c2d93ef5585cd79ae49a7d5 ]

Commit 73fdeb82e963 ("net: ks8851: Add optional vdd_io regulator and
reset gpio") amended the ks8851 driver to briefly assert the chip's
reset pin on probe. It also amended the probe routine's error path to
reassert the reset pin if a subsequent initialization step fails.

However the commit misplaced reassertion of the reset pin in the error
path such that it is not performed if the check of the Chip ID and
Enable Register (CIDER) fails. The error path is therefore slightly
asymmetrical to the probe routine's body. Fix it.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Frank Pavlic <f.pavlic@kunbus.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Nishanth Menon <nm@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 4a29e191819f..e218e45dcf35 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -1567,9 +1567,9 @@ static int ks8851_probe(struct spi_device *spi)
 	free_irq(ndev->irq, ks);
 
 err_irq:
+err_id:
 	if (gpio_is_valid(gpio))
 		gpio_set_value(gpio, 0);
-err_id:
 	regulator_disable(ks->vdd_reg);
 err_reg:
 	regulator_disable(ks->vdd_io);
-- 
2.19.1



