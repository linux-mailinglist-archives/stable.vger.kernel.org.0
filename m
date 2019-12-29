Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3DA12C495
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbfL2Ra7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:30:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbfL2Rax (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:30:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D8A6207FF;
        Sun, 29 Dec 2019 17:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640653;
        bh=TfimsuIF6EybkJwgJ0GEs0c71QsnFaT5U9YqQV7DJUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBD3CipqAIzU4R1wILrmEqJmOW11ycnflAtx3Ark2vWiA6FzdMfFqgoXQ57jeLXZ4
         8irZa/BdtbN1tZdm+HFM8CFTvfPw7GemjjBWNQfMz7ldxqF9urwOtTlN0+oxXrDU5h
         UOoRuF2cEkfzfAzPM2moZnKjzAkRzpczku3yKsZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Szymon Janc <szymon.janc@codecoup.pl>,
        =?UTF-8?q?S=C3=B6ren=20Beye?= <linux@hypfer.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 082/219] Bluetooth: Workaround directed advertising bug in Broadcom controllers
Date:   Sun, 29 Dec 2019 18:18:04 +0100
Message-Id: <20191229162517.979966167@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Szymon Janc <szymon.janc@codecoup.pl>

[ Upstream commit 4c371bb95cf06ded80df0e6139fdd77cee1d9a94 ]

It appears that some Broadcom controllers (eg BCM20702A0) reject LE Set
Advertising Parameters command if advertising intervals provided are not
within range for undirected and low duty directed advertising.

Workaround this bug by populating min and max intervals with 'valid'
values.

< HCI Command: LE Set Advertising Parameters (0x08|0x0006) plen 15
        Min advertising interval: 0.000 msec (0x0000)
        Max advertising interval: 0.000 msec (0x0000)
        Type: Connectable directed - ADV_DIRECT_IND (high duty cycle) (0x01)
        Own address type: Public (0x00)
        Direct address type: Random (0x01)
        Direct address: E2:F0:7B:9F:DC:F4 (Static)
        Channel map: 37, 38, 39 (0x07)
        Filter policy: Allow Scan Request from Any, Allow Connect Request from Any (0x00)
> HCI Event: Command Complete (0x0e) plen 4
      LE Set Advertising Parameters (0x08|0x0006) ncmd 1
        Status: Invalid HCI Command Parameters (0x12)

Signed-off-by: Szymon Janc <szymon.janc@codecoup.pl>
Tested-by: Sören Beye <linux@hypfer.de>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 15d1cb5aee18..f5c27065ad44 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -931,6 +931,14 @@ static void hci_req_directed_advertising(struct hci_request *req,
 			return;
 
 		memset(&cp, 0, sizeof(cp));
+
+		/* Some controllers might reject command if intervals are not
+		 * within range for undirected advertising.
+		 * BCM20702A0 is known to be affected by this.
+		 */
+		cp.min_interval = cpu_to_le16(0x0020);
+		cp.max_interval = cpu_to_le16(0x0020);
+
 		cp.type = LE_ADV_DIRECT_IND;
 		cp.own_address_type = own_addr_type;
 		cp.direct_addr_type = conn->dst_type;
-- 
2.20.1



