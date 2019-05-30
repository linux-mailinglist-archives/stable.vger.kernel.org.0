Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 369272EDF1
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbfE3Dmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732454AbfE3DVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:21:07 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC9A2496D;
        Thu, 30 May 2019 03:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186467;
        bh=35VzWg7XzJEd309TcxEQUOQeVMVEZlIgONPaFW+jbAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+FT1DSSqAxrZeBaFFHgPNzsehPntMpZkYFPncKlueiLoXcJmp1KSXCVotxSe1nQ5
         fRg1ZZ5b0jNJbxcfqGOfwW+2DZ2AWSrjYW/PU/sfGTB7bOBuJ713s+8UahJedsn+mg
         jeMru5iBpM+TWCkxRYAgIZQDJE1cMNWvwDdC6LRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 092/128] rtlwifi: fix a potential NULL pointer dereference
Date:   Wed, 29 May 2019 20:07:04 -0700
Message-Id: <20190530030451.285057779@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
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
index 4ac928bf1f8e6..7de18ed10db8e 100644
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



