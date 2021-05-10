Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0C13783CC
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhEJKrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233175AbhEJKpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A73716145F;
        Mon, 10 May 2021 10:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642914;
        bh=qvblGfmtxj+gEH5BY1Zj5qnAC8tMmxJXYplIdEgeS/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4Sb/YAb9kM9PCyTTGiMGHW1FBdZrlWT3JARU3hGaCu/MPWb0DXV3vROO4I5IEAYS
         qOVmRx0FXMcqTDbryNRpd9N5CAuplrw2xuZ90a1EWmpOYpGS5ilHvSsljauqoT76hF
         xSk62bDT7fLdigys/r49G9viZsrEplLZzMtG8XB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shixin Liu <liushixin2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/299] crypto: sun8i-ce - Fix PM reference leak in sun8i_ce_probe()
Date:   Mon, 10 May 2021 12:18:20 +0200
Message-Id: <20210510102008.346391593@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shixin Liu <liushixin2@huawei.com>

[ Upstream commit cc987ae9150c255352660d235ab27c834aa527be ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 158422ff5695..00194d1d9ae6 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -932,7 +932,7 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 	if (err)
 		goto error_alg;
 
-	err = pm_runtime_get_sync(ce->dev);
+	err = pm_runtime_resume_and_get(ce->dev);
 	if (err < 0)
 		goto error_alg;
 
-- 
2.30.2



