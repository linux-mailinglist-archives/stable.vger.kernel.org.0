Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A475FE10D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiJMSYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiJMSXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:23:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EBF4C012;
        Thu, 13 Oct 2022 11:18:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B0A61913;
        Thu, 13 Oct 2022 17:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A99DC433D6;
        Thu, 13 Oct 2022 17:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683812;
        bh=7ADSkhJgMzgbvEfxkGhKSmMII+dlmQ0WYUlz4phgh+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SB/AhnBpl4/DZKrMWfNremN16h91J348QFJWGue3xGDqUTmUUPB6fffPhVlhoqt/h
         yS2U4Uro9v/gw8HJaJMIQRaze9F5q/P7PdWLgOV9ydcXJ4wKdfPl+a+Tma75fvuCrY
         rPHlpBn++pERgefEVpZuppYEWlucmytqZ8/jGJMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Soenke Huster <shuster@seemoo.tu-darmstadt.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 45/54] wifi: cfg80211: ensure length byte is present before access
Date:   Thu, 13 Oct 2022 19:52:39 +0200
Message-Id: <20221013175148.431764542@linuxfoundation.org>
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

commit 567e14e39e8f8c6997a1378bc3be615afca86063 upstream.

When iterating the elements here, ensure the length byte is
present before checking it to see if the entire element will
fit into the buffer.

Longer term, we should rewrite this code using the type-safe
element iteration macros that check all of this.

Fixes: 0b8fb8235be8 ("cfg80211: Parsing of Multiple BSSID information in scanning")
Reported-by: Soenke Huster <shuster@seemoo.tu-darmstadt.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -304,7 +304,8 @@ static size_t cfg80211_gen_new_ie(const
 	tmp_old = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
 	tmp_old = (tmp_old) ? tmp_old + tmp_old[1] + 2 : ie;
 
-	while (tmp_old + tmp_old[1] + 2 - ie <= ielen) {
+	while (tmp_old + 2 - ie <= ielen &&
+	       tmp_old + tmp_old[1] + 2 - ie <= ielen) {
 		if (tmp_old[0] == 0) {
 			tmp_old++;
 			continue;
@@ -364,7 +365,8 @@ static size_t cfg80211_gen_new_ie(const
 	 * copied to new ie, skip ssid, capability, bssid-index ie
 	 */
 	tmp_new = sub_copy;
-	while (tmp_new + tmp_new[1] + 2 - sub_copy <= subie_len) {
+	while (tmp_new + 2 - sub_copy <= subie_len &&
+	       tmp_new + tmp_new[1] + 2 - sub_copy <= subie_len) {
 		if (!(tmp_new[0] == WLAN_EID_NON_TX_BSSID_CAP ||
 		      tmp_new[0] == WLAN_EID_SSID)) {
 			memcpy(pos, tmp_new, tmp_new[1] + 2);


