Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFED2E4132
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439804AbgL1OMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:12:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439799AbgL1OMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA57020731;
        Mon, 28 Dec 2020 14:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164688;
        bh=2Tw21TPD1Uwl+bEFsk0SfZcRs10gCBw9jO8JwQi/jL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SV1o7yKVs7eSfxgqV9jFxHuw1hSV81nbBye3hLyqrTxBmM+aF5fxxKNIoXscqsc0d
         woAqNwPTrJ4F8untR8m46LjIlxSOnt8mCbWYyR0gj7k243W9EMlPYXqGLDIBxDUM7w
         ec+HfHAmDHsw126bdJPY8piPvcBUPmsyIgFXJ6Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/717] ath11k: Fix an error handling path
Date:   Mon, 28 Dec 2020 13:44:20 +0100
Message-Id: <20201228125033.556096472@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e7bcc145bcd035e56da7b97b033c463b32a5ff80 ]

If 'kzalloc' fails, we must return an error code.

While at it, remove a useless initialization of 'err' which could hide the
issue.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201122173943.1366167-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index c2b1651582259..99a88ca83deaa 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1585,15 +1585,17 @@ static int ath11k_qmi_fw_ind_register_send(struct ath11k_base *ab)
 	struct qmi_wlanfw_ind_register_resp_msg_v01 *resp;
 	struct qmi_handle *handle = &ab->qmi.handle;
 	struct qmi_txn txn;
-	int ret = 0;
+	int ret;
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
 	resp = kzalloc(sizeof(*resp), GFP_KERNEL);
-	if (!resp)
+	if (!resp) {
+		ret = -ENOMEM;
 		goto resp_out;
+	}
 
 	req->client_id_valid = 1;
 	req->client_id = QMI_WLANFW_CLIENT_ID;
-- 
2.27.0



