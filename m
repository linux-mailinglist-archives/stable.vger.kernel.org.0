Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 158A62F141
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfE3ELY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730823AbfE3DQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:49 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9964B24632;
        Thu, 30 May 2019 03:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186208;
        bh=2CHFQ1yD2ZdQPUiiceM3lTdpPGv4jFPq8lmnLRRah/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euEQbqjS5ioxOnG2hf9K2YZMFQnJrmgzXu3noAZdSyqfDsapXeJz7vDUm9ShNBEbp
         7UueDW2fLav3nj5LS4ryoA8e/a0W01E47aVNltnDDf+smchzC32XYsP2Yv606m80W5
         WXevp7JGvbCkme/CO6nIIz0EADcHNmgIr3mwz3sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/276] net: cw1200: fix a NULL pointer dereference
Date:   Wed, 29 May 2019 20:04:16 -0700
Message-Id: <20190530030532.253977176@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0ed2a005347400500a39ea7c7318f1fea57fb3ca ]

In case create_singlethread_workqueue fails, the fix free the
hardware and returns NULL to avoid NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/st/cw1200/main.c b/drivers/net/wireless/st/cw1200/main.c
index 90dc979f260b6..c1608f0bf6d01 100644
--- a/drivers/net/wireless/st/cw1200/main.c
+++ b/drivers/net/wireless/st/cw1200/main.c
@@ -345,6 +345,11 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 	mutex_init(&priv->wsm_cmd_mux);
 	mutex_init(&priv->conf_mutex);
 	priv->workqueue = create_singlethread_workqueue("cw1200_wq");
+	if (!priv->workqueue) {
+		ieee80211_free_hw(hw);
+		return NULL;
+	}
+
 	sema_init(&priv->scan.lock, 1);
 	INIT_WORK(&priv->scan.work, cw1200_scan_work);
 	INIT_DELAYED_WORK(&priv->scan.probe_work, cw1200_probe_work);
-- 
2.20.1



