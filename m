Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0F4353E58
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbhDEJFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238607AbhDEJFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:05:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02E6461394;
        Mon,  5 Apr 2021 09:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613505;
        bh=64C5RxaWOEinmTC9Asg0iOMKinahkb8mpKwH+fm79d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qk+HvMXjN5KQ/jKuac9b9zc9gFn95gzPs7hMsuspHODeA41X1glFYMpkowlByZoTL
         4k7q+U53TdaIyEEMNi6zJWFAwmVtFVb4L1a5jh+2vOh435TQyr6DRZ1oo3d0GXk8u9
         7oYi8r7y1DXOe20WMFlar77mOVZBmcNTYGktg9jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.4 63/74] usb: xhci-mtk: fix broken streams issue on 0.96 xHCI
Date:   Mon,  5 Apr 2021 10:54:27 +0200
Message-Id: <20210405085026.783053918@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 6f978a30c9bb12dab1302d0f06951ee290f5e600 upstream.

The MediaTek 0.96 xHCI controller on some platforms does not
support bulk stream even HCCPARAMS says supporting, due to MaxPSASize
is set a default value 1 by mistake, here use XHCI_BROKEN_STREAMS
quirk to fix it.

Fixes: 94a631d91ad3 ("usb: xhci-mtk: check hcc_params after adding primary hcd")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1616482975-17841-4-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -397,6 +397,13 @@ static void xhci_mtk_quirks(struct devic
 	xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 	if (mtk->lpm_support)
 		xhci->quirks |= XHCI_LPM_SUPPORT;
+
+	/*
+	 * MTK xHCI 0.96: PSA is 1 by default even if doesn't support stream,
+	 * and it's 3 when support it.
+	 */
+	if (xhci->hci_version < 0x100 && HCC_MAX_PSA(xhci->hcc_params) == 4)
+		xhci->quirks |= XHCI_BROKEN_STREAMS;
 }
 
 /* called during probe() after chip reset completes */
@@ -553,7 +560,8 @@ static int xhci_mtk_probe(struct platfor
 	if (ret)
 		goto put_usb3_hcd;
 
-	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
+	if (HCC_MAX_PSA(xhci->hcc_params) >= 4 &&
+	    !(xhci->quirks & XHCI_BROKEN_STREAMS))
 		xhci->shared_hcd->can_do_streams = 1;
 
 	ret = usb_add_hcd(xhci->shared_hcd, irq, IRQF_SHARED);


