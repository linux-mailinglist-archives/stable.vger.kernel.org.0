Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3991E419A3C
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbhI0RHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236103AbhI0RG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:06:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 320C3611EF;
        Mon, 27 Sep 2021 17:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762319;
        bh=UqXo4oazMsP4mAr6vlIQFUKowq05QtjXrFAguRo+IBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5JG8L9dplEsBhcvTBRuKxLegg4WaWa860pADjH8Ocq086aEihHcrCB0OiVuNb8Hj
         PeJWmkp/fU+8mHf9QAryP6tgNRBcqn8uYMJxyZfX83vR4iKVtF817+9FmEL8ffa1uG
         CstAF3OP7L5qotcdMDk71kSTn+g5QUM9eJWFvSjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Ferre <Nicolas.Ferre@microchip.com>,
        Tong Zhang <ztong0001@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 46/68] net: macb: fix use after free on rmmod
Date:   Mon, 27 Sep 2021 19:02:42 +0200
Message-Id: <20210927170221.558476170@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit d82d5303c4c539db86588ffb5dc5b26c3f1513e8 ]

plat_dev->dev->platform_data is released by platform_device_unregister(),
use of pclk and hclk is a use-after-free. Since device unregister won't
need a clk device we adjust the function call sequence to fix this issue.

[   31.261225] BUG: KASAN: use-after-free in macb_remove+0x77/0xc6 [macb_pci]
[   31.275563] Freed by task 306:
[   30.276782]  platform_device_release+0x25/0x80

Suggested-by: Nicolas Ferre <Nicolas.Ferre@microchip.com>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 617b3b728dd0..94f3babfad30 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -112,9 +112,9 @@ static void macb_remove(struct pci_dev *pdev)
 	struct platform_device *plat_dev = pci_get_drvdata(pdev);
 	struct macb_platform_data *plat_data = dev_get_platdata(&plat_dev->dev);
 
-	platform_device_unregister(plat_dev);
 	clk_unregister(plat_data->pclk);
 	clk_unregister(plat_data->hclk);
+	platform_device_unregister(plat_dev);
 }
 
 static const struct pci_device_id dev_id_table[] = {
-- 
2.33.0



