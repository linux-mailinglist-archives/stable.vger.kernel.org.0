Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124D320DB54
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388532AbgF2UFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732963AbgF2Ta2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B56A8252F6;
        Mon, 29 Jun 2020 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445124;
        bh=TCCkuqH489hXhYC0XfzyB8vf2AK77+HJyNN5X/SHct8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CjgLl7e2pdApg2ICLwxRQ2v8BMkm2Igb+rtFPip+2y3dSm+RyaN5I4oYAJRKj/ad
         cRcWXURyCz4FdLd+CgdjYx4pIJPrklPldMzuY1iDhpjQ1iqI7Bw9L+kbBrUbGNRPRl
         Jcx6UW+im/pRuJB559E7cK4bCTvsvtbzGMUtVh0Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Cooper <alcooperx@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 31/78] xhci: Fix enumeration issue when setting max packet size for FS devices.
Date:   Mon, 29 Jun 2020 11:37:19 -0400
Message-Id: <20200629153806.2494953-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Cooper <alcooperx@gmail.com>

commit a73d9d9cfc3cfceabd91fb0b0c13e4062b6dbcd7 upstream.

Unable to complete the enumeration of a USB TV Tuner device.

Per XHCI spec (4.6.5), the EP state field of the input context shall
be cleared for a set address command. In the special case of an FS
device that has "MaxPacketSize0 = 8", the Linux XHCI driver does
not do this before evaluating the context. With an XHCI controller
that checks the EP state field for parameter context error this
causes a problem in cases such as the device getting reset again
after enumeration.

When that field is cleared, the problem does not occur.

This was found and fixed by Sasi Kumar.

Cc: stable@vger.kernel.org
Signed-off-by: Al Cooper <alcooperx@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200624135949.22611-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6c0a0ca316d3e..d727cbbad44a2 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1346,6 +1346,7 @@ static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
 				xhci->devs[slot_id]->out_ctx, ep_index);
 
 		ep_ctx = xhci_get_ep_ctx(xhci, command->in_ctx, ep_index);
+		ep_ctx->ep_info &= cpu_to_le32(~EP_STATE_MASK);/* must clear */
 		ep_ctx->ep_info2 &= cpu_to_le32(~MAX_PACKET_MASK);
 		ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet_size));
 
-- 
2.25.1

