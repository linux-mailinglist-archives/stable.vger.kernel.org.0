Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3BD7121613
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731304AbfLPSQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:16:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:39168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731551AbfLPSQb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:16:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A546421739;
        Mon, 16 Dec 2019 18:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520191;
        bh=L0RDW2xVEkpL8/XEYi0LAlybTE199bltg4a5H+Iddk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQRkBzI0qMLEUXxqCkxxIdae/9K7sQkm/Ct0gBbaOgThcmfBEuYICGohH12c6F9nI
         GH6Tc3cZYQD3Qv9a1t7Hna3wCkuqS6J4zKBxUrqn1/aWmouIsp3R7TwDL6iApY3DBT
         H96829iyd6eZQJRORrg/m527j0/9TaHhE7/YW+0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 054/177] brcmfmac: disable PCIe interrupts before bus reset
Date:   Mon, 16 Dec 2019 18:48:30 +0100
Message-Id: <20191216174830.695630262@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

commit 5d26a6a6150c486f51ea2aaab33af04db02f63b8 upstream.

Keeping interrupts on could result in brcmfmac freeing some resources
and then IRQ handlers trying to use them. That was obviously a straight
path for crashing a kernel.

Example:
CPU0                           CPU1
----                           ----
brcmf_pcie_reset
  brcmf_pcie_bus_console_read
  brcmf_detach
    ...
    brcmf_fweh_detach
    brcmf_proto_detach
                               brcmf_pcie_isr_thread
                                 ...
                                 brcmf_proto_msgbuf_rx_trigger
                                   ...
                                   drvr->proto->pd
    brcmf_pcie_release_irq

[  363.789218] Unable to handle kernel NULL pointer dereference at virtual address 00000038
[  363.797339] pgd = c0004000
[  363.800050] [00000038] *pgd=00000000
[  363.803635] Internal error: Oops: 17 [#1] SMP ARM
(...)
[  364.029209] Backtrace:
[  364.031725] [<bf243838>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf2471dc>] (brcmf_pcie_isr_thread+0x228/0x274 [brcmfmac])
[  364.043662]  r7:00000001 r6:c8ca0000 r5:00010000 r4:c7b4f800

Fixes: 4684997d9eea ("brcmfmac: reset PCIe bus on a firmware crash")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1427,6 +1427,8 @@ static int brcmf_pcie_reset(struct devic
 	struct brcmf_fw_request *fwreq;
 	int err;
 
+	brcmf_pcie_intr_disable(devinfo);
+
 	brcmf_pcie_bus_console_read(devinfo, true);
 
 	brcmf_detach(dev);


