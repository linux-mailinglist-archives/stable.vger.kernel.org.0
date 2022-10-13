Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA525FE0F2
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiJMST1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbiJMSTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:19:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC09E2FFF7;
        Thu, 13 Oct 2022 11:14:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DD0F6192B;
        Thu, 13 Oct 2022 17:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B9DC433C1;
        Thu, 13 Oct 2022 17:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683863;
        bh=+1JS/ScgbebCTbepqx7MKXQYJzZPylwvLEfDVcFSmgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NciiWDzoCeeGnz1c4DbYz1+DGxYavr8jZTfiRjujYJkiecrL5lEdBt1PZq6L1nDg
         oJ2cvPGykw1U3YVZcsp5xEgowt3+YMgrSDczCV6S17KpUoMwz+vCgbDmxhljnW/H+f
         s4qHx0oSkRPzv/v0ZaKw5J1rdgX+Eiusmz3pQEnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 17/27] wifi: cfg80211/mac80211: reject bad MBSSID elements
Date:   Thu, 13 Oct 2022 19:52:46 +0200
Message-Id: <20221013175144.181064984@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175143.518476113@linuxfoundation.org>
References: <20221013175143.518476113@linuxfoundation.org>
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

commit 8f033d2becc24aa6bfd2a5c104407963560caabc upstream.

Per spec, the maximum value for the MaxBSSID ('n') indicator is 8,
and the minimum is 1 since a multiple BSSID set with just one BSSID
doesn't make sense (the # of BSSIDs is limited by 2^n).

Limit this in the parsing in both cfg80211 and mac80211, rejecting
any elements with an invalid value.

This fixes potentially bad shifts in the processing of these inside
the cfg80211_gen_new_bssid() function later.

I found this during the investigation of CVE-2022-41674 fixed by the
previous patch.

Fixes: 0b8fb8235be8 ("cfg80211: Parsing of Multiple BSSID information in scanning")
Fixes: 78ac51f81532 ("mac80211: support multi-bssid")
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/util.c |    2 ++
 net/wireless/scan.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1414,6 +1414,8 @@ static size_t ieee802_11_find_bssid_prof
 	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, start, len) {
 		if (elem->datalen < 2)
 			continue;
+		if (elem->data[0] < 1 || elem->data[0] > 8)
+			continue;
 
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
 			u8 new_bssid[ETH_ALEN];
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2103,6 +2103,8 @@ static void cfg80211_parse_mbssid_data(s
 	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, ie, ielen) {
 		if (elem->datalen < 4)
 			continue;
+		if (elem->data[0] < 1 || (int)elem->data[0] > 8)
+			continue;
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
 			u8 profile_len;
 


