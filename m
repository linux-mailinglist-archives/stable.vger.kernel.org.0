Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB33B46245C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbhK2WRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbhK2WQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:16:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A76CC041F49;
        Mon, 29 Nov 2021 10:23:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11747B815C3;
        Mon, 29 Nov 2021 18:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CDDC53FC7;
        Mon, 29 Nov 2021 18:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210228;
        bh=l/X0lXZOB1HWvLM9/O/elsQ9nQakK5evFCzqNXymmDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwCEfXirJ9ivJjqN9zha2pU8J4GthgcK+t1yvlhreODTUS+eWazEzAKw4uJYtxp47
         M4ImNJwBpPIeq2022hyEnnj5QM+axa4oTqaCJa0cWJjCm0WoGXFi9vtl4PxDRKM1Oz
         BsdMwY3ncVyToQQ8xRCkbcmeBxHvU+OA0BrJHP+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.4 15/92] staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()
Date:   Mon, 29 Nov 2021 19:17:44 +0100
Message-Id: <20211129181707.929598147@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
@@ -2559,13 +2559,14 @@ static void _rtl92e_pci_disconnect(struc
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
 	} else {
 		priv = rtllib_priv(dev);
 	}


