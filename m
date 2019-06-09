Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87F6D3A7C7
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732353AbfFIQxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732351AbfFIQxI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:53:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F42204EC;
        Sun,  9 Jun 2019 16:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099188;
        bh=uyIkaYx4Do60DeM1Fok7P3O2zNsV3shDL6HrAbissfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxognPBUsw4mwLVo9q2nj0vHhvZ3QQN76XE/YyyJMBILH/saAdDWxA/ZnycfswhGn
         fdjPuULwTz1xBVtGD1DiuaitB3QbSAfF+DueSQtTnm/QjILI0ao9FK+1rPwa1u80fp
         7L/8ys60gJAbd5gEcMUvY0WXGYKYTW90odN8qKkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joe Burmeister <joe.burmeister@devtank.co.uk>
Subject: [PATCH 4.9 41/83] tty: max310x: Fix external crystal register setup
Date:   Sun,  9 Jun 2019 18:42:11 +0200
Message-Id: <20190609164131.392566346@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Burmeister <joe.burmeister@devtank.co.uk>

commit 5d24f455c182d5116dd5db8e1dc501115ecc9c2c upstream.

The datasheet states:

  Bit 4: ClockEnSet the ClockEn bit high to enable an external clocking
(crystal or clock generator at XIN). Set the ClockEn bit to 0 to disable
clocking
  Bit 1: CrystalEnSet the CrystalEn bit high to enable the crystal
oscillator. When using an external clock source at XIN, CrystalEn must
be set low.

The bit 4, MAX310X_CLKSRC_EXTCLK_BIT, should be set and was not.

This was required to make the MAX3107 with an external crystal on our
board able to send or receive data.

Signed-off-by: Joe Burmeister <joe.burmeister@devtank.co.uk>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/max310x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -579,7 +579,7 @@ static int max310x_set_ref_clk(struct ma
 	}
 
 	/* Configure clock source */
-	clksrc = xtal ? MAX310X_CLKSRC_CRYST_BIT : MAX310X_CLKSRC_EXTCLK_BIT;
+	clksrc = MAX310X_CLKSRC_EXTCLK_BIT | (xtal ? MAX310X_CLKSRC_CRYST_BIT : 0);
 
 	/* Configure PLL */
 	if (pllcfg) {


