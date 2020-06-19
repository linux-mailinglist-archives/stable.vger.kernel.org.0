Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42635201483
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390943AbgFSQLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391338AbgFSPFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:05:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EFBA2158C;
        Fri, 19 Jun 2020 15:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579142;
        bh=bS5W2ONyw/SXIa/fkGa6ec0BYeEBMqk33GK3nELN/DA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpIclVkIupoHiyI6hGCOk/cFozCQa1MyShTqUXG/HaTVovWlsqUkA+FVmlQMMSFlo
         Mm+upuCftuMGA5yxh+0Uxnp4OcbyuGF8+sKbbc3FW5d3YUJHL61yGRsek6Bzsg9d7O
         iVzXxqODSgin4ypP39JBJ2IL78KTAhQJLjWfyz8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Govindaraj Saminathan <gsamin@codeaurora.org>,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/261] ath10k: Fix the race condition in firmware dump work queue
Date:   Fri, 19 Jun 2020 16:30:14 +0200
Message-Id: <20200619141650.049101796@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maharaja Kennadyrajan <mkenna@codeaurora.org>

[ Upstream commit 3d1c60460fb2823a19ead9e6ec8f184dd7271aa7 ]

There is a race condition, when the user writes 'hw-restart' and
'hard' in the simulate_fw_crash debugfs file without any delay.
In the above scenario, the firmware dump work queue(scheduled by
'hard') should be handled gracefully, while the target is in the
'hw-restart'.

Tested HW: QCA9984
Tested FW: 10.4-3.9.0.2-00044

Co-developed-by: Govindaraj Saminathan <gsamin@codeaurora.org>
Signed-off-by: Govindaraj Saminathan <gsamin@codeaurora.org>
Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1585213077-28439-1-git-send-email-mkenna@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 0a727502d14c..fd49d3419e79 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2074,6 +2074,7 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	ath10k_pci_irq_sync(ar);
 	napi_synchronize(&ar->napi);
 	napi_disable(&ar->napi);
+	cancel_work_sync(&ar_pci->dump_work);
 
 	/* Most likely the device has HTT Rx ring configured. The only way to
 	 * prevent the device from accessing (and possible corrupting) host
-- 
2.25.1



