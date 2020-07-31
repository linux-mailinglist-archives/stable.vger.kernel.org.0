Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84ABE234385
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 11:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732357AbgGaJpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 05:45:09 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:23769 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732281AbgGaJpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 05:45:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596188708; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=SyM3bUbcZRvkDLS/uRQdPaWfBMxsdLSFCFADWC6HkKY=; b=qZtSatIZLd+zyXzrIpKk62nbsjC7AyCS3hIFk+arUE+dLxyc7iuEyIvoHw0qcpgXOusrC+6v
 2UOO8tQjP55Lbdj12wF1w/u96PqZwGzNsPAHFhPw/T6bgy9PejWZDWiepQoazHKf9vcRAr9b
 9voBdXi0OP8PM+ybelZH5UkXMm4=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n17.prod.us-west-2.postgun.com with SMTP id
 5f23e822849144fbcb1e4ad4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 31 Jul 2020 09:45:06
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CB658C433CA; Fri, 31 Jul 2020 09:45:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from ironmsg01-blr.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: murugana)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2A9A0C433C9;
        Fri, 31 Jul 2020 09:45:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2A9A0C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=murugana@codeaurora.org
From:   Sathishkumar Muruganandam <murugana@codeaurora.org>
To:     stable@vger.kernel.org
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sathishkumar Muruganandam <murugana@codeaurora.org>
Subject: [PATCH] ath10k: enable transmit data ack RSSI for QCA9884
Date:   Fri, 31 Jul 2020 15:14:16 +0530
Message-Id: <20200731094416.5172-1-murugana@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Ambure <aambure@codeaurora.org>

commit cc78dc3b790619aa05f22a86a9152986bd73698c upstream.

This commit fixes the regression caused by
commit 6ddc3860a566 ("ath10k: add support for ack rssi value of data tx packets")
in linux-5.4.y branch.

ath10k_is_rssi_enable() always returns 0 for QCA9984 and this will cause
the ppdu_info_offset to hold invalid value in ath10k_htt_rx_tx_compl_ind().

This leads to CE corruption for HTC endpoints to cause WMI command failures
with insufficient HTC credits. Below warnings are seen due to beacon
command failure in QCA9984.

[  675.939638] ath10k_pci 0000:03:00.0: SWBA overrun on vdev 0, skipped old beacon
[  675.947828] ath10k_pci 0000:04:00.0: SWBA overrun on vdev 1, skipped old beacon

Tested HW: QCA9984
Tested FW: 10.4-3.10-00047
Tested Kernel version: 5.4.22

Fixes: 6ddc3860a566 ("ath10k: add support for ack rssi value of data tx packets")
Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
[kvalo@codeaurora.org: improve commit log]
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index c415e971735b..004af89a02b8 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -1145,6 +1145,7 @@ static bool ath10k_qca99x0_rx_desc_msdu_limit_error(struct htt_rx_desc *rxd)
 const struct ath10k_hw_ops qca99x0_ops = {
 	.rx_desc_get_l3_pad_bytes = ath10k_qca99x0_rx_desc_get_l3_pad_bytes,
 	.rx_desc_get_msdu_limit_error = ath10k_qca99x0_rx_desc_msdu_limit_error,
+	.is_rssi_enable = ath10k_htt_tx_rssi_enable,
 };
 
 const struct ath10k_hw_ops qca6174_ops = {
-- 
2.17.1

