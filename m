Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0AB3540664
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347328AbiFGRex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347442AbiFGRap (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:45 -0400
X-Greylist: delayed 496 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Jun 2022 10:26:49 PDT
Received: from smtp67.ord1d.emailsrvr.com (smtp67.ord1d.emailsrvr.com [184.106.54.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFDB1116DC
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 10:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1654622312;
        bh=euZGxOd3pxjypj1/z7N1GUIu656v2zkFAT2vpmjc2/4=;
        h=From:To:Subject:Date:From;
        b=DWKTmyC2VbSDqDcc7W0E4JTsr1+mkuZ0NK7bWf3Yff14Hj0EGkBuZJWkLOMRjwehG
         zZYcL5U0lNdWRAw8XwDY/F1qgrvrxUyrqgZ9nFuuXdUIVk3WwhW3i+DOhCJRo5tXNz
         aSqNhN4DfqzQhW8BeVV4FU+siy/1CjOK2TW4VXhM=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp9.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id F400CC0A4E;
        Tue,  7 Jun 2022 13:18:31 -0400 (EDT)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2] comedi: vmk80xx: fix expression for tx buffer size
Date:   Tue,  7 Jun 2022 18:18:19 +0100
Message-Id: <20220607171819.4121-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <d2696256-639b-4b20-3612-6dcfe68313a1@mev.co.uk>
References: <d2696256-639b-4b20-3612-6dcfe68313a1@mev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: 72dfd4e7-ea9b-46f6-9082-6bc6c9ba8098-1-1
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
Cc: stable@vger.kernel.org # 4.9+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Reviewed-by: Johan Hovold <johan@kernel.org>
---
v2: Amended Cc: stable@vger.kernel.org line to apply to 4.9+.
    Added Reviewed-by: Johan Hovold

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

