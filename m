Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593D82E1567
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgLWCVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:21:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbgLWCVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B5AF22273;
        Wed, 23 Dec 2020 02:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690067;
        bh=I6+4PO4FxZdbiw9cibz5i/Q33nyjRQiA2SAzjDjaScM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyXrZIQz30kRVXu4HOkb6UOgnjg1723PUPUrD4EnaNjFDboKHCHlsbR859+vlT3xY
         olDKpL7IPvxnUYtfHFwN53mlD9hsY+ce1vUrzgXknv/ze8b96eQnyqU3gXuvGtHsmj
         TjzXM+mfLV9eEBp6O39YFzScPtsOFt6RTaHY4RfGSvsnjaJitTip54oK/aVwp/LrK4
         Tvxp8bvi2ohGS8NZfUQJ3/XYu6rV8RS0bYXgEX/BXcqS4PJh069DbkwDCJL2WZ/6m4
         6uX59G5qi77HBjn2LiSs5sAH92juJBkI3W/dgfsJU7SK32yqWClvWHlsFsZUUpzxiI
         Wkd5g226eqLqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/87] crypto: omap-aes - fix the reference count leak of omap device
Date:   Tue, 22 Dec 2020 21:19:39 -0500
Message-Id: <20201223022103.2792705-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 383e8a823014532ffd81c787ef9009f1c2bd3b79 ]

pm_runtime_get_sync() will increment  pm usage counter even
when it returns an error code. We should call put operation
in error handling paths of omap_aes_hw_init.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-aes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 9019f6b67986b..080c7cf077053 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -109,6 +109,7 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 
 	err = pm_runtime_get_sync(dd->dev);
 	if (err < 0) {
+		pm_runtime_put_noidle(dd->dev);
 		dev_err(dd->dev, "failed to get sync: %d\n", err);
 		return err;
 	}
-- 
2.27.0

