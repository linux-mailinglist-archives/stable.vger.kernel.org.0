Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF48462595
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhK2WlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234359AbhK2WkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:40:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4C6C1A0D0B;
        Mon, 29 Nov 2021 10:36:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8CDFB815C3;
        Mon, 29 Nov 2021 18:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F337DC53FC7;
        Mon, 29 Nov 2021 18:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210982;
        bh=RwHf7rzTrN9te67f67jNZtp0fi2vh7UGCsKADBU4yS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/+CJMWlFGJxLBbiBnCcl2Z6SqfQA8cnmHtBNjcZLG1MkHf+Z5MF6TvikjVf3y2P5
         Rk4ZS46p7EUeTrqUI2QQ+XvhXZdDauwH0ZGLlN030Be67Yyb9oygbhs6izWw5EDG4Y
         nCqhwzVXYB6NuUCVTZAYL1Vb6JFEjmGL8dj3uYtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.15 030/179] staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()
Date:   Mon, 29 Nov 2021 19:17:04 +0100
Message-Id: <20211129181719.944942006@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b535917c51acc97fb0761b1edec85f1f3d02bda4 upstream.

The free_rtllib() function frees the "dev" pointer so there is use
after free on the next line.  Re-arrange things to avoid that.

Fixes: 66898177e7e5 ("staging: rtl8192e: Fix unload/reload problem")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211117072016.GA5237@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -2549,13 +2549,14 @@ static void _rtl92e_pci_disconnect(struc
 			free_irq(dev->irq, dev);
 			priv->irq = 0;
 		}
-		free_rtllib(dev);
 
 		if (dev->mem_start != 0) {
 			iounmap((void __iomem *)dev->mem_start);
 			release_mem_region(pci_resource_start(pdev, 1),
 					pci_resource_len(pdev, 1));
 		}
+
+		free_rtllib(dev);
 	}
 
 	pci_disable_device(pdev);


