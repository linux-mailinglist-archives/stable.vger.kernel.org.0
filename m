Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362955052E2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240485AbiDRMxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240084AbiDRMw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:52:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67ABD2D1FE;
        Mon, 18 Apr 2022 05:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F27A7611D1;
        Mon, 18 Apr 2022 12:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B61C385A1;
        Mon, 18 Apr 2022 12:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285266;
        bh=epETK8RMdi/qHauVcO3oyZYPjLD8fCCYT0QAkxHcJgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RM7sZPCP+YmyC1ZMsz0/2JpdGU/94X8psuasxV3hid7fFoKFVrTc0y1TjVUshFFEJ
         FzCFVILrZXHyk1ETxjtx5/DfzzR11Hw2A++134N7bw5YpzgBADDex5nWym95YDgH2m
         tgDEQ7Q0EGexp2ezdqshHOjDEwJhcClhukfIB/x0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bagas Sanjaya <bagasdotme@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 154/189] ath9k: Properly clear TX status area before reporting to mac80211
Date:   Mon, 18 Apr 2022 14:12:54 +0200
Message-Id: <20220418121206.392831461@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
@@ -2512,6 +2512,8 @@ static void ath_tx_rc_status(struct ath_
 	struct ath_hw *ah = sc->sc_ah;
 	u8 i, tx_rateindex;
 
+	ieee80211_tx_info_clear_status(tx_info);
+
 	if (txok)
 		tx_info->status.ack_signal = ts->ts_rssi;
 
@@ -2554,9 +2556,6 @@ static void ath_tx_rc_status(struct ath_
 	}
 
 	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
-
-	/* we report airtime in ath_tx_count_airtime(), don't report twice */
-	tx_info->status.tx_time = 0;
 }
 
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)


