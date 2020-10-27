Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8592629B295
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762472AbgJ0OnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761124AbgJ0Om4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:42:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9033420773;
        Tue, 27 Oct 2020 14:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809776;
        bh=Aj3H/mllP3Z1Ndwy+73zR5D3CeWuFmetb4clh9ff4xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRN8JRLtx5K9p5mdNJYDS2lsijJFr4NsDjefwlGDgw90HpGa47uw2KudUPY+s9lUH
         4qJ1/dBEhNB0bAc/+cKa/NwP3JNYMXaasfvw6BgkOq303vBk6OkYCnTT04HkOcAt4t
         kRc0JNryjPXCU90uxDSX95iUXZaOIUWHan59tPKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 285/408] Input: stmfts - fix a & vs && typo
Date:   Tue, 27 Oct 2020 14:53:43 +0100
Message-Id: <20201027135508.267699830@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit d04afe14b23651e7a8bc89727a759e982a8458e4 ]

In stmfts_sysfs_hover_enable_write(), we should check value and
sdata->hover_enabled is all true.

Fixes: 78bcac7b2ae1 ("Input: add support for the STMicroelectronics FingerTip touchscreen")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20200916141941.16684-1-yuehaibing@huawei.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/stmfts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/stmfts.c b/drivers/input/touchscreen/stmfts.c
index b6f95f20f9244..cd8805d71d977 100644
--- a/drivers/input/touchscreen/stmfts.c
+++ b/drivers/input/touchscreen/stmfts.c
@@ -479,7 +479,7 @@ static ssize_t stmfts_sysfs_hover_enable_write(struct device *dev,
 
 	mutex_lock(&sdata->mutex);
 
-	if (value & sdata->hover_enabled)
+	if (value && sdata->hover_enabled)
 		goto out;
 
 	if (sdata->running)
-- 
2.25.1



