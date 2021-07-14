Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B313C80EC
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 11:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbhGNJG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 05:06:28 -0400
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:51188 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbhGNJG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 05:06:28 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 16E93QIr023511; Wed, 14 Jul 2021 18:03:26 +0900
X-Iguazu-Qid: 2wHHa7GsMtIe1llYCw
X-Iguazu-QSIG: v=2; s=0; t=1626253406; q=2wHHa7GsMtIe1llYCw; m=m62j9VI+aokeQPcnPuJtz59nsewXkwecuT6CTGyd890=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1113) id 16E93PKh012148
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Jul 2021 18:03:25 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id 6C3C21000C3;
        Wed, 14 Jul 2021 18:03:25 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 16E93Pco014606;
        Wed, 14 Jul 2021 18:03:25 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 5.10.y] ath11k: unlock on error path in ath11k_mac_op_add_interface()
Date:   Wed, 14 Jul 2021 18:03:21 +0900
X-TSB-HOP: ON
Message-Id: <20210714090321.3388341-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 59ec8e2fa5aaed6afd18d5362dc131aab92406e7 upstream.

These error paths need to drop the &ar->conf_mutex before returning.

Fixes: 690ace20ff79 ("ath11k: peer delete synchronization with firmware")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/X85sVGVP/0XvlrEJ@mwanda
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/net/wireless/ath/ath11k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index e9e6b0c4de220a..7b9acb265a5628 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4597,13 +4597,13 @@ static int ath11k_mac_op_add_interface(struct ieee80211_hw *hw,
 		if (ret) {
 			ath11k_warn(ar->ab, "failed to delete peer vdev_id %d addr %pM\n",
 				    arvif->vdev_id, vif->addr);
-			return ret;
+			goto err;
 		}
 
 		ret = ath11k_wait_for_peer_delete_done(ar, arvif->vdev_id,
 						       vif->addr);
 		if (ret)
-			return ret;
+			goto err;
 
 		ar->num_peers--;
 	}
-- 
2.32.0


