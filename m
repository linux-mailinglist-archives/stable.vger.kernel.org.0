Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB031A40AA
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgDJDtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728525AbgDJDtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:49:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72952214DB;
        Fri, 10 Apr 2020 03:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490563;
        bh=6udrQF6+eqNb7J8MjuaEbwbF3uzk3PjNir0m9HPYV3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRuaCZN9H4vBiD1T4Nnu20LBwUQrioVcqvZKqsgkiui+x9qADToIg3Fo8KSIAPqoN
         hHqhF2xUhDFmvOLE1AkHfahXI9D3vhyTN1jc0M5OAsIlY02fyqVKW1S60GBiS4dWJy
         tbvgt/NWDDWRP09/Xgw6zuM6cMDTI8drf4JTMeMo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/46] xhci: bail out early if driver can't accress host in resume
Date:   Thu,  9 Apr 2020 23:48:33 -0400
Message-Id: <20200410034909.8922-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034909.8922-1-sashal@kernel.org>
References: <20200410034909.8922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 72ae194704da212e2ec312ab182a96799d070755 ]

Bail out early if the xHC host needs to be reset at resume
but driver can't access xHC PCI registers.

If xhci driver already fails to reset the controller then there
is no point in attempting to free, re-initialize, re-allocate and
re-start the host. If failure to access the host is detected later,
failing the resume, xhci interrupts will be double freed
when remove is called.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200312144517.1593-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 9b3b1b16eafba..2f49a7b3ce854 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1157,8 +1157,10 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		xhci_dbg(xhci, "Stop HCD\n");
 		xhci_halt(xhci);
 		xhci_zero_64b_regs(xhci);
-		xhci_reset(xhci);
+		retval = xhci_reset(xhci);
 		spin_unlock_irq(&xhci->lock);
+		if (retval)
+			return retval;
 		xhci_cleanup_msix(xhci);
 
 		xhci_dbg(xhci, "// Disabling event ring interrupts\n");
-- 
2.20.1

