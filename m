Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC93223A47D
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgHCM1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728574AbgHCM1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:27:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9684A204EC;
        Mon,  3 Aug 2020 12:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457657;
        bh=6neVmE4RuTPyO1WwkKuIkdjl/sl5fH6UJcth+i9Zpek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snljmb2yc4bDOubjbEqyslFjeF3rOALKIYOr/hsr/zqbLHBil6GNGvlTM1+AhYvfb
         QqHRRmvTCPF00SbsfK+25XnwYkPaRrE5/QsTlDOSocUrlNWmcoZ8dwv5zx6LAbp+UP
         FbBlxHRXiW466Eg/JUEoMDNDgoDUQFJx1hmoPq3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Ambure <aambure@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sathishkumar Muruganandam <murugana@codeaurora.org>
Subject: [PATCH 5.4 04/90] ath10k: enable transmit data ack RSSI for QCA9884
Date:   Mon,  3 Aug 2020 14:18:26 +0200
Message-Id: <20200803121857.760477726@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Ambure <aambure@codeaurora.org>

commit cc78dc3b790619aa05f22a86a9152986bd73698c upstream.

For all data packets transmitted, host gets htt tx completion event. Some QCA9984
firmware releases support WMI_SERVICE_TX_DATA_ACK_RSSI, which gives data
ack rssi values to host through htt event of data tx completion. Data ack rssi
values are valid if A0 bit is set in HTT rx message. So enable the feature also
for QCA9884.

Tested HW: QCA9984
Tested FW: 10.4-3.9.0.2-00044

Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
[kvalo@codeaurora.org: improve commit log]
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath10k/hw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -1145,6 +1145,7 @@ static bool ath10k_qca99x0_rx_desc_msdu_
 const struct ath10k_hw_ops qca99x0_ops = {
 	.rx_desc_get_l3_pad_bytes = ath10k_qca99x0_rx_desc_get_l3_pad_bytes,
 	.rx_desc_get_msdu_limit_error = ath10k_qca99x0_rx_desc_msdu_limit_error,
+	.is_rssi_enable = ath10k_htt_tx_rssi_enable,
 };
 
 const struct ath10k_hw_ops qca6174_ops = {


