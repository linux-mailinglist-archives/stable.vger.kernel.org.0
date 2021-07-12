Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175923C53C3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348604AbhGLHzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350654AbhGLHvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1008A61C34;
        Mon, 12 Jul 2021 07:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076034;
        bh=d2tuwCrxgQbdvyq1qFQqBsST9Y/jzHW45UtqE3lYI3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shyRx8OErc75hZPH/PwROxvgKWgpAnuer42dER2MEIkj4zNgenGUbRUUNOP0vGq0P
         ATrWnGYCPMYJWMvWNtxf73fIrYwN/bKhZawoKMXI6epXRVYv0S1cDZ/diihNEtenXU
         eHBO+GXgzHDoy/ZDyYbTparAq5QC0lzbCEuSe7Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 468/800] ath11k: Fix an error handling path in ath11k_core_fetch_board_data_api_n()
Date:   Mon, 12 Jul 2021 08:08:11 +0200
Message-Id: <20210712061016.958098688@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 515bda1d1e51c64edf2a384a58801f85a80a3f2d ]

All error paths but this one 'goto err' in order to release some
resources.
Fix this.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/e959eb544f3cb04258507d8e25a6f12eab126bde.1621676864.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 77ce3347ab86..595e83fe0990 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -488,7 +488,8 @@ static int ath11k_core_fetch_board_data_api_n(struct ath11k_base *ab,
 		if (len < ALIGN(ie_len, 4)) {
 			ath11k_err(ab, "invalid length for board ie_id %d ie_len %zu len %zu\n",
 				   ie_id, ie_len, len);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err;
 		}
 
 		switch (ie_id) {
-- 
2.30.2



