Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE56439FF4
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhJYTZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234790AbhJYTYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:24:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5DE1610A5;
        Mon, 25 Oct 2021 19:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189701;
        bh=cmk0RP38NN1vE0MQXQVLilmNUQCYQAVw/M+Ouy94bZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K91BLmpD5zBL1vLOsFh1UIKduxSQLT9jIhycW4lLOk5NmtBXQBXRJJgWeGxcJ1e31
         dgNSgcFGt/l6I7nPLQZSRR3PDH4fNSiBs6kWAyOr84zaYhwjT9ReJ2pmCOjz2cepQx
         Tj/THCEjLMlcbub1n/XrvyvOt6XrpTY1iVsyGPnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.14 10/30] can: peak_pci: peak_pci_remove(): fix UAF
Date:   Mon, 25 Oct 2021 21:14:30 +0200
Message-Id: <20211025190925.473771236@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190922.089277904@linuxfoundation.org>
References: <20211025190922.089277904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

commit 949fe9b35570361bc6ee2652f89a0561b26eec98 upstream.

When remove the module peek_pci, referencing 'chan' again after
releasing 'dev' will cause UAF.

Fix this by releasing 'dev' later.

The following log reveals it:

[   35.961814 ] BUG: KASAN: use-after-free in peak_pci_remove+0x16f/0x270 [peak_pci]
[   35.963414 ] Read of size 8 at addr ffff888136998ee8 by task modprobe/5537
[   35.965513 ] Call Trace:
[   35.965718 ]  dump_stack_lvl+0xa8/0xd1
[   35.966028 ]  print_address_description+0x87/0x3b0
[   35.966420 ]  kasan_report+0x172/0x1c0
[   35.966725 ]  ? peak_pci_remove+0x16f/0x270 [peak_pci]
[   35.967137 ]  ? trace_irq_enable_rcuidle+0x10/0x170
[   35.967529 ]  ? peak_pci_remove+0x16f/0x270 [peak_pci]
[   35.967945 ]  __asan_report_load8_noabort+0x14/0x20
[   35.968346 ]  peak_pci_remove+0x16f/0x270 [peak_pci]
[   35.968752 ]  pci_device_remove+0xa9/0x250

Fixes: e6d9c80b7ca1 ("can: peak_pci: add support of some new PEAK-System PCI cards")
Link: https://lore.kernel.org/all/1634192913-15639-1-git-send-email-zheyuma97@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/sja1000/peak_pci.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/net/can/sja1000/peak_pci.c
+++ b/drivers/net/can/sja1000/peak_pci.c
@@ -739,16 +739,15 @@ static void peak_pci_remove(struct pci_d
 		struct net_device *prev_dev = chan->prev_dev;
 
 		dev_info(&pdev->dev, "removing device %s\n", dev->name);
+		/* do that only for first channel */
+		if (!prev_dev && chan->pciec_card)
+			peak_pciec_remove(chan->pciec_card);
 		unregister_sja1000dev(dev);
 		free_sja1000dev(dev);
 		dev = prev_dev;
 
-		if (!dev) {
-			/* do that only for first channel */
-			if (chan->pciec_card)
-				peak_pciec_remove(chan->pciec_card);
+		if (!dev)
 			break;
-		}
 		priv = netdev_priv(dev);
 		chan = priv->priv;
 	}


