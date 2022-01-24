Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571AB498CC2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346537AbiAXTY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345170AbiAXTWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:22:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4BDC02B85F;
        Mon, 24 Jan 2022 11:08:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A5C360917;
        Mon, 24 Jan 2022 19:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1005CC340E5;
        Mon, 24 Jan 2022 19:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051321;
        bh=gWcyayrhV3kl6VcZyrQy5mSYOYdJGgNgI7BXa77Y0EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIWSYVQbtlRT5CS5ShNRqefhQeXAhC7tG7FLEMlZMEKfhU+TxAQKpnjLJ95/43w63
         KsxVRUp4WpZuprnOwuGBMOrgVfws/NzEvPPKorG2943Utyf5dGX/ed1Umcmz9ETrmD
         b9q9TA3O5pbqMk1lq8LbGKiElioLTs8Qo/xeoJMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 125/186] mac80211: allow non-standard VHT MCS-10/11
Date:   Mon, 24 Jan 2022 19:43:20 +0100
Message-Id: <20220124183941.131597974@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 04be6d337d37400ad5b3d5f27ca87645ee5a18a3 ]

Some AP can possibly try non-standard VHT rate and mac80211 warns and drops
packets, and leads low TCP throughput.

    Rate marked as a VHT rate but data is invalid: MCS: 10, NSS: 2
    WARNING: CPU: 1 PID: 7817 at net/mac80211/rx.c:4856 ieee80211_rx_list+0x223/0x2f0 [mac8021

Since commit c27aa56a72b8 ("cfg80211: add VHT rate entries for MCS-10 and MCS-11")
has added, mac80211 adds this support as well.

After this patch, throughput is good and iw can get the bitrate:
    rx bitrate:	975.1 MBit/s VHT-MCS 10 80MHz short GI VHT-NSS 2
or
    rx bitrate:	1083.3 MBit/s VHT-MCS 11 80MHz short GI VHT-NSS 2

Buglink: https://bugzilla.suse.com/show_bug.cgi?id=1192891
Reported-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://lore.kernel.org/r/20220103013623.17052-1-pkshih@realtek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index cbe1177d95f9e..13cae95a34662 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4434,7 +4434,7 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 				goto drop;
 			break;
 		case RX_ENC_VHT:
-			if (WARN_ONCE(status->rate_idx > 9 ||
+			if (WARN_ONCE(status->rate_idx > 11 ||
 				      !status->nss ||
 				      status->nss > 8,
 				      "Rate marked as a VHT rate but data is invalid: MCS: %d, NSS: %d\n",
-- 
2.34.1



