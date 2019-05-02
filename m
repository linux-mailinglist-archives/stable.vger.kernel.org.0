Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D36A11E84
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfEBPhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728690AbfEBPaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:30:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAE5C20B7C;
        Thu,  2 May 2019 15:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811016;
        bh=9cfkjKJhKFyg+kUI5gYHuFHBzIfYZ/2LtqZ2CTwKTI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEixlwwQtJbHJdD16hJqByMkCV+HsjnWyc95Om6JqAvWqyNCMopkfCdqyRVXbYsVr
         j8Rvdk0axUfDW5Z+nZJUYpX814ZBHDG9hy/GoZ/appaYhahafuhKxNf7LI5rpRICZu
         Dk+dNtHLc5v2fOsAgA+HRcwylKaP20Vh/OIoQ/9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Frank Pavlic <f.pavlic@kunbus.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Nishanth Menon <nm@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 043/101] net: ks8851: Reassert reset pin if chip ID check fails
Date:   Thu,  2 May 2019 17:20:45 +0200
Message-Id: <20190502143342.573769233@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
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
index a93f8e842c07..1633fa5c709c 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -1554,9 +1554,9 @@ static int ks8851_probe(struct spi_device *spi)
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



