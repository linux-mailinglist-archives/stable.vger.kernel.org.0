Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D88370C70
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbhEBOGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233090AbhEBOFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C34F7613CD;
        Sun,  2 May 2021 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964299;
        bh=1XPmX+ryxpQMokR0F3wtuA10t/1H/U+b/wBjD+5IiCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ09o4ZMTLE8RJLxXwbtVOqzwYFojZbauLKuqOKVYBqzqjKzc661YFHat37jR6Qrl
         eXNnxFI/7V8bAuGDyuqV52KNx4lBj86EhhZxMq5nsiY5zPA4NdUy4ZiJGl3fokEQdN
         Ix1qrd6bedSnD8KitIOql1Y03L6mcUQf7OOpx52k8WiD/BYkLbi1YZfGx3iIFNRL9F
         XEDBBE9Txa2zrgeR9aaWNYG1N025SJ3Lg+1VOesrM6e7OgLkC06sn4CvQQr8yfMm6s
         C1nt+UXgwGopQyNfST6jm/HQnjkcXY6tp5UP5Pu6ZM6quDAKRHHN53/ytVTUfNUCdE
         RIISX2otI12Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/34] xhci: fix potential array out of bounds with several interrupters
Date:   Sun,  2 May 2021 10:04:20 -0400
Message-Id: <20210502140434.2719553-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 143e4002e561..de05ac9d3ae1 100644
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

