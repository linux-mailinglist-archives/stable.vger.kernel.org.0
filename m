Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858963831E3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbhEQOlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241106AbhEQOjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:39:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 788186193F;
        Mon, 17 May 2021 14:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261119;
        bh=M8RgQpG2b4ai5zpHDappdZ5NZAFlHdCK45JXNfJIUtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpWpsQYFnqS3FqYqFFYoMND0dNqQZhnaf+rrbex/QOnCMx1wug3W8bCH7IdWIb4lB
         yPtG1TWTUtEWWl13E7wczfpa6++/0lZ2LUKfwvbopEh1EAXEzgyItWATS84njrVJcX
         iK/y8A0462T1pCA3bhdOExZNEACruu3acSzGRWCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.12 310/363] usb: xhci: Increase timeout for HC halt
Date:   Mon, 17 May 2021 16:02:56 +0200
Message-Id: <20210517140313.077768224@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
 


