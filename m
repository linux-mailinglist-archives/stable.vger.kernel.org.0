Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B95238AB88
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbhETLZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240300AbhETLW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:22:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4CEE61CF8;
        Thu, 20 May 2021 10:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505507;
        bh=GgrLl6uBq4OvXt0I0ec1fvwloYaMRa2/9eAwroYI6aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+0BmuWSlEsayLcyy4gL1HwknvSVS9PQGsLpnPhIpxnt9xb4fH/q7RyzcuK1c2goS
         d2fpRPU44VldIAUG1UpbiJMtnCTaxRRQhmrdBmsEw4mIraB8/RYzRsN9HAssd/5x3g
         VrBzPkUcaDVGoAWHbDGGtgTmN8uxU6A14YH3qwoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.4 166/190] usb: xhci: Increase timeout for HC halt
Date:   Thu, 20 May 2021 11:23:50 +0200
Message-Id: <20210520092107.663247523@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
@@ -19,8 +19,9 @@
  * along with this program; if not, write to the Free Software Foundation,
  * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-/* Up to 16 ms to halt an HC */
-#define XHCI_MAX_HALT_USEC	(16*1000)
+
+/* HC should halt within 16 ms, but use 32 ms as some hosts take longer */
+#define XHCI_MAX_HALT_USEC	(32 * 1000)
 /* HC not running - set to 1 when run/stop bit is cleared. */
 #define XHCI_STS_HALT		(1<<0)
 


