Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF09404E6A
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346952AbhIIMLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344202AbhIIMJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2344E619E7;
        Thu,  9 Sep 2021 11:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188085;
        bh=MP8k0tbPkkWCNW/KF4amoLchFi+kfZBT/G4Tf4L7AqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLiWV9ZhE2kuNRB/5LtAiz5GuU9/9QuZCq/MD4r3+Fqj6MTg/GbmfTfUZWn/k8yqw
         /U7WVIIP6V5/iiu79MEvwLFf237TcSwkkuV9UEmxvR8TQobF0EgTdN2frv9wk+wDgt
         yAUHPPe56rABn+VESs6L4TdnZBsfUdqI8fw6yCLxVIo39ES66TYrpiZbBgYaP0BLfP
         Nip//+ik8un4i0ufCg992/2RYWDstQNfeMsEKbL4RvCkjoqdUsswuG62U38G6lKqrb
         N2Y+iTU5JAevU3mKCYaTIeOWNs6TErrZmwPEUCsDFc1iMqJ3qUYzZS9EBN+NFs0v8v
         W0UURGyDIDrjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Jordy Zomer <jordy@pwning.systems>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 070/219] serial: 8250_pci: make setup_port() parameters explicitly unsigned
Date:   Thu,  9 Sep 2021 07:44:06 -0400
Message-Id: <20210909114635.143983-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 1934940b9617..2ad136dcfcc8 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -87,7 +87,7 @@ static void moan_device(const char *str, struct pci_dev *dev)
 
 static int
 setup_port(struct serial_private *priv, struct uart_8250_port *port,
-	   int bar, int offset, int regshift)
+	   u8 bar, unsigned int offset, int regshift)
 {
 	struct pci_dev *dev = priv->dev;
 
-- 
2.30.2

