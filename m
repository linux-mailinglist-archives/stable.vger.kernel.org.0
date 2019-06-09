Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33EE43A8E0
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387749AbfFIRFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388155AbfFIRFK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:05:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68000204EC;
        Sun,  9 Jun 2019 17:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099909;
        bh=04tc5K5pMkFcIKUQX04iMtZ9qekNA1F2dV6qUpFv4ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGAiTG/0SBG/hsLyv0Op+pJ4iyuOsinlsLFpyulpSeXGoOefXlgshkqvGKLtI9KdS
         sUfdKXUB3zZbnQTsIo0dRWCzCngTlNMJ1aSfa9s3O4arU0OvoY1sF9I6B0QQZearsG
         goy0XrbExnpsErSIDyqCwqxtuveQzbYHjp/aeAyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joe Burmeister <joe.burmeister@devtank.co.uk>
Subject: [PATCH 4.4 210/241] tty: max310x: Fix external crystal register setup
Date:   Sun,  9 Jun 2019 18:42:32 +0200
Message-Id: <20190609164154.724819740@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
@@ -571,7 +571,7 @@ static int max310x_set_ref_clk(struct ma
 	}
 
 	/* Configure clock source */
-	clksrc = xtal ? MAX310X_CLKSRC_CRYST_BIT : MAX310X_CLKSRC_EXTCLK_BIT;
+	clksrc = MAX310X_CLKSRC_EXTCLK_BIT | (xtal ? MAX310X_CLKSRC_CRYST_BIT : 0);
 
 	/* Configure PLL */
 	if (pllcfg) {


