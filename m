Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0992461E36
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352447AbhK2SeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:34:04 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49866 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378525AbhK2ScB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:32:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 61732CE13D4;
        Mon, 29 Nov 2021 18:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DA3C53FCF;
        Mon, 29 Nov 2021 18:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210520;
        bh=/5aFWUApRAT3qtncY27mtGufuqiHxuHHkncvawP+XEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqIKKNr2o40xjKpCvtBcf97i4uD6iAvtqumKADlF2WLttE5Tan/RN9wofBFAqtxjL
         0m5/CY72iT9EAkUXYxYVn3xHrMM/PXVAg17GELTdCgu++7Ti0hS794pMsUCNx8IFGA
         P2Bob4sDtS9UQJzIOaGzhRxz5+PANLwsUn5DsBvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.10 024/121] staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()
Date:   Mon, 29 Nov 2021 19:17:35 +0100
Message-Id: <20211129181712.469252412@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
@@ -2551,13 +2551,14 @@ static void _rtl92e_pci_disconnect(struc
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


