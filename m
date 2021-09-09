Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAF1405681
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359825AbhIINU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359014AbhIINLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:11:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13B54632D0;
        Thu,  9 Sep 2021 12:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188901;
        bh=t2DnsPgOihfcUtjeeX67dy+A84XuD9Hq03BYlV5z3uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJIkzm9OfMwgYhXvCyEZDf/pb3IyN7qNNcj3tj7OzFl4/CHu1Z7NzR6jq26Cxbrr4
         yi8yySDAPzj3a0/GaMZYbOUVIqBQ/CxGh6V199uQeJYAozkg7/MZ795yGFCRigrKxP
         ar3DGOJ9V9DJFkf95lXCFmXgvF2/doq6olNps5H51PortqmoZcNyo4CUwr6K0vRRJk
         rJEEdoLO5OaeSKzwkC+9sLQRsd3EvvICdY+o0wMmXNerWELg0W7f1I1Fr7lEjqoJdC
         6b95sBTvEsm3uURZQs3ObbMjPlJ6WIxFIA8Jv/Omi5jLWG2QeZwgcKOConBS1mXjeF
         tiCzFOTl4a3xQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Jordy Zomer <jordy@pwning.systems>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 20/35] serial: 8250_pci: make setup_port() parameters explicitly unsigned
Date:   Thu,  9 Sep 2021 08:01:01 -0400
Message-Id: <20210909120116.150912-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120116.150912-1-sashal@kernel.org>
References: <20210909120116.150912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 3a96e97ab4e835078e6f27b7e1c0947814df3841 ]

The bar and offset parameters to setup_port() are used in pointer math,
and while it would be very difficult to get them to wrap as a negative
number, just be "safe" and make them unsigned so that static checkers do
not trip over them unintentionally.

Cc: Jiri Slaby <jirislaby@kernel.org>
Reported-by: Jordy Zomer <jordy@pwning.systems>
Link: https://lore.kernel.org/r/20210726130717.2052096-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 72f6cde146b5..db66e533319e 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -78,7 +78,7 @@ static void moan_device(const char *str, struct pci_dev *dev)
 
 static int
 setup_port(struct serial_private *priv, struct uart_8250_port *port,
-	   int bar, int offset, int regshift)
+	   u8 bar, unsigned int offset, int regshift)
 {
 	struct pci_dev *dev = priv->dev;
 
-- 
2.30.2

