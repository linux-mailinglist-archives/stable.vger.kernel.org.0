Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DE917FC6D
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbgCJNVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730848AbgCJNG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:06:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DFA220409;
        Tue, 10 Mar 2020 13:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845586;
        bh=uVF9Hhhe0uNmt+VdBVe8UzNmmAax9OOOWGcDcal7yGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APnyGm/RiLLIddHspzqdADPZVFDmdoZxUVqW1wrFlkouApCCiBB/IFJ96zxqLvLwx
         vzTIV2l8odTKmi35o/Wv9lErcqDMKtqbXvu/qTXXawbQCRum308c+afr+0oALWXLmi
         4aPEnWBQDx0VBEeICqI/kXzmyuEw68ZHs1BcVavg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 028/126] nfc: pn544: Fix occasional HW initialization failure
Date:   Tue, 10 Mar 2020 13:40:49 +0100
Message-Id: <20200310124206.264467051@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit c3331d2fe3fd4d5e321f2467d01f72de7edfb5d0 ]

The PN544 driver checks the "enable" polarity during of driver's probe and
it's doing that by turning ON and OFF NFC with different polarities until
enabling succeeds. It takes some time for the hardware to power-down, and
thus, to deassert the IRQ that is raised by turning ON the hardware.
Since the delay after last power-down of the polarity-checking process is
missed in the code, the interrupt may trigger immediately after installing
the IRQ handler (right after the checking is done), which results in IRQ
handler trying to touch the disabled HW and ends with marking NFC as
'DEAD' during of the driver's probe:

  pn544_hci_i2c 1-002a: NFC: nfc_en polarity : active high
  pn544_hci_i2c 1-002a: NFC: invalid len byte
  shdlc: llc_shdlc_recv_frame: NULL Frame -> link is dead

This patch fixes the occasional NFC initialization failure on Nexus 7
device.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/pn544/i2c.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -236,6 +236,7 @@ static void pn544_hci_i2c_platform_init(
 
 out:
 	gpiod_set_value_cansleep(phy->gpiod_en, !phy->en_polarity);
+	usleep_range(10000, 15000);
 }
 
 static void pn544_hci_i2c_enable_mode(struct pn544_i2c_phy *phy, int run_mode)


