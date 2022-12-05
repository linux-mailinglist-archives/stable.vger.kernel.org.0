Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53845643179
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbiLETOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbiLETOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:14:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B011F2FC
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F67DB81200
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80184C433D6;
        Mon,  5 Dec 2022 19:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267676;
        bh=5vLilRi43yM10RvlaRVrv82W+ZfVreExLZ+l9RTljCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoSl9zhNzEbX6VSsn2IvEMbk73JzcD8fEyFUMCkuNRhf+IoBY8LP5sUjUXmqIGq9S
         QKc/BxsONWIbHIsI8PGVzl7hJ7kqmj2YAI4sUMMQJu5WC7JRr/zqYHMQJInw3MG2fk
         wlw0j78lvA5vLOjXfBT6uv3JsJGIFfKlptiyJAEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/77] wifi: mac80211: Fix ack frame idr leak when mesh has no route
Date:   Mon,  5 Dec 2022 20:08:54 +0100
Message-Id: <20221205190800.986908908@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
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

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit 39e7b5de9853bd92ddbfa4b14165babacd7da0ba ]

When trying to transmit an data frame with tx_status to a destination
that have no route in the mesh, then it is dropped without recrediting
the ack_status_frames idr.

Once it is exhausted, wpa_supplicant starts failing to do SAE with
NL80211_CMD_FRAME and logs "nl80211: Frame command failed".

Use ieee80211_free_txskb() instead of kfree_skb() to fix it.

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Link: https://lore.kernel.org/r/20221027140133.1504-1-nicolas.cavallari@green-communications.fr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 54d44836dd28..e4c62b0a3fdb 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -793,7 +793,7 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 void mesh_path_discard_frame(struct ieee80211_sub_if_data *sdata,
 			     struct sk_buff *skb)
 {
-	kfree_skb(skb);
+	ieee80211_free_txskb(&sdata->local->hw, skb);
 	sdata->u.mesh.mshstats.dropped_frames_no_route++;
 }
 
-- 
2.35.1



