Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B746F558223
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiFWRK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiFWRJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:09:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57ACA562CF;
        Thu, 23 Jun 2022 09:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94E2D60B2C;
        Thu, 23 Jun 2022 16:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D3EC3411B;
        Thu, 23 Jun 2022 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003448;
        bh=6XAypWJoYaPQZyaDCVQ3fpYCncTok/BXGrjFVTqXzHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I642/gRR+LqW5oN9B1dFDrmMhOOktB6vDcW58cg+w/rNafYAV4eaKrlO272Llx2A+
         VlWaLkqRl93bpJCDnHzedGGv4Z0op3CAvtIW0bbKMRvDbt1Cu/e8LTWmtI6Fo6rvau
         g+D9H6GwlnNt7GzwJstJtj9+CaAjGw/Z/xVu/XA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.9 242/264] comedi: vmk80xx: fix expression for tx buffer size
Date:   Thu, 23 Jun 2022 18:43:55 +0200
Message-Id: <20220623164350.920498267@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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
@@ -694,7 +694,7 @@ static int vmk80xx_alloc_usb_buffers(str
 	if (!devpriv->usb_rx_buf)
 		return -ENOMEM;
 
-	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
+	size = max(usb_endpoint_maxp(devpriv->ep_tx), MIN_BUF_SIZE);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;


