Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DE538A506
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbhETKMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236003AbhETKKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:10:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 979176195B;
        Thu, 20 May 2021 09:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503776;
        bh=M8RgQpG2b4ai5zpHDappdZ5NZAFlHdCK45JXNfJIUtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yrr621tK8cxcoSlRgLhrU6piGP5HgBKw+a0OEkoWrJcq6O/h4FoaWaf8nwSoSU0Sz
         3eenl+9TwZNbnJSuKkUXG8iiLU78aLj4Pd2qg6k1VD/rv1m85Sr3cfp/S8As1FYrLW
         SjkljcYMz/G58atjEbZmglRDoOli0/jabiFHf+3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 375/425] usb: xhci: Increase timeout for HC halt
Date:   Thu, 20 May 2021 11:22:24 +0200
Message-Id: <20210520092143.719482494@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

commit ca09b1bea63ab83f4cca3a2ae8bc4f597ec28851 upstream.

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
 drivers/usb/host/xhci-ext-caps.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
 


