Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8B448338E
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiACOim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbiACOhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:37:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB67C08EAD4;
        Mon,  3 Jan 2022 06:33:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E25B6B80EFD;
        Mon,  3 Jan 2022 14:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F42C36AEB;
        Mon,  3 Jan 2022 14:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220409;
        bh=5U6iPXZnzYKCqJqXw13IqFsuc3uU5UNGn4YlXwDK+J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkZqNuox8g1b2tvC9jop0gCe0Wk70UXtJ60b1AX7+NGEXHWVmnYuAJXfvq2m5ty4Q
         BAW7f9s+StJr2SlFVTLevhLBcHI4JE9+QjrslJpP91y35XxqI0o+xXuJWfjzo5P7mi
         lHYzsxdyf1mTiNBI6GcwMFUC0LJtLiUOkgiNiJJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie Hung <eddie.hung@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.15 60/73] usb: mtu3: add memory barrier before set GPDs HWO
Date:   Mon,  3 Jan 2022 15:24:21 +0100
Message-Id: <20220103142058.864600142@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit a7aae769ca626819a7f9f078ebdc69a8a1b00c81 upstream.

There is a seldom issue that the controller access invalid address
and trigger devapc or emimpu violation. That is due to memory access
is out of order and cause gpd data is not correct.
Add mb() to prohibit compiler or cpu from reordering to make sure GPD
is fully written before setting its HWO.

Fixes: 48e0d3735aa5 ("usb: mtu3: supports new QMU format")
Cc: stable@vger.kernel.org
Reported-by: Eddie Hung <eddie.hung@mediatek.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20211218095749.6250-2-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mtu3/mtu3_qmu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/mtu3/mtu3_qmu.c
+++ b/drivers/usb/mtu3/mtu3_qmu.c
@@ -273,6 +273,8 @@ static int mtu3_prepare_tx_gpd(struct mt
 			gpd->dw3_info |= cpu_to_le32(GPD_EXT_FLAG_ZLP);
 	}
 
+	/* prevent reorder, make sure GPD's HWO is set last */
+	mb();
 	gpd->dw0_info |= cpu_to_le32(GPD_FLAGS_IOC | GPD_FLAGS_HWO);
 
 	mreq->gpd = gpd;
@@ -306,6 +308,8 @@ static int mtu3_prepare_rx_gpd(struct mt
 	gpd->next_gpd = cpu_to_le32(lower_32_bits(enq_dma));
 	ext_addr |= GPD_EXT_NGP(mtu, upper_32_bits(enq_dma));
 	gpd->dw3_info = cpu_to_le32(ext_addr);
+	/* prevent reorder, make sure GPD's HWO is set last */
+	mb();
 	gpd->dw0_info |= cpu_to_le32(GPD_FLAGS_IOC | GPD_FLAGS_HWO);
 
 	mreq->gpd = gpd;
@@ -445,7 +449,8 @@ static void qmu_tx_zlp_error_handler(str
 		return;
 	}
 	mtu3_setbits(mbase, MU3D_EP_TXCR0(mep->epnum), TX_TXPKTRDY);
-
+	/* prevent reorder, make sure GPD's HWO is set last */
+	mb();
 	/* by pass the current GDP */
 	gpd_current->dw0_info |= cpu_to_le32(GPD_FLAGS_BPS | GPD_FLAGS_HWO);
 


