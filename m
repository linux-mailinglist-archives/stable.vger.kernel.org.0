Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0275085F
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbfFXKQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730812AbfFXKQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:16:52 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E57E32089F;
        Mon, 24 Jun 2019 10:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371411;
        bh=iij1meYte0WHz2U2A83FqefBIDwkigj8yIeBCh4EbG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myf/f+xEf8NEvlgMMN4e32DZghZXBrlf8t2JThhKZ+yUaYeHuFe+rDAQ6UWJRpFrA
         ifpHno0KCcxt5lKsS+Kc+l5DLKkj2Sj1MBMnDOKV//lNSeFKlT99QwWTAU1smg9as6
         0jnpairRKLErnNapvPho5Mu+O3QDrpjq6YFZKZuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shubhrajyoti Datta <shubhrajyoti.datta@gmail.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Michal Simek <michal.simek@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.1 093/121] can: xilinx_can: use correct bittiming_const for CAN FD core
Date:   Mon, 24 Jun 2019 17:57:05 +0800
Message-Id: <20190624092325.534361171@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

commit 904044dd8fff43e289c11a2f90fa532e946a1d8b upstream.

Commit 9e5f1b273e6a ("can: xilinx_can: add support for Xilinx CAN FD
core") added a new can_bittiming_const structure for CAN FD cores that
support larger values for tseg1, tseg2, and sjw than previous Xilinx CAN
cores, but the commit did not actually take that into use.

Fix that.

Tested with CAN FD core on a ZynqMP board.

Fixes: 9e5f1b273e6a ("can: xilinx_can: add support for Xilinx CAN FD core")
Reported-by: Shubhrajyoti Datta <shubhrajyoti.datta@gmail.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Cc: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@gmail.com>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/xilinx_can.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1443,7 +1443,7 @@ static const struct xcan_devtype_data xc
 		 XCAN_FLAG_RXMNF |
 		 XCAN_FLAG_TX_MAILBOXES |
 		 XCAN_FLAG_RX_FIFO_MULTI,
-	.bittiming_const = &xcan_bittiming_const,
+	.bittiming_const = &xcan_bittiming_const_canfd,
 	.btr_ts2_shift = XCAN_BTR_TS2_SHIFT_CANFD,
 	.btr_sjw_shift = XCAN_BTR_SJW_SHIFT_CANFD,
 	.bus_clk_name = "s_axi_aclk",


