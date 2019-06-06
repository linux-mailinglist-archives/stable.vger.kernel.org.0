Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F0F36A21
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 04:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfFFCnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 22:43:39 -0400
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:49226 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfFFCni (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 22:43:38 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id x562hQs0023370; Thu, 6 Jun 2019 11:43:26 +0900
X-Iguazu-Qid: 2wHHWpDcgq4H6jEfhI
X-Iguazu-QSIG: v=2; s=0; t=1559789006; q=2wHHWpDcgq4H6jEfhI; m=W+IncDPj0BJJf8hYVTSQIwWszc5uFsusuKLRllCK0zc=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1111) id x562hO32007187;
        Thu, 6 Jun 2019 11:43:25 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id x562hO5s029115;
        Thu, 6 Jun 2019 11:43:24 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id x562hO8l003141;
        Thu, 6 Jun 2019 11:43:24 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     Peter Chen <peter.chen@nxp.com>,
        "Felipe F . Tonello" <eu@felipetonello.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4.y] usb: gadget: fix request length error for isoc transfer
Date:   Thu,  6 Jun 2019 11:43:09 +0900
X-TSB-HOP: ON
Message-Id: <20190606024309.14309-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit 982555fc26f9d8bcdbd5f9db0378fe0682eb4188 upstream.

For isoc endpoint descriptor, the wMaxPacketSize is not real max packet
size (see Table 9-13. Standard Endpoint Descriptor, USB 2.0 specifcation),
it may contain the number of packet, so the real max packet should be
ep->desc->wMaxPacketSize && 0x7ff.

Cc: Felipe F. Tonello <eu@felipetonello.com>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Fixes: 16b114a6d797 ("usb: gadget: fix usb_ep_align_maybe
  endianness and new usb_ep_align")

Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
[iwamatsu: Fix Fixes tag]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 include/linux/usb/gadget.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 7e84aac39ade..667e7f9fd877 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -671,7 +671,9 @@ static inline struct usb_gadget *dev_to_usb_gadget(struct device *dev)
  */
 static inline size_t usb_ep_align(struct usb_ep *ep, size_t len)
 {
-	return round_up(len, (size_t)le16_to_cpu(ep->desc->wMaxPacketSize));
+	int max_packet_size = (size_t)usb_endpoint_maxp(ep->desc) & 0x7ff;
+
+	return round_up(len, max_packet_size);
 }
 
 /**
-- 
2.20.1

