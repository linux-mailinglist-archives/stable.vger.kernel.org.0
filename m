Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24C441E846
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 09:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352458AbhJAHY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 03:24:29 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:12797 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352467AbhJAHY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 03:24:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633072965; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=1g6OZj2mssVCbLPyz7pGjcK/+WwckIu5icECevQehk0=; b=jz70hS4ONYoNowQZDpUhmqRB+bBit9+tOlhvo29l0KD//SbrTs/WxnmXbJ3Gy9Orrn0pfUIK
 OWlUuYAVBZQQ3qHtdd42HGjUZTQvTTno1C1kKIxsyjyQQrhSbqzaDw81DT2I9zVxn0e7+OLJ
 GyA5W+rS4p9h8upU9s1UfIaYDk4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6156b739a3e8d3c640e7a4dd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Oct 2021 07:22:33
 GMT
Sender: pkondeti=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 43DE1C4360C; Fri,  1 Oct 2021 07:22:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from codeaurora.org (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pkondeti)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8987DC4338F;
        Fri,  1 Oct 2021 07:22:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 8987DC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Pavankumar Kondeti <pkondeti@codeaurora.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     Jack Pham <jackp@codeaurora.org>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org,
        Pavankumar Kondeti <pkondeti@codeaurora.org>
Subject: [PATCH] xhci: Fix command ring pointer corruption while aborting a command
Date:   Fri,  1 Oct 2021 12:52:26 +0530
Message-Id: <1633072946-16826-1-git-send-email-pkondeti@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The command ring pointer is located at [6:63] bits of the command
ring control register (CRCR). All the control bits like command stop,
abort are located at [0:3] bits. While aborting a command, we read the
CRCR and set the abort bit and write to the CRCR. The read will always
give command ring pointer as all zeros. So we essentially write only
the control bits. Since we split the 64 bit write into two 32 bit writes,
there is a possibility of xHC command ring stopped before the upper
dword (all zeros) is written. If that happens, xHC updates the upper
dword of its internal command ring pointer with all zeros. Next time,
when the command ring is restarted, we see xHC memory access failures.
Fix this issue by only writing to the lower dword of CRCR where all
control bits are located.

Signed-off-by: Pavankumar Kondeti <pkondeti@codeaurora.org>
---
 drivers/usb/host/xhci-ring.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index e676749..3c8456b 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -366,16 +366,22 @@ static void xhci_handle_stopped_cmd_ring(struct xhci_hcd *xhci,
 /* Must be called with xhci->lock held, releases and aquires lock back */
 static int xhci_abort_cmd_ring(struct xhci_hcd *xhci, unsigned long flags)
 {
-	u64 temp_64;
+	u64 temp_32;
 	int ret;
 
 	xhci_dbg(xhci, "Abort command ring\n");
 
 	reinit_completion(&xhci->cmd_ring_stop_completion);
 
-	temp_64 = xhci_read_64(xhci, &xhci->op_regs->cmd_ring);
-	xhci_write_64(xhci, temp_64 | CMD_RING_ABORT,
-			&xhci->op_regs->cmd_ring);
+	/*
+	 * The control bits like command stop, abort are located in lower
+	 * dword of the command ring control register. Limit the write
+	 * to the lower dword to avoid corrupting the command ring pointer
+	 * in case if the command ring is stopped by the time upper dword
+	 * is written.
+	 */
+	temp_32 = readl(&xhci->op_regs->cmd_ring);
+	writel(temp_32 | CMD_RING_ABORT, &xhci->op_regs->cmd_ring);
 
 	/* Section 4.6.1.2 of xHCI 1.0 spec says software should also time the
 	 * completion of the Command Abort operation. If CRR is not negated in 5
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

