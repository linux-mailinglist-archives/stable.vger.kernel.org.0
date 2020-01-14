Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E31A13A606
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgANKIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:08:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730407AbgANKIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:08:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45DAD24690;
        Tue, 14 Jan 2020 10:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996480;
        bh=QOtqjUFCOKYM8zRv5UdVdn1GxVGQCrtHBIh9QLZ5b9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKG0XEmVhB8L53JuE2+usS/5R9wh9r9vKZqc4ZEIy7l3x//68DcSR44DFA0QTjnak
         9jZR9tDIGhti5tzTdIAtwPebT51sxPEzuVGiFXAWRc3C99v9niDBYastoIJxG5cAZD
         WC2b8p154F599YOw/rx/ZvLyZpRtW5rt6E8bfbx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Fil <monkdaf@gmail.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.19 30/46] staging: comedi: adv_pci1710: fix AI channels 16-31 for PCI-1713
Date:   Tue, 14 Jan 2020 11:01:47 +0100
Message-Id: <20200114094346.470710904@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094339.608068818@linuxfoundation.org>
References: <20200114094339.608068818@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit a9d3a9cedc1330c720e0ddde1978a8e7771da5ab upstream.

The Advantech PCI-1713 has 32 analog input channels, but an incorrect
bit-mask in the definition of the `PCI171X_MUX_CHANH(x)` and
PCI171X_MUX_CHANL(x)` macros is causing channels 16 to 31 to be aliases
of channels 0 to 15.  Change the bit-mask value from 0xf to 0xff to fix
it.  Note that the channel numbers will have been range checked already,
so the bit-mask isn't really needed.

Fixes: 92c65e5553ed ("staging: comedi: adv_pci1710: define the mux control register bits")
Reported-by: Dmytro Fil <monkdaf@gmail.com>
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20191227170054.32051-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/adv_pci1710.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -46,8 +46,8 @@
 #define PCI171X_RANGE_UNI	BIT(4)
 #define PCI171X_RANGE_GAIN(x)	(((x) & 0x7) << 0)
 #define PCI171X_MUX_REG		0x04	/* W:   A/D multiplexor control */
-#define PCI171X_MUX_CHANH(x)	(((x) & 0xf) << 8)
-#define PCI171X_MUX_CHANL(x)	(((x) & 0xf) << 0)
+#define PCI171X_MUX_CHANH(x)	(((x) & 0xff) << 8)
+#define PCI171X_MUX_CHANL(x)	(((x) & 0xff) << 0)
 #define PCI171X_MUX_CHAN(x)	(PCI171X_MUX_CHANH(x) | PCI171X_MUX_CHANL(x))
 #define PCI171X_STATUS_REG	0x06	/* R:   status register */
 #define PCI171X_STATUS_IRQ	BIT(11)	/* 1=IRQ occurred */


