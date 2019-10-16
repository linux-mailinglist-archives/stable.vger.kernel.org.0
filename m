Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965AADA0ED
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfJPWR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390357AbfJPVyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:54:50 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97BEE21D7F;
        Wed, 16 Oct 2019 21:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262889;
        bh=GPJ7645YJnOFEkI99cyW6COELt9QMB3Y1uScwAJPgh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3RMYVACl3hgyPHk1ahsiyqzKL7VnRFb5rZ7t3mvm1DqEhhU+cWrJXwFMCREkw+aR
         KoxsbH2EKEE6Nfsw3410ozNGtwJh5+IAOEiAxKJAx4ebvNFUaUBhvMO8n0VfH5CiS7
         K7In1tBd+k91e5MZhXPFpyaxXoKynZTvtps3oP4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.9 46/92] xhci: Increase STS_SAVE timeout in xhci_suspend()
Date:   Wed, 16 Oct 2019 14:50:19 -0700
Message-Id: <20191016214834.250667060@linuxfoundation.org>
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
@@ -985,7 +985,7 @@ int xhci_suspend(struct xhci_hcd *xhci,
 	command |= CMD_CSS;
 	writel(command, &xhci->op_regs->command);
 	if (xhci_handshake(&xhci->op_regs->status,
-				STS_SAVE, 0, 10 * 1000)) {
+				STS_SAVE, 0, 20 * 1000)) {
 		xhci_warn(xhci, "WARN: xHC save state timeout\n");
 		spin_unlock_irq(&xhci->lock);
 		return -ETIMEDOUT;


