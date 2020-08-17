Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B07246B68
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387990AbgHQPyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387585AbgHQPyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:54:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58C24208B3;
        Mon, 17 Aug 2020 15:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679654;
        bh=MuKES81dby8vu/2481wgeYCs8NeUZgA9l4NxwY1ZDI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cX39WBt80+2i1AcAY/CpjgU5Xf/BQ5sloCCFastkjrAqBHfaNWTtDaX/6oFEWDqjD
         tbTLHroftY8y9WbA9as4rPXRALQ99jId4NCrc9JibYSwO53r1M0TomN11m8QGtWPal
         TEcfe0TpM4rUJqSqB4YOmMeHpkrwzpzq/v1w++7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 257/393] Bluetooth: hci_h5: Set HCI_UART_RESET_ON_INIT to correct flags
Date:   Mon, 17 Aug 2020 17:15:07 +0200
Message-Id: <20200817143832.079057155@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>

[ Upstream commit a7ad4b6119d740b1ec5788f1b98be0fd1c1b5a5a ]

HCI_UART_RESET_ON_INIT belongs in hdev_flags, not flags.

Fixes: ce945552fde4a09 ("Bluetooth: hci_h5: Add support for serdev enumerated devices")
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_h5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 106c110efe560..0ce3d9fe02867 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -793,7 +793,7 @@ static int h5_serdev_probe(struct serdev_device *serdev)
 	if (!h5)
 		return -ENOMEM;
 
-	set_bit(HCI_UART_RESET_ON_INIT, &h5->serdev_hu.flags);
+	set_bit(HCI_UART_RESET_ON_INIT, &h5->serdev_hu.hdev_flags);
 
 	h5->hu = &h5->serdev_hu;
 	h5->serdev_hu.serdev = serdev;
-- 
2.25.1



