Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98F02E1783
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgLWCSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:18:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgLWCSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1385922202;
        Wed, 23 Dec 2020 02:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689837;
        bh=YKhg6n2NEbJnGtJdq++WzvE6avrtrzUoOovc1QxUGps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJzyxJapHJwHITdzKM6j5hJOy0hNyZaPK1CWlsYTOhJfgGhW3IbA6WFu8gIMrR3ZV
         szGvxvJpjBVjV9O5AsuqaGtX62mhehU07f0aZy2+xNEwwfLb/FDZ4EU+8sVhP7QM2v
         HXp3GJKRzOQjPKnHt80ndWhdxy2/ov0Kuav2vyeVotsyeOj/VJTDE/uaz3gnf4SWp4
         soEsn5Kfs451SuuaP4n+PskU9pa3eCEDRGGXrHtsPya4u5xiBkN58qlZratgA2GhVB
         ML2wDSfrhMos45uEuAJuysWrZ4bd3LiHOjOAfMdcuaIVSz8E00uUwSBkFMfXxq/HVR
         VKPlICxjZPP5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.10 038/217] staging: ks7010: fix missing destroy_workqueue() on error in ks7010_sdio_probe
Date:   Tue, 22 Dec 2020 21:13:27 -0500
Message-Id: <20201223021626.2790791-38-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit d1e7550ad081fa5e9260f636dd51e1c496e0fd5f ]

Add the missing destroy_workqueue() before return from
ks7010_sdio_probe in the error handling case.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/20201028091552.136445-1-miaoqinglang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/ks7010/ks7010_sdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ks7010/ks7010_sdio.c b/drivers/staging/ks7010/ks7010_sdio.c
index 78dc8beeae98e..cbc0032c16045 100644
--- a/drivers/staging/ks7010/ks7010_sdio.c
+++ b/drivers/staging/ks7010/ks7010_sdio.c
@@ -1029,10 +1029,12 @@ static int ks7010_sdio_probe(struct sdio_func *func,
 
 	ret = register_netdev(priv->net_dev);
 	if (ret)
-		goto err_free_netdev;
+		goto err_destroy_wq;
 
 	return 0;
 
+ err_destroy_wq:
+	destroy_workqueue(priv->wq);
  err_free_netdev:
 	free_netdev(netdev);
  err_release_irq:
-- 
2.27.0

