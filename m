Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC57A3A90F
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388721AbfFIRHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388593AbfFIRHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:07:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C41A1204EC;
        Sun,  9 Jun 2019 17:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560100020;
        bh=kwW5+pOo3pPjSz9BOXtdOb8u8nq7tl+VmP88bEPje4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqMqn3LkXPEhFlak4hl1gXV5PeGKLY/m7y9/h6KxdFIMuh9uNbPx/hxZJIuJC5foQ
         sSyhmjz+mATftxSWG/y50AUQTzZW8lH4VNl25Ik7buQj2sBw7RUv90XMGvZfCwmbkl
         drFJsMHvyDXq/4E3asd7AAB14U5gwonm1OCH7gWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Felipe F. Tonello" <eu@felipetonello.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Peter Chen <peter.chen@nxp.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 227/241] usb: gadget: fix request length error for isoc transfer
Date:   Sun,  9 Jun 2019 18:42:49 +0200
Message-Id: <20190609164155.265088934@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
  endianness and new usb_ep_aligna")

Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/usb/gadget.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -671,7 +671,9 @@ static inline struct usb_gadget *dev_to_
  */
 static inline size_t usb_ep_align(struct usb_ep *ep, size_t len)
 {
-	return round_up(len, (size_t)le16_to_cpu(ep->desc->wMaxPacketSize));
+	int max_packet_size = (size_t)usb_endpoint_maxp(ep->desc) & 0x7ff;
+
+	return round_up(len, max_packet_size);
 }
 
 /**


