Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C048D370CB5
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhEBOHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233481AbhEBOG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BA52613CB;
        Sun,  2 May 2021 14:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964335;
        bh=zcgzLcvVUF2ef57oEf+17SAr0kcHmDUaBBDqc8jjWaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1sDV1nwNlsJ6vf0EXmT03bPm8N2S3hQ9jn9StkS1WemqHHR7X9++YK/hX4RTmEmX
         xcMewZOfG4pH6AFrkjd2wRvyHk19NWsVCQvEg4FQBCERq/DMIqfOoSe5UBvDWGCkzt
         SvXPKV6jtbnmHMbiUA17DAOrmevvzye6afM4VBTAju0YUXmwwppqIWltYgKtnmUVqP
         9cJPnA2NmKONAJ4tVTNgOiSIcZuCmdhjTdVo9dn3ZQWVRqXtDzSTqdPhWDSajzfcWk
         vDlPCjGfK+csB+bZZ7GEHZCfFeNUh2c+IS7c+82ID4wK4abfoJEc0TFo+xqOVwJRQs
         zWT6Rr4vKQxWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/21] xhci: fix potential array out of bounds with several interrupters
Date:   Sun,  2 May 2021 10:05:10 -0400
Message-Id: <20210502140517.2719912-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140517.2719912-1-sashal@kernel.org>
References: <20210502140517.2719912-1-sashal@kernel.org>
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
index fc07d68fdd15..9ca59f3fffde 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -227,6 +227,7 @@ static void xhci_zero_64b_regs(struct xhci_hcd *xhci)
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 	int err, i;
 	u64 val;
+	u32 intrs;
 
 	/*
 	 * Some Renesas controllers get into a weird state if they are
@@ -265,7 +266,10 @@ static void xhci_zero_64b_regs(struct xhci_hcd *xhci)
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

