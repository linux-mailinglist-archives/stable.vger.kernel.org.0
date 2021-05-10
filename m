Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1E8378779
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237615AbhEJLPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236469AbhEJLIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF7626108B;
        Mon, 10 May 2021 11:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644496;
        bh=u/f9DkjL/oNtRO4id81hfeXRlZ0BL9+7twPUWrQLOsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFQQGxx8Ij+9yjlStCCCUwLH/11gicHKUdbUaO12lIDEc8N78liv2Vz/iaVFnuViz
         jGwR/k/+BhfFvR/hAtotNJG2NE1eGxzj7h1ldokqadLjyIMYXEdvnvw7hY5sG0RK+C
         QtHqhSCiJK7YcoX4nlklvRnAoQVVoBBFlC8x5GLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 105/384] xhci: fix potential array out of bounds with several interrupters
Date:   Mon, 10 May 2021 12:18:14 +0200
Message-Id: <20210510102018.341294790@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 286fd02fd54b6acab65809549cf5fb3f2a886696 ]

The Max Interrupters supported by the controller is given in a 10bit
wide bitfield, but the driver uses a fixed 128 size array to index these
interrupters.

Klockwork reports a possible array out of bounds case which in theory
is possible. In practice this hasn't been hit as a common number of Max
Interrupters for new controllers is 8, not even close to 128.

This needs to be fixed anyway

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210406070208.3406266-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 5df780d55df0..6672c2f40303 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -228,6 +228,7 @@ static void xhci_zero_64b_regs(struct xhci_hcd *xhci)
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 	int err, i;
 	u64 val;
+	u32 intrs;
 
 	/*
 	 * Some Renesas controllers get into a weird state if they are
@@ -266,7 +267,10 @@ static void xhci_zero_64b_regs(struct xhci_hcd *xhci)
 	if (upper_32_bits(val))
 		xhci_write_64(xhci, 0, &xhci->op_regs->cmd_ring);
 
-	for (i = 0; i < HCS_MAX_INTRS(xhci->hcs_params1); i++) {
+	intrs = min_t(u32, HCS_MAX_INTRS(xhci->hcs_params1),
+		      ARRAY_SIZE(xhci->run_regs->ir_set));
+
+	for (i = 0; i < intrs; i++) {
 		struct xhci_intr_reg __iomem *ir;
 
 		ir = &xhci->run_regs->ir_set[i];
-- 
2.30.2



