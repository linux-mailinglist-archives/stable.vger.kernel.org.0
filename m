Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C3F3C4E0F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243352AbhGLHQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238090AbhGLHPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:15:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81471611ED;
        Mon, 12 Jul 2021 07:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073951;
        bh=A82D2gszUA5X4xBJWxfKK5uB5nALhnH7McO6HvpiHD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oal9p/P1VMzaYSlJDHFLavMtHZ094IY0O6DoX0Xj61pycAJbv9nzdRKqOGiPxmJhj
         7GKZd7o8snKhi/nTNAAJ6gP3yEx0/mYFRKIguo8q2JMPF9zsuVxUECYhYvdmbinYxF
         f1W5DzqS/w9cB3bTE8Be1l7cSeSxbaajdvcoWTdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 414/700] ath11k: Fix an error handling path in ath11k_core_fetch_board_data_api_n()
Date:   Mon, 12 Jul 2021 08:08:17 +0200
Message-Id: <20210712061020.425202307@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 350b7913622c..b55b6289eeb1 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -445,7 +445,8 @@ static int ath11k_core_fetch_board_data_api_n(struct ath11k_base *ab,
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



