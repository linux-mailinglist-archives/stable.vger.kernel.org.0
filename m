Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2669826D3CC
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 08:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgIQGjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 02:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgIQGjc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 02:39:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 098262083B;
        Thu, 17 Sep 2020 06:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600324771;
        bh=kHwXd5uuK+7fTz/2QLlQ10KTozgEZJop0bTxpAp59oc=;
        h=Subject:To:From:Date:From;
        b=OUym2rOrFa7S7phO6OzoKL7Q3vLDNdB+McFlET8JLNzjjBN5axLTdxeiMxih4CK1l
         LweBmXUoeZDBzakH2qReF4HqD1yMGGLR/5popu5vLeGdXXFZEpvIChMZXG9xaNroHK
         vFUlrCU3uiv9eKf0CA5eNso8RAk5AkvjMnM3gF/I=
Subject: patch "ehci-hcd: Move include to keep CRC stable" added to usb-linus
To:     qperret@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Sep 2020 08:40:04 +0200
Message-ID: <16003248047879@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    ehci-hcd: Move include to keep CRC stable

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 29231826f3bd65500118c473fccf31c0cf14dbc0 Mon Sep 17 00:00:00 2001
From: Quentin Perret <qperret@google.com>
Date: Wed, 16 Sep 2020 18:18:25 +0100
Subject: ehci-hcd: Move include to keep CRC stable

The CRC calculation done by genksyms is triggered when the parser hits
EXPORT_SYMBOL*() macros. At this point, genksyms recursively expands the
types of the function parameters, and uses that as the input for the CRC
calculation. In the case of forward-declared structs, the type expands
to 'UNKNOWN'. Following this, it appears that the result of the
expansion of each type is cached somewhere, and seems to be re-used
when/if the same type is seen again for another exported symbol in the
same C file.

Unfortunately, this can cause CRC 'stability' issues when a struct
definition becomes visible in the middle of a C file. For example, let's
assume code with the following pattern:

    struct foo;

    int bar(struct foo *arg)
    {
	/* Do work ... */
    }
    EXPORT_SYMBOL_GPL(bar);

    /* This contains struct foo's definition */
    #include "foo.h"

    int baz(struct foo *arg)
    {
	/* Do more work ... */
    }
    EXPORT_SYMBOL_GPL(baz);

Here, baz's CRC will be computed using the expansion of struct foo that
was cached after bar's CRC calculation ('UNKOWN' here). But if
EXPORT_SYMBOL_GPL(bar) is removed from the file (because of e.g. symbol
trimming using CONFIG_TRIM_UNUSED_KSYMS), struct foo will be expanded
late, during baz's CRC calculation, which now has visibility over the
full struct definition, hence resulting in a different CRC for baz.

The proper fix for this certainly is in genksyms, but that will take me
some time to get right. In the meantime, we have seen one occurrence of
this in the ehci-hcd code which hits this problem because of the way it
includes C files halfway through the code together with an unlucky mix
of symbol trimming.

In order to workaround this, move the include done in ehci-hub.c early
in ehci-hcd.c, hence making sure the struct definitions are visible to
the entire file. This improves CRC stability of the ehci-hcd exports
even when symbol trimming is enabled.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
Link: https://lore.kernel.org/r/20200916171825.3228122-1-qperret@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-hcd.c | 1 +
 drivers/usb/host/ehci-hub.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 6257be4110ca..3575b7201881 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
+#include <linux/usb/otg.h>
 #include <linux/moduleparam.h>
 #include <linux/dma-mapping.h>
 #include <linux/debugfs.h>
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index ce0eaf7d7c12..087402aec5cb 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -14,7 +14,6 @@
  */
 
 /*-------------------------------------------------------------------------*/
-#include <linux/usb/otg.h>
 
 #define	PORT_WAKE_BITS	(PORT_WKOC_E|PORT_WKDISC_E|PORT_WKCONN_E)
 
-- 
2.28.0


