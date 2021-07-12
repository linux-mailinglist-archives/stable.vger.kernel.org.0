Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6453B3C4540
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhGLGYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235059AbhGLGY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5689A61166;
        Mon, 12 Jul 2021 06:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070868;
        bh=+ilQCIlE2y3de7ZS9NMuQr591m8ljn399G6pW+yPewM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bodp3IEb67wD31kpdYUVowKxmmrCmJWRS2bF81cvttroTN+GlUmdN6GubLc8jVk2v
         pVZc1GKz1C5aazC78thDTK8vrO7mie/iq8NSY+mVNNEB/F4brk6y55SibLdRM0Llsb
         2lu4M6Cxull9hJCa4AjjRE1dp2IHksGMtsRQoGY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/348] extcon: extcon-max8997: Fix IRQ freeing at error path
Date:   Mon, 12 Jul 2021 08:09:20 +0200
Message-Id: <20210712060724.257904861@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 610bdc04830a864115e6928fc944f1171dfff6f3 ]

If reading MAX8997_MUIC_REG_STATUS1 fails at probe the driver exits
without freeing the requested IRQs.

Free the IRQs prior returning if reading the status fails.

Fixes: 3e34c8198960 ("extcon: max8997: Avoid forcing UART path on drive probe")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Link: https://lore.kernel.org/r/27ee4a48ee775c3f8c9d90459c18b6f2b15edc76.1623146580.git.matti.vaittinen@fi.rohmeurope.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-max8997.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 172e116ac1ce..ac1633adb55d 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -729,7 +729,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 				2, info->status);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
-		return ret;
+		goto err_irq;
 	}
 	cable_type = max8997_muic_get_cable_type(info,
 					   MAX8997_CABLE_GROUP_ADC, &attached);
-- 
2.30.2



