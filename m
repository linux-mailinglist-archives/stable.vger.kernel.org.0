Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1000D579D4F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241714AbiGSMuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240751AbiGSMs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:48:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794B58E1E1;
        Tue, 19 Jul 2022 05:19:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E50D0B81B13;
        Tue, 19 Jul 2022 12:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514DDC341C6;
        Tue, 19 Jul 2022 12:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233156;
        bh=tN+Yms2lOPAuzEgL9UFe3c+rrRIeWkblCZ6G8JUZFis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAbSCFpV4VJuLsI6bLFl7CGLm+XQ9sxVBB+9KG/iw4Fh7qNJuClsj75z8HiXPP2W4
         jlBs/VIftF6tDON8oPexiufZ2LZU9ax9JfsMhnhDzsBaOhfzvxWr+imhEFWJTc+EKM
         lwAxKSEsVX6Vl99Qln9YjXU5ehBJ/P9EV+VKcYsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.18 025/231] wifi: mac80211: fix queue selection for mesh/OCB interfaces
Date:   Tue, 19 Jul 2022 13:51:50 +0200
Message-Id: <20220719114716.141165300@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 50e2ab39291947b6c6c7025cf01707c270fcde59 upstream.

When using iTXQ, the code assumes that there is only one vif queue for
broadcast packets, using the BE queue. Allowing non-BE queue marking
violates that assumption and txq->ac == skb_queue_mapping is no longer
guaranteed. This can cause issues with queue handling in the driver and
also causes issues with the recent ATF change, resulting in an AQL
underflow warning.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20220702145227.39356-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/wme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -147,8 +147,8 @@ u16 __ieee80211_select_queue(struct ieee
 	bool qos;
 
 	/* all mesh/ocb stations are required to support WME */
-	if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
-	    sdata->vif.type == NL80211_IFTYPE_OCB)
+	if (sta && (sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
+		    sdata->vif.type == NL80211_IFTYPE_OCB))
 		qos = true;
 	else if (sta)
 		qos = sta->sta.wme;


