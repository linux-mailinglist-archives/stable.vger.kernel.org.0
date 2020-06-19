Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619D4201120
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404739AbgFSP35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404736AbgFSP34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:29:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14A272193E;
        Fri, 19 Jun 2020 15:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580595;
        bh=uqtwbsRdgA9KQ1Qk38D0uiKsZpvjs6cUPkTcF18vUNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKl1wQaFMNX4MrVd2dAqaCRRV2H9EYd4fcoexDIjylMRNX7SAJkPcf4HHInwfwP+y
         8Fj4SMl2bJaNArdEEdVdtN85JAA+qFSWQ7VuhzEZBg8lb/iDho5xofoUqCd01+vVeQ
         JTIcc4Dd5IT4ABSv70u3rzLDs4mMW5f0uuBUgNnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Macpaul Lin <macpaul.lin@mediatek.com>,
        Min Guo <min.guo@mediatek.com>, Bin Liu <b-liu@ti.com>
Subject: [PATCH 5.7 308/376] usb: musb: mediatek: add reset FADDR to zero in reset interrupt handle
Date:   Fri, 19 Jun 2020 16:33:46 +0200
Message-Id: <20200619141724.917772203@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Macpaul Lin <macpaul.lin@mediatek.com>

commit 402bcac4b25b520c89ba60db85eb6316f36e797f upstream.

When receiving reset interrupt, FADDR need to be reset to zero in
peripheral mode. Otherwise ep0 cannot do enumeration when re-plugging USB
cable.

Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Acked-by: Min Guo <min.guo@mediatek.com>
Signed-off-by: Bin Liu <b-liu@ti.com>
Link: https://lore.kernel.org/r/20200525025049.3400-5-b-liu@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/mediatek.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/musb/mediatek.c
+++ b/drivers/usb/musb/mediatek.c
@@ -208,6 +208,12 @@ static irqreturn_t generic_interrupt(int
 	musb->int_rx = musb_clearw(musb->mregs, MUSB_INTRRX);
 	musb->int_tx = musb_clearw(musb->mregs, MUSB_INTRTX);
 
+	if ((musb->int_usb & MUSB_INTR_RESET) && !is_host_active(musb)) {
+		/* ep0 FADDR must be 0 when (re)entering peripheral mode */
+		musb_ep_select(musb->mregs, 0);
+		musb_writeb(musb->mregs, MUSB_FADDR, 0);
+	}
+
 	if (musb->int_usb || musb->int_tx || musb->int_rx)
 		retval = musb_interrupt(musb);
 


