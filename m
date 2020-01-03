Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F3C12F6DD
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 11:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbgACKsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 05:48:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbgACKsz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 05:48:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CB4721835;
        Fri,  3 Jan 2020 10:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578048534;
        bh=8D+S+5EE0z72/uJ9sG0tM6f1G4C55FArbuYksVsmfUg=;
        h=Subject:To:From:Date:From;
        b=zED0/JyK3wauyPBEO3+vDqSPGlDDlgR0nMAkaI43eUXWwwGXJ4SexKoIocidyajCJ
         3d7msXOf9KwTutGZUU+EBTRALK4V+XcVEXfCte/s6LEg4OqtMJ0VyxybZ+gVEfEgis
         iUlE2ow3BS24hj7fV2+K0adlg+0nue4vG/ORZNUw=
Subject: patch "staging: comedi: adv_pci1710: fix AI channels 16-31 for PCI-1713" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org, monkdaf@gmail.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jan 2020 11:48:38 +0100
Message-ID: <15780485188596@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: adv_pci1710: fix AI channels 16-31 for PCI-1713

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a9d3a9cedc1330c720e0ddde1978a8e7771da5ab Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Fri, 27 Dec 2019 17:00:54 +0000
Subject: staging: comedi: adv_pci1710: fix AI channels 16-31 for PCI-1713

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


