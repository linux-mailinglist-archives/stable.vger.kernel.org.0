Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41870499A76
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573058AbiAXVoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454804AbiAXVdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:33:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9E4C075D25;
        Mon, 24 Jan 2022 12:21:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 298E0B81257;
        Mon, 24 Jan 2022 20:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A04C340E5;
        Mon, 24 Jan 2022 20:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055703;
        bh=1KHb9wvFXEyYvtRJab/HZafFYOYTD5JvDV83wTL6zN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXUVEcmdNycSHkPqP2NFzmgdcLprvxv0m6E9rSeIq+Qs4EleP+9ibnsXyAGnXwRdB
         wCrFFiqUj1RYVpE3N49HvwaaulwYPHs3Su2yRFiHG2QzDl5XnZWIXSRsai41jdT38l
         OG94BfSFBLak0v5gcZTsBLluhTBfENv2UWVdudUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 238/846] crypto: hisilicon/qm - fix incorrect return value of hisi_qm_resume()
Date:   Mon, 24 Jan 2022 19:35:55 +0100
Message-Id: <20220124184109.145101923@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 3f9dd4c802b96626e869b2d29c8e401dabadd23e ]

When hisi_qm_resume() returns 0, it indicates that the device has started
successfully.  If the device fails to start, hisi_qm_resume() needs to
return the actual error code to the caller instead of 0.

Fixes: d7ea53395b72 ("crypto: hisilicon - add runtime PM ops")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 369562d34d66a..ff1122153fbec 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5986,7 +5986,7 @@ int hisi_qm_resume(struct device *dev)
 	if (ret)
 		pci_err(pdev, "failed to start qm(%d)\n", ret);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hisi_qm_resume);
 
-- 
2.34.1



