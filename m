Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D8FDA0A9
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfJPWOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395309AbfJPVzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:42 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BC8521D7E;
        Wed, 16 Oct 2019 21:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262941;
        bh=azaKT2C62TPRSsYE+ckZPK4Di2dsoBRGaz19NRo69Rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnPZqFTObqfxpV+6zexcsLo6YB/HliQT7bWLIvc2fCznlqFVD3IM6pLVFajKmhH4k
         9U5rncGb8WDlG7ozOcv95FgEuyuXbQBA/V2W6iEdN/RfSLxrY593K8fFUcQknopWSP
         I6Czx5ced87S2xdsTbNgR6vZ+xnzp7X/7SxuSys8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.14 12/65] xhci: Increase STS_SAVE timeout in xhci_suspend()
Date:   Wed, 16 Oct 2019 14:50:26 -0700
Message-Id: <20191016214805.437728649@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit ac343366846a445bb81f0a0e8f16abb8bd5d5d88 upstream.

After commit f7fac17ca925 ("xhci: Convert xhci_handshake() to use
readl_poll_timeout_atomic()"), ASMedia xHCI may fail to suspend.

Although the algorithms are essentially the same, the old max timeout is
(usec + usec * time of doing readl()), and the new max timeout is just
usec, which is much less than the old one.

Increase the timeout to make ASMedia xHCI able to suspend again.

BugLink: https://bugs.launchpad.net/bugs/1844021
Fixes: f7fac17ca925 ("xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()")
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-8-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -968,7 +968,7 @@ int xhci_suspend(struct xhci_hcd *xhci,
 	writel(command, &xhci->op_regs->command);
 	xhci->broken_suspend = 0;
 	if (xhci_handshake(&xhci->op_regs->status,
-				STS_SAVE, 0, 10 * 1000)) {
+				STS_SAVE, 0, 20 * 1000)) {
 	/*
 	 * AMD SNPS xHC 3.0 occasionally does not clear the
 	 * SSS bit of USBSTS and when driver tries to poll


