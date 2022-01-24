Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8D3498EE7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350166AbiAXTtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59542 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348213AbiAXTi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:38:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09E81B81247;
        Mon, 24 Jan 2022 19:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2217EC33D63;
        Mon, 24 Jan 2022 19:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053106;
        bh=or6XJy6yo9zuglFE+mcPkKgZhy2eM7wUlvB3E6iEwSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLUJOLEB3I1xzNlOvRuI0Xc6DrkLZYIV9rlnbJcJi2CsYcOXRHEhFHJ9UDoBrvp0n
         jhX5ZTugudQ0QPeJjjc1sYnD0qQA5yo3/Oe5Fazxln8dVCzAg/jl6CIgxVXb2ki5ig
         NCYqeovUEhgiy8LcODl7oAONDUid4sqlWKDoNvCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 246/320] crypto: omap-aes - Fix broken pm_runtime_and_get() usage
Date:   Mon, 24 Jan 2022 19:43:50 +0100
Message-Id: <20220124184002.365104869@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

commit c2aec59be093bd44627bc4f6bc67e4614a93a7b6 upstream.

This fix is basically the same as 3d6b661330a7 ("crypto: stm32 -
Revert broken pm_runtime_resume_and_get changes"), just for the omap
driver. If the return value isn't used, then pm_runtime_get_sync()
has to be used for ensuring that the usage count is balanced.

Fixes: 1f34cc4a8da3 ("crypto: omap-aes - Fix PM reference leak on omap-aes.c")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/omap-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1318,7 +1318,7 @@ static int omap_aes_suspend(struct devic
 
 static int omap_aes_resume(struct device *dev)
 {
-	pm_runtime_resume_and_get(dev);
+	pm_runtime_get_sync(dev);
 	return 0;
 }
 #endif


