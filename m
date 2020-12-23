Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3202E1569
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbgLWCVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729355AbgLWCV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D26DD22D57;
        Wed, 23 Dec 2020 02:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690074;
        bh=bekyIg2oekmTb8hNKIpUzzjpxe4fkYk0GmcXFxkJu5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Co0pw8tGBA9JPOJSOc9uIE7bWB59R3YaQ+arBalBhdmO1p1tkAbRy6MV7x3yZreJ1
         DQtUBGvkKzFJ0/+8jSUMhWvq5Ylvxxlo1jbk1loM5xHzt303Fcmw/A0frbcA9FTF6H
         y+jvFiZFBl2j26NA+ck/UQ7i1q5A7yCeAuGkvvqTGvZb/54Ifpq1IPonDOxDo1VOkq
         4MHbSEO+wYUIQQSeVDYfJQrG/K40AWAYYfQeTcZz33TSyN1HMxbJlNnJrDmVKOR0cd
         IfY3ZQIMbC97PdgBWzbLMIJJa/qrvJhILUx5QCSVnn3/xNZsof29dQKo5CWZL340Ql
         afwTbWY0RhvTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.19 08/87] staging: ks7010: fix missing destroy_workqueue() on error in ks7010_sdio_probe
Date:   Tue, 22 Dec 2020 21:19:44 -0500
Message-Id: <20201223022103.2792705-8-sashal@kernel.org>
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
index 74551eb717fc7..b3445a19db6f1 100644
--- a/drivers/staging/ks7010/ks7010_sdio.c
+++ b/drivers/staging/ks7010/ks7010_sdio.c
@@ -1028,10 +1028,12 @@ static int ks7010_sdio_probe(struct sdio_func *func,
 
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

