Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF75551DD0
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239495AbiFTODi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352139AbiFTNz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:55:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2276CCD;
        Mon, 20 Jun 2022 06:22:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53D6160AC0;
        Mon, 20 Jun 2022 13:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE85AC3411C;
        Mon, 20 Jun 2022 13:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731320;
        bh=dah1VrpcId8Z+u4nGQ7YFJhY+zDgfrwXLh8LQLGIoDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/ZKoJy9e5GPcqY0lLHX2Ijkzbepd01GEDggVHJsGUFdLdm/n2o0X/dMJeiyJJ7Pf
         gc6DQG6K32lRSj65BvFY9E+kEaZUyuv2SEQKLE+ErV4Dmj6xZS8WDK6av8d5UUZAcM
         4eU2547BVAEcBBt6up9j4EkibOykO1aUgW2oYTa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.4 221/240] comedi: vmk80xx: fix expression for tx buffer size
Date:   Mon, 20 Jun 2022 14:52:02 +0200
Message-Id: <20220620124745.370312726@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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
 drivers/staging/comedi/drivers/vmk80xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -685,7 +685,7 @@ static int vmk80xx_alloc_usb_buffers(str
 	if (!devpriv->usb_rx_buf)
 		return -ENOMEM;
 
-	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
+	size = max(usb_endpoint_maxp(devpriv->ep_tx), MIN_BUF_SIZE);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;


