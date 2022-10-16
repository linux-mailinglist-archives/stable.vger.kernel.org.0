Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27965FFD9E
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 08:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiJPGpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 02:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiJPGpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 02:45:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6794A3743B;
        Sat, 15 Oct 2022 23:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C08DDB80B65;
        Sun, 16 Oct 2022 06:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3220EC433C1;
        Sun, 16 Oct 2022 06:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665902739;
        bh=wJQ0U41KLRy5gUD5LL0D8LqduAlTFDOlhxPc+h6eaFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dksST5maNe3bQNWUDD2pVGfR5qfSyR2G9gBGUksi2ggllnISIr938ceIJQy497l5A
         NZJsjCe8MtPHFPrmfVkQyiXkxFt70G0lu07PjzxjvHa5QHM5RH3TEPcMt6M6y69Lkn
         CUJOR38YHAeWhVW6HTbL4nnvf6RJwwJpeFQko0V8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 3/4] wifi: mac80211: dont parse mbssid in assoc response
Date:   Sun, 16 Oct 2022 08:46:13 +0200
Message-Id: <20221016064454.487620750@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221016064454.382206984@linuxfoundation.org>
References: <20221016064454.382206984@linuxfoundation.org>
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
@@ -3300,7 +3300,7 @@ static bool ieee80211_assoc_success(stru
 	}
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, elems,
-			       mgmt->bssid, assoc_data->bss->bssid);
+			       mgmt->bssid, NULL);
 
 	if (elems->aid_resp)
 		aid = le16_to_cpu(elems->aid_resp->aid);
@@ -3708,7 +3708,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 		return;
 
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
-			       mgmt->bssid, assoc_data->bss->bssid);
+			       mgmt->bssid, NULL);
 
 	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
 	    elems.timeout_int &&


