Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018BC29B753
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799487AbgJ0Pbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799483AbgJ0Pbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:31:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D82520728;
        Tue, 27 Oct 2020 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812703;
        bh=g5HYlZAFR8vdmZXgm+EELCOCg9TihOKXkvdXaIJmOJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0SQ8gROCRJzFSfM+iQMNLchAC+AT1t8rJYiEHD3tUQxC1cCc7vwjTrELduUw49Wj
         STyg7XB7BlUb7mOCHq7/qDseoRM1eXHTdktCznJO+6jCSrDg9IF6L3A84GTrmjsw7F
         WosnsJPNcstgPj9dOnvMs6vCxLpUFNfxisIxIOCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bo YU <tsu.yubo@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 301/757] ath11k: Add checked value for ath11k_ahb_remove
Date:   Tue, 27 Oct 2020 14:49:11 +0100
Message-Id: <20201027135504.679000066@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bo YU <tsu.yubo@gmail.com>

[ Upstream commit 80b892fc8a90e91498babf0f6817139e5ec64b5c ]

Return value form wait_for_completion_timeout should to be checked.

This is detected by Coverity: #CID:1464479 (CHECKED_RETURN)

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Bo YU <tsu.yubo@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200621095136.7xdbzkthoxuw2qow@debian.debian-2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 30092841ac464..a0314c1c84653 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -981,12 +981,16 @@ static int ath11k_ahb_probe(struct platform_device *pdev)
 static int ath11k_ahb_remove(struct platform_device *pdev)
 {
 	struct ath11k_base *ab = platform_get_drvdata(pdev);
+	unsigned long left;
 
 	reinit_completion(&ab->driver_recovery);
 
-	if (test_bit(ATH11K_FLAG_RECOVERY, &ab->dev_flags))
-		wait_for_completion_timeout(&ab->driver_recovery,
-					    ATH11K_AHB_RECOVERY_TIMEOUT);
+	if (test_bit(ATH11K_FLAG_RECOVERY, &ab->dev_flags)) {
+		left = wait_for_completion_timeout(&ab->driver_recovery,
+						   ATH11K_AHB_RECOVERY_TIMEOUT);
+		if (!left)
+			ath11k_warn(ab, "failed to receive recovery response completion\n");
+	}
 
 	set_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags);
 	cancel_work_sync(&ab->restart_work);
-- 
2.25.1



