Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FB3272EBE
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbgIUQua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730000AbgIUQuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:50:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E674239D0;
        Mon, 21 Sep 2020 16:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600707019;
        bh=xZPIUDxZ6XjiG2PBxafL20G65Jt35WLLPvkj6a2Hvb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TA0Tp9qIiWE/mBXC0ggwCiwU5FOceqzoTvVNwhQmmA5vcfbgAIzKdfzMP7wUO9w56
         EPXcGMQvsm4Sy5SBRPYKza1MCyL3dl/qHYCdKAOL3/u+VZuwNdedgtWpm717QFeJ7v
         nM4X+TgSXz8lPCnB8q/XTQRbnJTLHBTVaDNgkHFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH 5.4 66/72] ehci-hcd: Move include to keep CRC stable
Date:   Mon, 21 Sep 2020 18:31:45 +0200
Message-Id: <20200921163125.007588338@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
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
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
+#include <linux/usb/otg.h>
 #include <linux/moduleparam.h>
 #include <linux/dma-mapping.h>
 #include <linux/debugfs.h>
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -14,7 +14,6 @@
  */
 
 /*-------------------------------------------------------------------------*/
-#include <linux/usb/otg.h>
 
 #define	PORT_WAKE_BITS	(PORT_WKOC_E|PORT_WKDISC_E|PORT_WKCONN_E)
 


