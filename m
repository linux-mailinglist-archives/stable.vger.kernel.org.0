Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4473B3A9A0
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfFIRMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387824AbfFIRAU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:00:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87C1C204EC;
        Sun,  9 Jun 2019 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099620;
        bh=l14EGSnDbb64xKDaYsy1iHuRBQwmsC1vjxJQ15nK/t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUin5fvQLpl5Pl4dL98IjwUvv1gbhPDDgfJkSojg9NKtbpRWjopnP495EzsATdVVm
         LkPfYThHObKvUoi3PXH/GWlFCWDAnxcUhinDaZXiR69JrC03B74irL4Xqxh3Z0l3Dm
         PxS7hVjMXgqXmuDESrVcFbvviTkdxdFD4jmP/n/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 106/241] net: cw1200: fix a NULL pointer dereference
Date:   Sun,  9 Jun 2019 18:40:48 +0200
Message-Id: <20190609164150.853212330@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
 drivers/net/wireless/cw1200/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/cw1200/main.c b/drivers/net/wireless/cw1200/main.c
index 0e51e27d2e3f1..317daa968e037 100644
--- a/drivers/net/wireless/cw1200/main.c
+++ b/drivers/net/wireless/cw1200/main.c
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



