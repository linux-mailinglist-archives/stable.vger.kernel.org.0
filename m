Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E6C2A5511
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388824AbgKCVLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:11:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388817AbgKCVLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:11:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB9D206B5;
        Tue,  3 Nov 2020 21:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437865;
        bh=I7PGOYhBfUZgSKKfzaq/wJbiiKelv4zn+DLyl1ENi24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9aK8gU0QM+zRAUWKC3u85P9tn8cE2Z6m/bEhlIZF+sWOpGoI4XQW///JtkMVhNb6
         f2nAZF6YRp7Gj0i/y+MTtrBMg3dTpJr3V5cAXt1K0GrCJcSnTdEyX1EhBvWVTXjaHm
         fbCG3VN3A/JLTwmjUvx6lU5ite+nykRpDDqlM3+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 026/125] ath10k: start recovery process when payload length exceeds max htc length for sdio
Date:   Tue,  3 Nov 2020 21:36:43 +0100
Message-Id: <20201103203200.511553836@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

[ Upstream commit 2fd3c8f34d08af0a6236085f9961866ad92ef9ec ]

When simulate random transfer fail for sdio write and read, it happened
"payload length exceeds max htc length" and recovery later sometimes.

Test steps:
1. Add config and update kernel:
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y

2. Run simulate fail:
cd /sys/kernel/debug/mmc1/fail_mmc_request
echo 10 > probability
echo 10 > times # repeat until hitting issues

3. It happened payload length exceeds max htc length.
[  199.935506] ath10k_sdio mmc1:0001:1: payload length 57005 exceeds max htc length: 4088
....
[  264.990191] ath10k_sdio mmc1:0001:1: payload length 57005 exceeds max htc length: 4088

4. after some time, such as 60 seconds, it start recovery which triggered
by wmi command timeout for periodic scan.
[  269.229232] ieee80211 phy0: Hardware restart was requested
[  269.734693] ath10k_sdio mmc1:0001:1: device successfully recovered

The simulate fail of sdio is not a real sdio transter fail, it only
set an error status in mmc_should_fail_request after the transfer end,
actually the transfer is success, then sdio_io_rw_ext_helper will
return error status and stop transfer the left data. For example,
the really RX len is 286 bytes, then it will split to 2 blocks in
sdio_io_rw_ext_helper, one is 256 bytes, left is 30 bytes, if the
first 256 bytes get an error status by mmc_should_fail_request,then
the left 30 bytes will not read in this RX operation. Then when the
next RX arrive, the left 30 bytes will be considered as the header
of the read, the top 4 bytes of the 30 bytes will be considered as
lookaheads, but actually the 4 bytes is not the lookaheads, so the len
from this lookaheads is not correct, it exceeds max htc length 4088
sometimes. When happened exceeds, the buffer chain is not matched between
firmware and ath10k, then it need to start recovery ASAP. Recently then
recovery will be started by wmi command timeout, but it will be long time
later, for example, it is 60+ seconds later from the periodic scan, if
it does not have periodic scan, it will be longer.

Start recovery when it happened "payload length exceeds max htc length"
will be reasonable.

This patch only effect sdio chips.

Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00029.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200108031957.22308-3-wgong@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index fef313099e08a..34e8b4344f40a 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -561,6 +561,10 @@ static int ath10k_sdio_mbox_rx_alloc(struct ath10k *ar,
 				    le16_to_cpu(htc_hdr->len),
 				    ATH10K_HTC_MBOX_MAX_PAYLOAD_LENGTH);
 			ret = -ENOMEM;
+
+			queue_work(ar->workqueue, &ar->restart_work);
+			ath10k_warn(ar, "exceeds length, start recovery\n");
+
 			goto err;
 		}
 
-- 
2.27.0



