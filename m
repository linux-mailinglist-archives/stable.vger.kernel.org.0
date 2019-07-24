Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CE673D7E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbfGXURf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728467AbfGXTuF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:50:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C031205C9;
        Wed, 24 Jul 2019 19:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997803;
        bh=zYbnSIlh1CYPwa/rYl08boDxb02DeloIueOXb7BDvdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK1NseNCFMEZ5k2ono6U74DYzh7BYcZsyvy/7IeupQCn7t0bUvNfawrYXQe8qoOGS
         3oxAxdfUjFqNZsqRt9mPOYpE4BUMTNbuuKzop46PXgxSYqbU2orqG2izfAiYmljvO1
         j1e2SDIsorBGrfwi/ZS5O//IpaGHZDnI6AreK6MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 148/371] ath10k: fix PCIE device wake up failed
Date:   Wed, 24 Jul 2019 21:18:20 +0200
Message-Id: <20190724191736.291919930@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 011d4111c8c602ea829fa4917af1818eb0500a90 ]

Observed PCIE device wake up failed after ~120 iterations of
soft-reboot test. The error message is
"ath10k_pci 0000:01:00.0: failed to wake up device : -110"

The call trace as below:
ath10k_pci_probe -> ath10k_pci_force_wake -> ath10k_pci_wake_wait ->
ath10k_pci_is_awake

Once trigger the device to wake up, we will continuously check the RTC
state until it returns RTC_STATE_V_ON or timeout.

But for QCA99x0 chips, we use wrong value for RTC_STATE_V_ON.
Occasionally, we get 0x7 on the fist read, we thought as a failure
case, but actually is the right value, also verified with the spec.
So fix the issue by changing RTC_STATE_V_ON from 0x5 to 0x7, passed
~2000 iterations.

Tested HW: QCA9984

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index ad082b7d7643..b242085c3c16 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -158,7 +158,7 @@ const struct ath10k_hw_values qca6174_values = {
 };
 
 const struct ath10k_hw_values qca99x0_values = {
-	.rtc_state_val_on		= 5,
+	.rtc_state_val_on		= 7,
 	.ce_count			= 12,
 	.msi_assign_ce_max		= 12,
 	.num_target_ce_config_wlan	= 10,
-- 
2.20.1



