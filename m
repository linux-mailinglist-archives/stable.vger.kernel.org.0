Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AD86DEE87
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjDLImO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjDLIl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F64E7687
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:41:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F38C06304F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12ED3C433A0;
        Wed, 12 Apr 2023 08:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288875;
        bh=Ll3MmOHwqt4ipsFxAd0UISQZW8x2YsHV5m/UHvVw5/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0ttdWTSz0odqas/u2/iVG4tBTYyiegO/YdSFzwNd0634XJTVIXF+4owzKPNkW81F
         CbEasszxqXmF3StEIj7ZqDvmsSFtY/U/8vEYaVFaOiwttQpp12O2qKoe/4G1dsPhAq
         7tj2TIaGI6DDRvad8Htujl5iQLvN9wSjH6+t1dp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Coverstone <brian@mainsequence.net>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/164] wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta
Date:   Wed, 12 Apr 2023 10:32:23 +0200
Message-Id: <20230412082837.804532042@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 12b220a6171faf10638ab683a975cadcf1a352d6 ]

Avoid potential data corruption issues caused by uninitialized driver
private data structures.

Reported-by: Brian Coverstone <brian@mainsequence.net>
Fixes: 6a9d1b91f34d ("mac80211: add pre-RCU-sync sta removal driver operation")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230324120924.38412-3-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 3603cbc167570..30efa26f977f6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1242,7 +1242,8 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	list_del_rcu(&sta->list);
 	sta->removed = true;
 
-	drv_sta_pre_rcu_remove(local, sta->sdata, sta);
+	if (sta->uploaded)
+		drv_sta_pre_rcu_remove(local, sta->sdata, sta);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
 	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
-- 
2.39.2



