Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C4D29B90F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802174AbgJ0Ppx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1747858AbgJ0P3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:29:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 288CC22202;
        Tue, 27 Oct 2020 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812543;
        bh=TMDJNU3prP1LHMZYXBj9NyDmrYuCB89SESxxYVidrnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4oojQKCjDAba05mj33SD7gFI9QMUibN+tYjdlLCAfMQB4LCVEjwhoiNXFq8hRFhw
         r/KQyIDPfv3shNJB2zcsD/4UlXFKf2luBHHL1o/0pRbHHjry3Xwh1HLpwST9r22Y1N
         cxOXCkNzDFXw1N3jkZSszpeWu75QSh/Id4ck2tA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 215/757] staging: wfx: fix frame reordering
Date:   Tue, 27 Oct 2020 14:47:45 +0100
Message-Id: <20201027135500.698735473@linuxfoundation.org>
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

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 7373f31c4b5e382e5117b71a6792e8005c45aa50 ]

When mac80211 debug is enabled, the trace below appears:

    [60744.340037] wlan0: Rx A-MPDU request on aa:bb:cc:97:60:24 tid 0 result -524

This imply that ___ieee80211_start_rx_ba_session will prematurely exit
and frame reordering won't be enabled.

Fixes: e5da5fbd77411 ("staging: wfx: fix CCMP/TKIP replay protection")
Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200825085828.399505-7-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/sta.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
index 4e30ab17a93d4..7dace7c17bf5c 100644
--- a/drivers/staging/wfx/sta.c
+++ b/drivers/staging/wfx/sta.c
@@ -682,15 +682,16 @@ int wfx_ampdu_action(struct ieee80211_hw *hw,
 		     struct ieee80211_vif *vif,
 		     struct ieee80211_ampdu_params *params)
 {
-	/* Aggregation is implemented fully in firmware,
-	 * including block ack negotiation. Do not allow
-	 * mac80211 stack to do anything: it interferes with
-	 * the firmware.
-	 */
-
-	/* Note that we still need this function stubbed. */
-
-	return -ENOTSUPP;
+	// Aggregation is implemented fully in firmware
+	switch (params->action) {
+	case IEEE80211_AMPDU_RX_START:
+	case IEEE80211_AMPDU_RX_STOP:
+		// Just acknowledge it to enable frame re-ordering
+		return 0;
+	default:
+		// Leave the firmware doing its business for tx aggregation
+		return -ENOTSUPP;
+	}
 }
 
 int wfx_add_chanctx(struct ieee80211_hw *hw,
-- 
2.25.1



