Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6589029AE4F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753200AbgJ0N65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753197AbgJ0N6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:58:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD936218AC;
        Tue, 27 Oct 2020 13:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807135;
        bh=+WRVV83VWA1xH0FjRGSQDz2xwjF+59Y7OGYu8uAokuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIw3jUZOtihWNNIV2Djnt+gL8nVBPItH3gNjGfF+q43Jq+B4DVBi8v/pKacd8EKkO
         E4V97ThO0f8+ORjmmYsNyK8AkUrMV3VTR2y5hFB69d/8TMwHQbVfPG23jE1uTBU8M+
         hKFvy0OmhzlrI72QGYiMohyJ7iG/YU/8EZWTNX0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 028/112] ath9k: Fix potential out of bounds in ath9k_htc_txcompletion_cb()
Date:   Tue, 27 Oct 2020 14:48:58 +0100
Message-Id: <20201027134901.895161002@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 2705cd7558e718a7240c64eb0afb2edad5f8c190 ]

The value of "htc_hdr->endpoint_id" comes from skb->data so Smatch marks
it as untrusted so we have to check it before using it as an array
offset.

This is similar to a bug that syzkaller found in commit e4ff08a4d727
("ath9k: Fix use-after-free Write in ath9k_htc_rx_msg") so it is
probably a real issue.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200813141253.GA457408@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 1af216aa5adae..625823e45d8f0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -346,6 +346,8 @@ void ath9k_htc_txcompletion_cb(struct htc_target *htc_handle,
 
 	if (skb) {
 		htc_hdr = (struct htc_frame_hdr *) skb->data;
+		if (htc_hdr->endpoint_id >= ARRAY_SIZE(htc_handle->endpoint))
+			goto ret;
 		endpoint = &htc_handle->endpoint[htc_hdr->endpoint_id];
 		skb_pull(skb, sizeof(struct htc_frame_hdr));
 
-- 
2.25.1



