Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB79B5FFDA5
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 08:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJPGqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 02:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiJPGqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 02:46:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396CC3AE5B;
        Sat, 15 Oct 2022 23:45:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25C52B80B77;
        Sun, 16 Oct 2022 06:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BE2C433D7;
        Sun, 16 Oct 2022 06:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665902753;
        bh=OPUq4AaBA6cqzgAQsUxgbbuBNbAZzLY8pUyPprPooYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrBWzdiiQogsYpzs5qRmXDMkEkcP0kEivjac3mPKa0gWoqch8OHf+wEk1wTgYWU3H
         8LzYPICFHnfKcNBF1hoYB/p4XD5EO0eBwedAuZESJ4XnujQbLx5l4y69opLVi63VDA
         ocCHf6Eb+taj7IAgSbmGzYoNwRHQTNjdXIwk+4yQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 3/4] wifi: mac80211: dont parse mbssid in assoc response
Date:   Sun, 16 Oct 2022 08:46:25 +0200
Message-Id: <20221016064454.438611868@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221016064454.327821011@linuxfoundation.org>
References: <20221016064454.327821011@linuxfoundation.org>
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

This is simply not valid and simplifies the next commit.
I'll make a separate patch for this in the current main
tree as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3224,7 +3224,7 @@ static bool ieee80211_assoc_success(stru
 
 	pos = mgmt->u.assoc_resp.variable;
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
-			       mgmt->bssid, assoc_data->bss->bssid);
+			       mgmt->bssid, NULL);
 
 	if (!elems.supp_rates) {
 		sdata_info(sdata, "no SuppRates element in AssocResp\n");
@@ -3576,7 +3576,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 	pos = mgmt->u.assoc_resp.variable;
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
-			       mgmt->bssid, assoc_data->bss->bssid);
+			       mgmt->bssid, NULL);
 
 	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
 	    elems.timeout_int &&


