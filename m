Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 435A2119920
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfLJVnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727310AbfLJVdq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:33:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FDCD2465B;
        Tue, 10 Dec 2019 21:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013626;
        bh=M0d+gOqWSOd0I8oIkrNJWdjHyP0Kdwz5xGK+Eo5egks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzmL8pSJBLVmR+G1BRIoNDvIZIK/W1fVO0xGwn+Twgs0dRkqV3RM965JEtIZ8lnkH
         Tb6S6rbpW/gpzxOFvziuO6y+dBvumV6ecCoSHNhqBRIifl+KjFv7b5TDJFNn2KptvN
         gkt6pTRMThkGF3fb03zVhBY8OUh3nrJQ2wr5rdKM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <wahrenst@gmx.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 068/177] Bluetooth: hci_bcm: Fix RTS handling during startup
Date:   Tue, 10 Dec 2019 16:30:32 -0500
Message-Id: <20191210213221.11921-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 3347a80965b38f096b1d6f995c00c9c9e53d4b8b ]

The RPi 4 uses the hardware handshake lines for CYW43455, but the chip
doesn't react to HCI requests during DT probe. The reason is the inproper
handling of the RTS line during startup. According to the startup
signaling sequence in the CYW43455 datasheet, the hosts RTS line must
be driven after BT_REG_ON and BT_HOST_WAKE.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_bcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index 59e5fc5eec8f8..b88cb7bf7f8ab 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -414,9 +414,11 @@ static int bcm_open(struct hci_uart *hu)
 
 out:
 	if (bcm->dev) {
+		hci_uart_set_flow_control(hu, true);
 		hu->init_speed = bcm->dev->init_speed;
 		hu->oper_speed = bcm->dev->oper_speed;
 		err = bcm_gpio_set_power(bcm->dev, true);
+		hci_uart_set_flow_control(hu, false);
 		if (err)
 			goto err_unset_hu;
 	}
-- 
2.20.1

