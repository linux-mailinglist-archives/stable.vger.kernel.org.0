Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C73F46276C
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbhK2XFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236983AbhK2XFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:05:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF42C12BCE4;
        Mon, 29 Nov 2021 10:34:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 67F8BCE13BF;
        Mon, 29 Nov 2021 18:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127E5C53FAD;
        Mon, 29 Nov 2021 18:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210881;
        bh=UBxRqpehkTzlbRRWileAd8/hFwZaKngyooC6GoTBRdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKG4ljYwy1QXkHXcx75lKs0cReNjE3B0x13HL+J0HALLs2zsSfzTrFoafHcX+fUrv
         xZy7AIfCNqRLqDWbfLU0+iYqW5hiGiqwbn3w5/YvZXiEODUgX5hraP4rd6Y3cdkYwV
         1jdjEtFyJZK1vnX90syKrRo3DB0aue0i/yJGQuYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans De Goede <hdegoede@redhat.com>,
        Fabio Aiuto <fabioaiuto83@gmail.com>
Subject: [PATCH 5.15 009/179] usb: dwc3: leave default DMA for PCI devices
Date:   Mon, 29 Nov 2021 19:16:43 +0100
Message-Id: <20211129181719.246660831@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Aiuto <fabioaiuto83@gmail.com>

commit 47ce45906ca9870cf5267261f155fb7c70307cf0 upstream.

in case of a PCI dwc3 controller, leave the default DMA
mask. Calling of a 64 bit DMA mask breaks the driver on
cherrytrail based tablets like Cyberbook T116.

Fixes: 45d39448b4d0 ("usb: dwc3: support 64 bit DMA in platform driver")
Cc: stable <stable@vger.kernel.org>
Reported-by: Hans De Goede <hdegoede@redhat.com>
Tested-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/20211113142959.27191-1-fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1565,9 +1565,11 @@ static int dwc3_probe(struct platform_de
 
 	dwc3_get_properties(dwc);
 
-	ret = dma_set_mask_and_coherent(dwc->sysdev, DMA_BIT_MASK(64));
-	if (ret)
-		return ret;
+	if (!dwc->sysdev_is_parent) {
+		ret = dma_set_mask_and_coherent(dwc->sysdev, DMA_BIT_MASK(64));
+		if (ret)
+			return ret;
+	}
 
 	dwc->reset = devm_reset_control_array_get_optional_shared(dev);
 	if (IS_ERR(dwc->reset))


