Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3DED9DEA
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395025AbfJPVyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395077AbfJPVyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:54:49 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C525621925;
        Wed, 16 Oct 2019 21:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262888;
        bh=P5NtuhAKJT/bg8hSfmlpvsSZBTc9coutHozqB4XXYcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3cc0LqbgLurJqsCZMJK54LR+aLnBXE10OhT/cr8V6X7ArLlto+eC5NUIDHdISVbw
         8EEVDl9L9BvVjruIp2sgyXnfqx1uRnbxpqDSJH4Y2neLEU7FvucxWPjBo45amyHEv+
         VPWz7TzxQc+mlQ/LXCXswhST90l4u0PF4rI8Uwog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rick Tseng <rtseng@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.9 45/92] usb: xhci: wait for CNR controller not ready bit in xhci resume
Date:   Wed, 16 Oct 2019 14:50:18 -0700
Message-Id: <20191016214833.875184728@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
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
@@ -1045,6 +1045,18 @@ int xhci_resume(struct xhci_hcd *xhci, b
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


