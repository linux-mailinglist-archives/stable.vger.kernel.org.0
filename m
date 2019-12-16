Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52DA121743
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbfLPSH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730200AbfLPSH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:07:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59A9F20700;
        Mon, 16 Dec 2019 18:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519676;
        bh=WNWl2KwpTQ9stnB82DioW1lk2opBZTbTniKS4yHFbJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETKS9jlMkSsOi2LhqHKXJvm2DaSaBylqrYfxwj5P81xK2h9uLP11W6jPpNFW1mdrC
         a/Gqnd/tWfWGA1hnfm0poHiH6NkRU36KagKVUFVWksP76/mA+0C1cZQt7pKkYeQb6R
         vYMIFufyVcHEtPQGTwWdFs0cUYWoy7rSK3voSg/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.3 023/180] xhci: Increase STS_HALT timeout in xhci_suspend()
Date:   Mon, 16 Dec 2019 18:47:43 +0100
Message-Id: <20191216174811.168354603@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 7c67cf6658cec70d8a43229f2ce74ca1443dc95e upstream.

I've recently observed failed xHCI suspend attempt on AMD Raven Ridge
system:
kernel: xhci_hcd 0000:04:00.4: WARN: xHC CMD_RUN timeout
kernel: PM: suspend_common(): xhci_pci_suspend+0x0/0xd0 returns -110
kernel: PM: pci_pm_suspend(): hcd_pci_suspend+0x0/0x30 returns -110
kernel: PM: dpm_run_callback(): pci_pm_suspend+0x0/0x150 returns -110
kernel: PM: Device 0000:04:00.4 failed to suspend async: error -110

Similar to commit ac343366846a ("xhci: Increase STS_SAVE timeout in
xhci_suspend()") we also need to increase the HALT timeout to make it be
able to suspend again.

Cc: <stable@vger.kernel.org> # 5.2+
Fixes: f7fac17ca925 ("xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20191211142007.8847-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -970,7 +970,7 @@ static bool xhci_pending_portevent(struc
 int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
 {
 	int			rc = 0;
-	unsigned int		delay = XHCI_MAX_HALT_USEC;
+	unsigned int		delay = XHCI_MAX_HALT_USEC * 2;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	u32			command;
 	u32			res;


