Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F904411DFC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhITR0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:26:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349689AbhITRYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:24:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADE9561A84;
        Mon, 20 Sep 2021 17:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157320;
        bh=av8WWl+49meWu0mDLRsOPNjCV8ibfb2FsHfzZaKO2ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdWpaw1kjkAei7kmFtCTIrkGTKFw8C/7JS1x9JoweyRXapFrnjaC7BsdAmqxca8hh
         fsnIX5FPZz/I4pElWSXvpLuqzOl13Bd5uk4EgZ3Q02IFN7+RzOhl1MN4brubAZV1xu
         4FByqvOidY3c5MY+xPhYTOyboblSY+9pBlPctKq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Jordy Zomer <jordy@pwning.systems>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 155/217] serial: 8250_pci: make setup_port() parameters explicitly unsigned
Date:   Mon, 20 Sep 2021 18:42:56 +0200
Message-Id: <20210920163929.888886660@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 071ee37399b7..72015cc7b33f 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -73,7 +73,7 @@ static void moan_device(const char *str, struct pci_dev *dev)
 
 static int
 setup_port(struct serial_private *priv, struct uart_8250_port *port,
-	   int bar, int offset, int regshift)
+	   u8 bar, unsigned int offset, int regshift)
 {
 	struct pci_dev *dev = priv->dev;
 
-- 
2.30.2



