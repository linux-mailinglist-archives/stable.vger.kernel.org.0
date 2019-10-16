Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85F2DDA06A
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406635AbfJPWLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437924AbfJPV4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:50 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8562F21925;
        Wed, 16 Oct 2019 21:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263009;
        bh=BakXtVNyWxfe6/6cNUyEpr7kiZiRERaM4EkEd9adm7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrjHYQ31+PRoLRWDOnF6Q+H4bNorriRjz7/fC5CRprVOVFSgtq67WsMjY2QHF3jvw
         UqOeO5Vh6OLROtNs9zpzbJI3PZTPRFAharsv/oRiSVIHLwJJqqr5LzmxG+Jys6ft0r
         PMGtq3l0gteBLNXLOdvMbMtKeXMONOcsTfEwtUSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rick Tseng <rtseng@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 12/81] usb: xhci: wait for CNR controller not ready bit in xhci resume
Date:   Wed, 16 Oct 2019 14:50:23 -0700
Message-Id: <20191016214817.920493885@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rick Tseng <rtseng@nvidia.com>

commit a70bcbc322837eda1ab5994d12db941dc9733a7d upstream.

NVIDIA 3.1 xHCI card would lose power when moving power state into D3Cold.
Thus we need to wait for CNR bit to clear in xhci resume, just as in
xhci init.

[Minor changes to comment and commit message -Mathias]
Cc: <stable@vger.kernel.org>
Signed-off-by: Rick Tseng <rtseng@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-6-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1098,6 +1098,18 @@ int xhci_resume(struct xhci_hcd *xhci, b
 		hibernated = true;
 
 	if (!hibernated) {
+		/*
+		 * Some controllers might lose power during suspend, so wait
+		 * for controller not ready bit to clear, just as in xHC init.
+		 */
+		retval = xhci_handshake(&xhci->op_regs->status,
+					STS_CNR, 0, 10 * 1000 * 1000);
+		if (retval) {
+			xhci_warn(xhci, "Controller not ready at resume %d\n",
+				  retval);
+			spin_unlock_irq(&xhci->lock);
+			return retval;
+		}
 		/* step 1: restore register */
 		xhci_restore_registers(xhci);
 		/* step 2: initialize command ring buffer */


