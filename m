Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA25272D0B
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgIUQg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36601 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbgIUQgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:36:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74E5D238E6;
        Mon, 21 Sep 2020 16:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706202;
        bh=t5qeN+stjGPNG6sn8aIddhIRBpgtz8iDOmvyk88XO1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWnBTqKBgGmdYSHMSuTDXbC19ND6+lszAxhWjaXh+TCq5g2dh+bCOEtqqZalm59NQ
         4iU2oQn+lMTtlBcNLjhBBKhUtPdRRIZCNf8yE99YpAUlppx7jR5I/e5T3CBQyYH1sq
         hdwsZ5yZ2v7FBdvcskiSYio6Wuw1lxqXrH2uCIJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH 4.9 68/70] ehci-hcd: Move include to keep CRC stable
Date:   Mon, 21 Sep 2020 18:28:08 +0200
Message-Id: <20200921162038.248462929@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

commit 29231826f3bd65500118c473fccf31c0cf14dbc0 upstream.

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
 drivers/usb/host/ehci-hcd.c |    1 +
 drivers/usb/host/ehci-hub.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -35,6 +35,7 @@
 #include <linux/interrupt.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
+#include <linux/usb/otg.h>
 #include <linux/moduleparam.h>
 #include <linux/dma-mapping.h>
 #include <linux/debugfs.h>
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -27,7 +27,6 @@
  */
 
 /*-------------------------------------------------------------------------*/
-#include <linux/usb/otg.h>
 
 #define	PORT_WAKE_BITS	(PORT_WKOC_E|PORT_WKDISC_E|PORT_WKCONN_E)
 


