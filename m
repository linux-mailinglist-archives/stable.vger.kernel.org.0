Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5863633B9F5
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhCOOHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233681AbhCOOCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 531ED64F38;
        Mon, 15 Mar 2021 14:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816937;
        bh=nzF2+Ac+ZX7dpNx3h28V4HmbX4N/sSYTFFXDDkmkFwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvPCj6UFO1rMqB6wPpqEyAsk0dC2bP/k96kEWFHWZJ1yI++25PXVw526KIaYx/qA/
         k7MrRLbquT5LPTMbMxLubtWUJC+GdVP+tvZOYWK71I4VEyY7RbaiM3PwAd1KLYk1Yj
         1yPGFx3snn1ryB3tjuZjLR0CnQpsMlfOJ1JCtT+c=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH 5.10 198/290] USB: gadget: udc: s3c2410_udc: fix return value check in s3c2410_udc_probe()
Date:   Mon, 15 Mar 2021 14:54:51 +0100
Message-Id: <20210315135548.610064720@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 414c20df7d401bcf1cb6c13d2dd944fb53ae4acf upstream.

In case of error, the function devm_platform_ioremap_resource()
returns ERR_PTR() and never returns NULL. The NULL test in the
return value check should be replaced with IS_ERR().

Fixes: 188db4435ac6 ("usb: gadget: s3c: use platform resources")
Cc: stable <stable@vger.kernel.org>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20210305034927.3232386-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/s3c2410_udc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/udc/s3c2410_udc.c
+++ b/drivers/usb/gadget/udc/s3c2410_udc.c
@@ -1773,8 +1773,8 @@ static int s3c2410_udc_probe(struct plat
 	udc_info = dev_get_platdata(&pdev->dev);
 
 	base_addr = devm_platform_ioremap_resource(pdev, 0);
-	if (!base_addr) {
-		retval = -ENOMEM;
+	if (IS_ERR(base_addr)) {
+		retval = PTR_ERR(base_addr);
 		goto err_mem;
 	}
 


