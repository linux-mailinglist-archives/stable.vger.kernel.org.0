Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153E437F825
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 14:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhEMMtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 08:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233217AbhEMMtQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 08:49:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E5E761396;
        Thu, 13 May 2021 12:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620910086;
        bh=fdGZbK/15H/3IkmUufI7TYgPE4080pou8Qs922dGokE=;
        h=Subject:To:From:Date:From;
        b=pWc+a+P1lbaFaDXRxFD8M/f3Oy+EdMvnqYzHLZ4YIhgtjJTVONl8Szydx+hQSyAgs
         El6NgF0lPJ0XjcEjjPBndAgWr3A1wBRdtSqpej3LnS2O7CmG85UKlT7Gm6ujUVGE2I
         7VvChMoC7LXoF/YgArhNQ9joZpZSwCLsyjzeFB3k=
Subject: patch "usb: xhci: Increase timeout for HC halt" added to usb-linus
To:     luzmaximilian@gmail.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 14:47:55 +0200
Message-ID: <1620910075197231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: Increase timeout for HC halt

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ca09b1bea63ab83f4cca3a2ae8bc4f597ec28851 Mon Sep 17 00:00:00 2001
From: Maximilian Luz <luzmaximilian@gmail.com>
Date: Wed, 12 May 2021 11:08:15 +0300
Subject: usb: xhci: Increase timeout for HC halt

On some devices (specifically the SC8180x based Surface Pro X with
QCOM04A6) HC halt / xhci_halt() times out during boot. Manually binding
the xhci-hcd driver at some point later does not exhibit this behavior.
To work around this, double XHCI_MAX_HALT_USEC, which also resolves this
issue.

Cc: <stable@vger.kernel.org>
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210512080816.866037-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ext-caps.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ext-caps.h b/drivers/usb/host/xhci-ext-caps.h
index fa59b242cd51..e8af0a125f84 100644
--- a/drivers/usb/host/xhci-ext-caps.h
+++ b/drivers/usb/host/xhci-ext-caps.h
@@ -7,8 +7,9 @@
  * Author: Sarah Sharp
  * Some code borrowed from the Linux EHCI driver.
  */
-/* Up to 16 ms to halt an HC */
-#define XHCI_MAX_HALT_USEC	(16*1000)
+
+/* HC should halt within 16 ms, but use 32 ms as some hosts take longer */
+#define XHCI_MAX_HALT_USEC	(32 * 1000)
 /* HC not running - set to 1 when run/stop bit is cleared. */
 #define XHCI_STS_HALT		(1<<0)
 
-- 
2.31.1


