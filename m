Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF49B5317D0
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239700AbiEWRJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239446AbiEWRJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:09:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B65C6CA8D;
        Mon, 23 May 2022 10:09:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66583614CB;
        Mon, 23 May 2022 17:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692D6C385AA;
        Mon, 23 May 2022 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325740;
        bh=m849EUhZg4nLuzALYZCbDweGsu4jGB9ehoNUTrqXP4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2rvd0JziAANrhi96VI1vgcX+uTRc0BulyxOUnRYuxgK97A+ey0I4LVTV0+Ho4wix
         7mOejWX6yc/i6Pft2+ejA43nmv22oiwfw58vBnm8LGK88IrjDZQXF4F3ni4xEXNxj8
         D0rZMND8sQVwNXx4wB9f/avDfXxTbREIAQqCWfa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 28/33] mac80211: fix rx reordering with non explicit / psmp ack policy
Date:   Mon, 23 May 2022 19:05:17 +0200
Message-Id: <20220523165752.970359604@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165746.957506211@linuxfoundation.org>
References: <20220523165746.957506211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5e469ed9764d4722c59562da13120bd2dc6834c5 ]

When the QoS ack policy was set to non explicit / psmp ack, frames are treated
as not being part of a BA session, which causes extra latency on reordering.
Fix this by only bypassing reordering for packets with no-ack policy

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20220420105038.36443-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5a38be9145ff..e60a53c056c0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1204,8 +1204,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 		goto dont_reorder;
 
 	/* not part of a BA session */
-	if (ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK &&
-	    ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)
+	if (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
 		goto dont_reorder;
 
 	/* new, potentially un-ordered, ampdu frame - process it */
-- 
2.35.1



