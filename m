Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6656C6FC
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391101AbfGRDKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389758AbfGRDKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:10:09 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ADEF205F4;
        Thu, 18 Jul 2019 03:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419408;
        bh=6eCuCSXv/rUkzbDMseQAaw/Dls8iE2lIaphpMe0on5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjmVB/Sb27RBLdXMF9x8MtsCo3QuXiLjcXDYdOtB8Gxvee2/fjXHCPyf4SHFoYQiC
         k78x1dE4auVeKpTrMDpJXvEQa83AwQ6yhaerJLeYiqlt7Z7G9gvvrZ7kOs2YomQD2P
         FIUVt+ICT9Nv1MkSd5CwyHvkUc1sJnJ2BgsS6dxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kiruthika Varadarajan <Kiruthika.Varadarajan@harman.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 4.14 54/80] usb: gadget: ether: Fix race between gether_disconnect and rx_submit
Date:   Thu, 18 Jul 2019 12:01:45 +0900
Message-Id: <20190718030102.754423223@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kiruthika Varadarajan <Kiruthika.Varadarajan@harman.com>

commit d29fcf7078bc8be2b6366cbd4418265b53c94fac upstream.

On spin lock release in rx_submit, gether_disconnect get a chance to
run, it makes port_usb NULL, rx_submit access NULL port USB, hence null
pointer crash.

Fixed by releasing the lock in rx_submit after port_usb is used.

Fixes: 2b3d942c4878 ("usb ethernet gadget: split out network core")
Cc: <stable@vger.kernel.org>
Signed-off-by: Kiruthika Varadarajan <Kiruthika.Varadarajan@harman.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/u_ether.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -190,11 +190,12 @@ rx_submit(struct eth_dev *dev, struct us
 		out = dev->port_usb->out_ep;
 	else
 		out = NULL;
-	spin_unlock_irqrestore(&dev->lock, flags);
 
 	if (!out)
+	{
+		spin_unlock_irqrestore(&dev->lock, flags);
 		return -ENOTCONN;
-
+	}
 
 	/* Padding up to RX_EXTRA handles minor disagreements with host.
 	 * Normally we use the USB "terminate on short read" convention;
@@ -218,6 +219,7 @@ rx_submit(struct eth_dev *dev, struct us
 
 	if (dev->port_usb->is_fixed)
 		size = max_t(size_t, size, dev->port_usb->fixed_out_len);
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	skb = __netdev_alloc_skb(dev->net, size + NET_IP_ALIGN, gfp_flags);
 	if (skb == NULL) {


