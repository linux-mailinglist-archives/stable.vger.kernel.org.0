Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1D849A9F2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323867AbiAYD3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58932 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349099AbiAXVGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:06:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B566B81188;
        Mon, 24 Jan 2022 21:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0AFC340E5;
        Mon, 24 Jan 2022 21:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058402;
        bh=uJ1++earz7G6KZn++LZyYdU2fw7m5hLElXi2bBZLUwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNUg5T9OGsWu/bCGV2bQVrDQdzDKjlIYJWCYzGg/OVLya0+Lhnt1pffYVGa7Gpo//
         5v7LG7GtzCpA7QuNLRAQlrhWRmyCJt7M+TbIWC8+s0dskEUy4FLJb/16X5Sdx6cd/L
         GCAp2gtDGZH9L26HbMOrY3M6+dKNyqwGXCHYmpOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0278/1039] crypto: hisilicon/qm - fix incorrect return value of hisi_qm_resume()
Date:   Mon, 24 Jan 2022 19:34:27 +0100
Message-Id: <20220124184134.628311296@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 52d6cca6262e2..70b0405494db5 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -6038,7 +6038,7 @@ int hisi_qm_resume(struct device *dev)
 	if (ret)
 		pci_err(pdev, "failed to start qm(%d)\n", ret);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hisi_qm_resume);
 
-- 
2.34.1



