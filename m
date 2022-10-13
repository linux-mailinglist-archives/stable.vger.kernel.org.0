Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C685FDFEC
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiJMSB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiJMSBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:01:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB79A11A96A;
        Thu, 13 Oct 2022 11:01:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF6A26190D;
        Thu, 13 Oct 2022 17:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C3CC433D6;
        Thu, 13 Oct 2022 17:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683829;
        bh=MRRy+iry6nMIHRBsR08AYThjrld3/PB8Shx9bs0SHME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvSDcDTOPem1NsBuqbteN9YII/69pT+MyomX+Sdx+zP2yddHB7PL1FXs2mbGeLGtm
         uHK1pTmh608bhfcsuuGew/M74NOdeppbqdOqnlePjZlHaBetjsiISVNiywPVacKIsD
         yBRNbwa1rhW1ZzitSP7ip6yHxVkXBbRFR4hueHEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?S=C3=B6nke=20Huster?= <shuster@seemoo.tu-darmstadt.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 49/54] wifi: mac80211: fix crash in beacon protection for P2P-device
Date:   Thu, 13 Oct 2022 19:52:43 +0200
Message-Id: <20221013175148.521932298@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit b2d03cabe2b2e150ff5a381731ea0355459be09f upstream.

If beacon protection is active but the beacon cannot be
decrypted or is otherwise malformed, we call the cfg80211
API to report this to userspace, but that uses a netdev
pointer, which isn't present for P2P-Device. Fix this to
call it only conditionally to ensure cfg80211 won't crash
in the case of P2P-Device.

This fixes CVE-2022-42722.

Reported-by: Sönke Huster <shuster@seemoo.tu-darmstadt.de>
Fixes: 9eaf183af741 ("mac80211: Report beacon protection failures to user space")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1975,10 +1975,11 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 
 		if (mmie_keyidx < NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS ||
 		    mmie_keyidx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS +
-		    NUM_DEFAULT_BEACON_KEYS) {
-			cfg80211_rx_unprot_mlme_mgmt(rx->sdata->dev,
-						     skb->data,
-						     skb->len);
+				   NUM_DEFAULT_BEACON_KEYS) {
+			if (rx->sdata->dev)
+				cfg80211_rx_unprot_mlme_mgmt(rx->sdata->dev,
+							     skb->data,
+							     skb->len);
 			return RX_DROP_MONITOR; /* unexpected BIP keyidx */
 		}
 
@@ -2126,7 +2127,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	/* either the frame has been decrypted or will be dropped */
 	status->flag |= RX_FLAG_DECRYPTED;
 
-	if (unlikely(ieee80211_is_beacon(fc) && result == RX_DROP_UNUSABLE))
+	if (unlikely(ieee80211_is_beacon(fc) && result == RX_DROP_UNUSABLE &&
+		     rx->sdata->dev))
 		cfg80211_rx_unprot_mlme_mgmt(rx->sdata->dev,
 					     skb->data, skb->len);
 


