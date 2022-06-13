Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E12054930A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352431AbiFMLQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352571AbiFMLOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:14:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A4436312;
        Mon, 13 Jun 2022 03:36:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85A9561021;
        Mon, 13 Jun 2022 10:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E2DC34114;
        Mon, 13 Jun 2022 10:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116591;
        bh=7bYUv5/HbSb7PZkFLsP/eAj3Kb6ADnWQ5Tly32igEME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q25mvf/hjwdI9opkTcrVrIqnzoiVco08MAE0uXvsk8cc8iLfibq0ZSgis9IzwABO1
         lQBfDcmrGjxiXgbQdvTv4Ex/H/puk0a8U7nsgrNxylFCuh8XusVQslAngRAyKYiG05
         57Va3l4phHo728yvNp14nkK/KH2jkcUbwS2iVvyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/411] ath9k_htc: fix potential out of bounds access with invalid rxstatus->rs_keyix
Date:   Mon, 13 Jun 2022 12:06:17 +0200
Message-Id: <20220613094931.795515265@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 2dc509305cf956381532792cb8dceef2b1504765 ]

The "rxstatus->rs_keyix" eventually gets passed to test_bit() so we need to
ensure that it is within the bitmap.

drivers/net/wireless/ath/ath9k/common.c:46 ath9k_cmn_rx_accept()
error: passing untrusted data 'rx_stats->rs_keyix' to 'test_bit()'

Fixes: 4ed1a8d4a257 ("ath9k_htc: use ath9k_cmn_rx_accept")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220409061225.GA5447@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 628f45c8c06f..eeaf63de71bf 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1005,6 +1005,14 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		goto rx_next;
 	}
 
+	if (rxstatus->rs_keyix >= ATH_KEYMAX &&
+	    rxstatus->rs_keyix != ATH9K_RXKEYIX_INVALID) {
+		ath_dbg(common, ANY,
+			"Invalid keyix, dropping (keyix: %d)\n",
+			rxstatus->rs_keyix);
+		goto rx_next;
+	}
+
 	/* Get the RX status information */
 
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
-- 
2.35.1



