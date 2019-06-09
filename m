Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBDB3A98D
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbfFIRCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730057AbfFIRCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:02:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5294C206C3;
        Sun,  9 Jun 2019 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099743;
        bh=5P1Tj/4D3AY3VTfLA9mofZvhkqLHBaa5LatwP7tZJVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxgO0rEN8uoWKINothJBurZjLa9CgCBfgZgLZvwX0/V6PO5BOgkpy9cxlx2ZVddBr
         X8ponlCdORFsgn/+J77uukcyRpIUeAkASg60wM1vT8jIRMlVNKD7A+o62jU2XZt9Y1
         Gg5IlhdvE9BbvO6NxN7InDacC/vLFRgHbWCeNqnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 151/241] rtlwifi: fix a potential NULL pointer dereference
Date:   Sun,  9 Jun 2019 18:41:33 +0200
Message-Id: <20190609164152.133278833@linuxfoundation.org>
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

[ Upstream commit 765976285a8c8db3f0eb7f033829a899d0c2786e ]

In case alloc_workqueue fails, the fix reports the error and
returns to avoid NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index aab752328c269..5013d8c1d4a60 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -466,6 +466,11 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
 	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
+	if (unlikely(!rtlpriv->works.rtl_wq)) {
+		pr_err("Failed to allocate work queue\n");
+		return;
+	}
+
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
-- 
2.20.1



