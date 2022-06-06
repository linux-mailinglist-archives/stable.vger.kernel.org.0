Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E094A53EC5D
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbiFFLBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbiFFLBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:01:46 -0400
X-Greylist: delayed 528 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Jun 2022 04:01:45 PDT
Received: from smtp72.iad3b.emailsrvr.com (smtp72.iad3b.emailsrvr.com [146.20.161.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914F4199497
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 04:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1654512776;
        bh=TUUQyGwG6gG5scTKs+UXpkON4figZcnPPKrSpKlUnAk=;
        h=From:To:Subject:Date:From;
        b=kB7UMW0KhpskaGUcbMTKnmAYcIGGVCeYjgO5HyNbDNoLyy7ReWYPdE51W3DzGWxmN
         4mQ8D2vmoMPSwDoMGqA9EB8+wIU0EJEw54g9XBb+0zXCAkOSj5SkSZfKZl7CmJzvp2
         h8BuzBbo+drFvdbu/+MBK3KyQsiuN1dT4z8soSU8=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp10.relay.iad3b.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 2181EE00AD;
        Mon,  6 Jun 2022 06:52:56 -0400 (EDT)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] comedi: vmk80xx: fix expression for tx buffer size
Date:   Mon,  6 Jun 2022 11:52:37 +0100
Message-Id: <20220606105237.13937-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: 63334f43-0d53-458e-bfe3-ce4910e61cb5-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The expression for setting the size of the allocated bulk TX buffer
(`devpriv->usb_tx_buf`) is calling `usb_endpoint_maxp(devpriv->ep_rx)`,
which is using the wrong endpoint (should be `devpriv->ep_tx`).  Fix it.

Fixes: a23461c47482 ("comedi: vmk80xx: fix transfer-buffer overflow")
Cc: Johan Hovold <johan@kernel.org>
Cc: stable@vger.kernel.org # 5.10, 5.15+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/comedi/drivers/vmk80xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/vmk80xx.c b/drivers/comedi/drivers/vmk80xx.c
index 46023adc5395..4536ed43f65b 100644
--- a/drivers/comedi/drivers/vmk80xx.c
+++ b/drivers/comedi/drivers/vmk80xx.c
@@ -684,7 +684,7 @@ static int vmk80xx_alloc_usb_buffers(struct comedi_device *dev)
 	if (!devpriv->usb_rx_buf)
 		return -ENOMEM;
 
-	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
+	size = max(usb_endpoint_maxp(devpriv->ep_tx), MIN_BUF_SIZE);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;
-- 
2.35.1

