Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6746F5FE07D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiJMSKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiJMSKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:10:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4E4175795;
        Thu, 13 Oct 2022 11:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7B5E61A47;
        Thu, 13 Oct 2022 18:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56BCC433D6;
        Thu, 13 Oct 2022 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684093;
        bh=ABVtqPRgxmZIFlVSQtFaRqnHz1dauK3i7uCum+wmrFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HD1CrisClRoFpKLiQMJhtk58tAiwL+ZkZsQsG9RLGZjHYm+uKuT/fJw8kJ6js4kdc
         EUFnz8pGznCEmlvZUzQ/1pM/UGBkNJg6AxFXW1BE8C3Z8npcPaCIsaWx0WoY1Xor1j
         Mj0aGm8JCt+BaKazkAOZHxqRnniW0/Fy/TbP9OIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.0 22/34] wifi: cfg80211/mac80211: reject bad MBSSID elements
Date:   Thu, 13 Oct 2022 19:53:00 +0200
Message-Id: <20221013175147.094790325@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
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
@@ -1442,6 +1442,8 @@ static size_t ieee802_11_find_bssid_prof
 	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, start, len) {
 		if (elem->datalen < 2)
 			continue;
+		if (elem->data[0] < 1 || elem->data[0] > 8)
+			continue;
 
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
 			u8 new_bssid[ETH_ALEN];
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2143,6 +2143,8 @@ static void cfg80211_parse_mbssid_data(s
 	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, ie, ielen) {
 		if (elem->datalen < 4)
 			continue;
+		if (elem->data[0] < 1 || (int)elem->data[0] > 8)
+			continue;
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
 			u8 profile_len;
 


