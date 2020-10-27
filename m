Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49E129C635
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901042AbgJ0SO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2507085AbgJ0ONU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:13:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F7EF2076A;
        Tue, 27 Oct 2020 14:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808000;
        bh=uccbjVnIjVgigrqIjbS79OPTjDa+TLQTDs3MNrwqrh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1Nz1281jASlx8BEPLncQZmjPl+GGAaiVc99ykdoiOR+lrrYTa6E/1gEX7egUjAXw
         pYOiXYeB3zSNMtTNFNnPJY42olpCtg/Uy9q6BwL1sWSGg6SjqOD3tmzxO+ipWeCswM
         Z0py3bzqHVqVEB4elPGyVZQ5k2IMCyta3jfUWPLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 120/191] Input: stmfts - fix a & vs && typo
Date:   Tue, 27 Oct 2020 14:49:35 +0100
Message-Id: <20201027134915.470663205@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
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
index c72662c979e79..d9e93dabbca21 100644
--- a/drivers/input/touchscreen/stmfts.c
+++ b/drivers/input/touchscreen/stmfts.c
@@ -484,7 +484,7 @@ static ssize_t stmfts_sysfs_hover_enable_write(struct device *dev,
 
 	mutex_lock(&sdata->mutex);
 
-	if (value & sdata->hover_enabled)
+	if (value && sdata->hover_enabled)
 		goto out;
 
 	if (sdata->running)
-- 
2.25.1



