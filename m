Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7128124757C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbgHQTYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729796AbgHQPen (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:34:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4B220882;
        Mon, 17 Aug 2020 15:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678483;
        bh=dHoB6WN7dMe7me8nFYFb2Na5SEj5aIZg5J6VQssDatI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHKm1KpIciKJvMk4SMmu9cf6YKRxum1HzPYBVzRXQm+7OmybcxeDjlqMIos0dvSiZ
         Coytc+MNJzoOcT/kLAUB3HGNJzdpXDVBYO49drWQSNqAO4DDXxGVZZNuaz4soq+QZb
         Trc3sBM1UlND9RR5jugL+RCMpwUYC1nQ68PDUbZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 348/464] qtnfmac: Missing platform_device_unregister() on error in qtnf_core_mac_alloc()
Date:   Mon, 17 Aug 2020 17:15:01 +0200
Message-Id: <20200817143850.440841711@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 141bc9abbbffa89d020957caa9ac4a61d0ef1e26 ]

Add the missing platform_device_unregister() before return from
qtnf_core_mac_alloc() in the error handling case.

Fixes: 616f5701f4ab ("qtnfmac: assign each wiphy to its own virtual platform device")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Sergey Matyukevich <geomatsi@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200730064910.37589-1-wanghai38@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index eea777f8acea5..6aafff9d4231b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -446,8 +446,11 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
 	}
 
 	wiphy = qtnf_wiphy_allocate(bus, pdev);
-	if (!wiphy)
+	if (!wiphy) {
+		if (pdev)
+			platform_device_unregister(pdev);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	mac = wiphy_priv(wiphy);
 
-- 
2.25.1



