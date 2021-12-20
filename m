Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD3047AEFE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238638AbhLTPHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241503AbhLTPFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:05:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93834C09B12E;
        Mon, 20 Dec 2021 06:52:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C461B80EE6;
        Mon, 20 Dec 2021 14:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD2BC36AE9;
        Mon, 20 Dec 2021 14:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011974;
        bh=RJvSSDAIigqWiK2tGlbtqxU/GtFJxKGRfqIyvfliOho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHwLdpjFlFatDB8DgC/0EerMwurIT55cwTHLcYhM16t+nPUkwXOOzFHfmarQpTys6
         bVTCHEgLKixjMQms4vUzQX1QuaWcgPYysEiQCczI8choSt+UcyNVAPCzvo63bCBmVQ
         S9EpM27jARiyoEcGakwypMIk3KEzYbG3zfjGSMgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 008/177] mac80211: fix regression in SSN handling of addba tx
Date:   Mon, 20 Dec 2021 15:32:38 +0100
Message-Id: <20211220143040.357039389@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 73111efacd3c6d9e644acca1d132566932be8af0 upstream.

Some drivers that do their own sequence number allocation (e.g. ath9k) rely
on being able to modify params->ssn on starting tx ampdu sessions.
This was broken by a change that modified it to use sta->tid_seq[tid] instead.

Cc: stable@vger.kernel.org
Fixes: 31d8bb4e07f8 ("mac80211: agg-tx: refactor sending addba")
Reported-by: Eneas U de Queiroz <cotequeiroz@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20211124094024.43222-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/agg-tx.c   |    4 ++--
 net/mac80211/sta_info.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -480,8 +480,7 @@ static void ieee80211_send_addba_with_ti
 
 	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
-				     tid_tx->dialog_token,
-				     sta->tid_seq[tid] >> 4,
+				     tid_tx->dialog_token, tid_tx->ssn,
 				     buf_size, tid_tx->timeout);
 
 	WARN_ON(test_and_set_bit(HT_AGG_STATE_SENT_ADDBA, &tid_tx->state));
@@ -523,6 +522,7 @@ void ieee80211_tx_ba_session_handle_star
 
 	params.ssn = sta->tid_seq[tid] >> 4;
 	ret = drv_ampdu_action(local, sdata, &params);
+	tid_tx->ssn = params.ssn;
 	if (ret == IEEE80211_AMPDU_TX_START_DELAY_ADDBA) {
 		return;
 	} else if (ret == IEEE80211_AMPDU_TX_START_IMMEDIATE) {
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -199,6 +199,7 @@ struct tid_ampdu_tx {
 	u8 stop_initiator;
 	bool tx_stop;
 	u16 buf_size;
+	u16 ssn;
 
 	u16 failed_bar_ssn;
 	bool bar_pending;


