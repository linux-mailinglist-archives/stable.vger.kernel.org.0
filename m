Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C85B29B70F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798586AbgJ0P25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798185AbgJ0P0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:26:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BD4820657;
        Tue, 27 Oct 2020 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812384;
        bh=y2X8Rlzg/9+h3mtkY/LayOwdA5+JyHTtV2Uy9gV+c5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hI+t6J0VJE8cEo8KcI/XUl/NvaB/nVLPAGTRqs5DtguZG7RcdhEBj+rpiLm4L9Azo
         KYYHRX658bsvIfEZMLL0gYjN7EqFKx3eP9vUXNy5QBomYEs/ljIDHUSRmtWKUd4Skn
         FggPlhgl0lWkJQON6verOzi9XIzRWvajY6orLtV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 191/757] ath9k: Fix potential out of bounds in ath9k_htc_txcompletion_cb()
Date:   Tue, 27 Oct 2020 14:47:21 +0100
Message-Id: <20201027135459.575413239@linuxfoundation.org>
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
index d2e062eaf5614..510e61e97dbcb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -339,6 +339,8 @@ void ath9k_htc_txcompletion_cb(struct htc_target *htc_handle,
 
 	if (skb) {
 		htc_hdr = (struct htc_frame_hdr *) skb->data;
+		if (htc_hdr->endpoint_id >= ARRAY_SIZE(htc_handle->endpoint))
+			goto ret;
 		endpoint = &htc_handle->endpoint[htc_hdr->endpoint_id];
 		skb_pull(skb, sizeof(struct htc_frame_hdr));
 
-- 
2.25.1



