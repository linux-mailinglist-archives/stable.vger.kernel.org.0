Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B09512B609
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfL0RGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:06:48 -0500
Received: from smtp104.ord1d.emailsrvr.com ([184.106.54.104]:36308 "EHLO
        smtp104.ord1d.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726920AbfL0RGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Dec 2019 12:06:48 -0500
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Dec 2019 12:06:47 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=g001.emailsrvr.com;
        s=20190322-9u7zjiwi; t=1577466075;
        bh=8ASEO9nb1s4EYQzxV1kAkTa3727cqCnOOe7ocLSymVg=;
        h=From:To:Subject:Date:From;
        b=Bf56xgAvmL+QWeNgo80a0UXrlRzHeyeHDNmXeUc44xtLpAIBESlCTFLgob9yR8x6F
         hvaOP2uYWw8eIz7QozWPrz2WDZdtVlbXmnX/o5tJ/7x7vyuqD7SpsY/CtjN/illg6P
         BPvLtqigFx+uzQtgoKvAmKc7cbQYd6L2FRTq8Qvg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1577466075;
        bh=8ASEO9nb1s4EYQzxV1kAkTa3727cqCnOOe7ocLSymVg=;
        h=From:To:Subject:Date:From;
        b=EE4Dtcpfgy7khxaSo8J06m4OOlR5f7Dfq3OD/ptrNjgndvs687adT/fwEfE1V4lGt
         MWDlBnnclaZUtJIsFkk9wz/Rua3HJyZY4czq3/9iwkOz7djtErb2zE3qGpWcbXLwbQ
         nHUnnfMUE1mzKvWBARAX5pBL3jxIXNiR8MMvy8aE=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp6.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id EB661E0408;
        Fri, 27 Dec 2019 12:01:13 -0500 (EST)
X-Sender-Id: abbotti@mev.co.uk
Received: from konata.homenet (redmecca.plus.com [80.229.15.156])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256)
        by 0.0.0.0:465 (trex/5.7.12);
        Fri, 27 Dec 2019 12:01:14 -0500
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org,
        Dmytro Fil <monkdaf@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] staging: comedi: adv_pci1710: fix AI channels 16-31 for PCI-1713
Date:   Fri, 27 Dec 2019 17:00:54 +0000
Message-Id: <20191227170054.32051-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index dbff0f7e7cf5..ddc0dc93d08b 100644
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
-- 
2.24.1

