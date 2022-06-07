Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A854541304
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357574AbiFGTzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358899AbiFGTxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:53:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3624D64BE1;
        Tue,  7 Jun 2022 11:23:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D244260DB7;
        Tue,  7 Jun 2022 18:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF419C385A2;
        Tue,  7 Jun 2022 18:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626181;
        bh=nJKABFV7L4RLPvBO5QH7DR8OColWYo8kBeH2aJhbCnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lc8E3I5FuHzPTdx1LIi/3lSfOHFP6J4pMUHo0vpHXdZzoxx6npkN3GGPZx2707if7
         1IL2qGrLKbdZ5TlfLwSRjnfcabpOnBjuHSCxxaCSTMq/vTvpzAh0pIptdFJQyweavp
         IkfBb2u+sFXvoJWeJUW9dhbOydrZZpJmYXHkLBOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 285/772] ath9k_htc: fix potential out of bounds access with invalid rxstatus->rs_keyix
Date:   Tue,  7 Jun 2022 18:57:57 +0200
Message-Id: <20220607164957.423222535@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 6a850a0bfa8a..a23eaca0326d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1016,6 +1016,14 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
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



