Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4961AC833
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436887AbgDPPFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733176AbgDPNwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:52:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD0A120786;
        Thu, 16 Apr 2020 13:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045166;
        bh=aj+C3qty4HdDe8GL8geUEloqbIzbEgqKD6KeLaYq//Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GrT6xJXwSQ6ChYtzsQjg77lD40+nKgQj+stcM9tjmWLoWzOSBygTYRy3N8DCqyqPq
         lbdTA1Nb6k1EMSKXbezcewfechSzqZqE2yBjRRFbE+MtilCTEcVmEoXXn1H4yg7VXq
         YY+tzjm/poXOU/IFjib5BFmRyjTjNxriCs6LEAT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 024/254] xhci: bail out early if driver cant accress host in resume
Date:   Thu, 16 Apr 2020 15:21:53 +0200
Message-Id: <20200416131328.855576270@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index dbac0fa9748d5..fe38275363e0f 100644
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



