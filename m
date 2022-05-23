Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2176E531743
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239226AbiEWREk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239224AbiEWREg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:04:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75D1606C2;
        Mon, 23 May 2022 10:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03042614C1;
        Mon, 23 May 2022 17:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D54C385A9;
        Mon, 23 May 2022 17:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325474;
        bh=J5AZ6YoBIpezjSlGXkcI10G3x5B8FyKLScmskPDYuuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z3GBQW4ybRAI86qc4CFzd/aCI8Az3Jx45p1CRwoaQPWJ14xO+IWx6+O0Vmj2lPICX
         Quq1oq03SuBPwbVWzu2RJdUmjJMWmT5JrPI/8I6BUF/qOKXMVgDVWOy9l0yMpyrGIT
         IaPylWTB9YqUGXDaEkq40/1YQsACcVHSJ0LLdKRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 23/25] mac80211: fix rx reordering with non explicit / psmp ack policy
Date:   Mon, 23 May 2022 19:03:41 +0200
Message-Id: <20220523165749.857405906@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165743.398280407@linuxfoundation.org>
References: <20220523165743.398280407@linuxfoundation.org>
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
index 41af02a70742..02845bed07d7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1179,8 +1179,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 		goto dont_reorder;
 
 	/* not part of a BA session */
-	if (ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK &&
-	    ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)
+	if (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
 		goto dont_reorder;
 
 	/* new, potentially un-ordered, ampdu frame - process it */
-- 
2.35.1



