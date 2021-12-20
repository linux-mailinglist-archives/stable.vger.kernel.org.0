Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6D247AF00
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239471AbhLTPHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238143AbhLTPFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:05:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31062C09B136;
        Mon, 20 Dec 2021 06:52:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA6A4B80EDA;
        Mon, 20 Dec 2021 14:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC23C36AE7;
        Mon, 20 Dec 2021 14:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011977;
        bh=xaQeTRPsA6o2ZqnhQ9FSevdEeHBkcGDTartlODznr4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeFC3UM0duYJyxVeQfGywx16jvOTpgV8ePsw9UD2IY+IyavPiyJmZmgext/NgVdcA
         cVZB24502IPE5+8sv2qaTD/dgHVAch6FzDqDikq8EdJMT8LZdGcm3AHMr2tcLpEOQF
         yA7GmMGMdZtjbhh5PJtiatzieZwqPNp8Vo42/7zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.15 009/177] mac80211: mark TX-during-stop for TX in in_reconfig
Date:   Mon, 20 Dec 2021 15:32:39 +0100
Message-Id: <20211220143040.397246086@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit db7205af049d230e7e0abf61c1e74c1aab40f390 upstream.

Mark TXQs as having seen transmit while they were stopped if
we bail out of drv_wake_tx_queue() due to reconfig, so that
the queue wake after this will make them catch up. This is
particularly necessary for when TXQs are used for management
packets since those TXQs won't see a lot of traffic that'd
make them catch up later.

Cc: stable@vger.kernel.org
Fixes: 4856bfd23098 ("mac80211: do not call driver wake_tx_queue op during reconfig")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211129152938.4573a221c0e1.I0d1d5daea3089be3fc0dccc92991b0f8c5677f0c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/driver-ops.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1219,8 +1219,11 @@ static inline void drv_wake_tx_queue(str
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->txq.vif);
 
-	if (local->in_reconfig)
+	/* In reconfig don't transmit now, but mark for waking later */
+	if (local->in_reconfig) {
+		set_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txq->flags);
 		return;
+	}
 
 	if (!check_sdata_in_driver(sdata))
 		return;


