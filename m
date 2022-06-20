Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE94551A69
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243746AbiFTNFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244174AbiFTNDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:03:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54F1638F;
        Mon, 20 Jun 2022 05:57:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 281E6B811AC;
        Mon, 20 Jun 2022 12:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77971C3411B;
        Mon, 20 Jun 2022 12:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729873;
        bh=4JFSQuzXKlwBjpQ6WGtJ+U1eZtcTY9mjkDzyax+qtO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwqgrjBL37VQHBUNp/BQw7han+ud0eTsgLLTzZVd8A61/ocXy29G6g8TTHR+wGJ5C
         NGKFh0fHtTv9isbzpx/0ZnL8xm0rJvveb8JSkIulfpyh/R28QswZWM5x3vKArNJtoq
         8O6TFvhJQ3y3d/Tej83EMw0mxbxduSFfVs8Xos6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.18 102/141] comedi: vmk80xx: fix expression for tx buffer size
Date:   Mon, 20 Jun 2022 14:50:40 +0200
Message-Id: <20220620124732.558627125@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit 242439f7e279d86b3f73b5de724bc67b2f8aeb07 upstream.

The expression for setting the size of the allocated bulk TX buffer
(`devpriv->usb_tx_buf`) is calling `usb_endpoint_maxp(devpriv->ep_rx)`,
which is using the wrong endpoint (should be `devpriv->ep_tx`).  Fix it.

Fixes: a23461c47482 ("comedi: vmk80xx: fix transfer-buffer overflow")
Cc: Johan Hovold <johan@kernel.org>
Cc: stable@vger.kernel.org # 4.9+
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20220607171819.4121-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/vmk80xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/comedi/drivers/vmk80xx.c
+++ b/drivers/comedi/drivers/vmk80xx.c
@@ -684,7 +684,7 @@ static int vmk80xx_alloc_usb_buffers(str
 	if (!devpriv->usb_rx_buf)
 		return -ENOMEM;
 
-	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
+	size = max(usb_endpoint_maxp(devpriv->ep_tx), MIN_BUF_SIZE);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;


