Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0FE6CC47B
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbjC1PFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbjC1PFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:05:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DD5EC55
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:04:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C639961844
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D981FC433D2;
        Tue, 28 Mar 2023 15:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015842;
        bh=krcJGkZi4RJZjKega/0+ZmOPsT4ybSeAqxSoh2Cleak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AH7vH5DSGhVU24WkWfW8ZhunG0pConeH/VAiN9y8udt9xmrfBFxUsHmraEwV9Fx7E
         cDvYH2gsHWXMSMnr+8+kTmscHN5QCf37B/PjFE+PmVpA6idOR+AYtsATAMmhBLpGrr
         GqTLtc2wqaNgDqpvPVvi0btxm+6sdHPPDzqFPT6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 196/224] wifi: mac80211: fix qos on mesh interfaces
Date:   Tue, 28 Mar 2023 16:43:12 +0200
Message-Id: <20230328142625.549589550@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 4e348c6c6e23491ae6eb5e077848a42d0562339c upstream.

When ieee80211_select_queue is called for mesh, the sta pointer is usually
NULL, since the nexthop is looked up much later in the tx path.
Explicitly check for unicast address in that case in order to make qos work
again.

Cc: stable@vger.kernel.org
Fixes: 50e2ab392919 ("wifi: mac80211: fix queue selection for mesh/OCB interfaces")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230314095956.62085-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/wme.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -144,12 +144,14 @@ u16 ieee80211_select_queue_80211(struct
 u16 __ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta, struct sk_buff *skb)
 {
+	const struct ethhdr *eth = (void *)skb->data;
 	struct mac80211_qos_map *qos_map;
 	bool qos;
 
 	/* all mesh/ocb stations are required to support WME */
-	if (sta && (sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
-		    sdata->vif.type == NL80211_IFTYPE_OCB))
+	if ((sdata->vif.type == NL80211_IFTYPE_MESH_POINT &&
+	    !is_multicast_ether_addr(eth->h_dest)) ||
+	    (sdata->vif.type == NL80211_IFTYPE_OCB && sta))
 		qos = true;
 	else if (sta)
 		qos = sta->sta.wme;


