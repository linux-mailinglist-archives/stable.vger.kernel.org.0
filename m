Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30B733B9C1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhCOOGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232349AbhCOOBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAC7264E89;
        Mon, 15 Mar 2021 14:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816907;
        bh=nzF2+Ac+ZX7dpNx3h28V4HmbX4N/sSYTFFXDDkmkFwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBI/H3ffjZO+YtXafmb/kQdFkdM68RGtDqQgy1OwN/Vo/+rLJNf+B0HJwAz8nUKqc
         +J+LVw0f2O0LAoXZnWERR/Wtq4OjhEI+WE80ldPYQTJUs/al8Z0plnlYq6G9sizAEo
         HSVnYtr+SLKkS+OKIIvVdVIjcxcEfwjqkQYBwseo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH 5.11 194/306] USB: gadget: udc: s3c2410_udc: fix return value check in s3c2410_udc_probe()
Date:   Mon, 15 Mar 2021 14:54:17 +0100
Message-Id: <20210315135514.181530714@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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
 


