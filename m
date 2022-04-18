Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA13450518A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbiDRMfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239263AbiDRMco (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:32:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B07126112;
        Mon, 18 Apr 2022 05:24:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E688860FD7;
        Mon, 18 Apr 2022 12:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA47EC385A7;
        Mon, 18 Apr 2022 12:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284664;
        bh=z/Mk8EdyPU3wldlUmqLKlaYC3CgDe+9Ov5RINbFMnyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llNipg52terkyTnp1ZXNXFq8rmAUPJuCbCg1gaWG5SmcWgoB/9YPzRn1H1gqttN26
         rJtXVBdlucWCLE7/5OoR4aQVwsWEL4bqw+fplhUeKU8qK3KGMguxd9nLFotG0MK9IH
         YdPCezhiXgsowTTqUBCmkw18KWsQmrXs3IucC6/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bagas Sanjaya <bagasdotme@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.17 189/219] ath9k: Properly clear TX status area before reporting to mac80211
Date:   Mon, 18 Apr 2022 14:12:38 +0200
Message-Id: <20220418121212.166178489@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@toke.dk>

commit 037250f0a45cf9ecf5b52d4b9ff8eadeb609c800 upstream.

The ath9k driver was not properly clearing the status area in the
ieee80211_tx_info struct before reporting TX status to mac80211. Instead,
it was manually filling in fields, which meant that fields introduced later
were left as-is.

Conveniently, mac80211 actually provides a helper to zero out the status
area, so use that to make sure we zero everything.

The last commit touching the driver function writing the status information
seems to have actually been fixing an issue that was also caused by the
area being uninitialised; but it only added clearing of a single field
instead of the whole struct. That is now redundant, though, so revert that
commit and use it as a convenient Fixes tag.

Fixes: cc591d77aba1 ("ath9k: Make sure to zero status.tx_time before reporting TX status")
Reported-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220330164409.16645-1-toke@toke.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2553,6 +2553,8 @@ static void ath_tx_rc_status(struct ath_
 	struct ath_hw *ah = sc->sc_ah;
 	u8 i, tx_rateindex;
 
+	ieee80211_tx_info_clear_status(tx_info);
+
 	if (txok)
 		tx_info->status.ack_signal = ts->ts_rssi;
 
@@ -2595,9 +2597,6 @@ static void ath_tx_rc_status(struct ath_
 	}
 
 	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
-
-	/* we report airtime in ath_tx_count_airtime(), don't report twice */
-	tx_info->status.tx_time = 0;
 }
 
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)


