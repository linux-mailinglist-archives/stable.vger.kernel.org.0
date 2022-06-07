Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546815417B6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378871AbiFGVEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378882AbiFGVE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:04:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31AC18ADB5;
        Tue,  7 Jun 2022 11:48:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E25561295;
        Tue,  7 Jun 2022 18:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56736C385A2;
        Tue,  7 Jun 2022 18:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627732;
        bh=C9X33pXWCcfrKODJ1R5etG2iGEZfHfyCD+gmXXOfpYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7G5eb7+WFOw8sAOV0eJH9AHuSsbAUwj7LTO0nZC/65/gZhJFhR3l/yyw+HpqN0Uk
         7G5JFnDAoOzL5lzToiU69k2ZlGE6xHzMGmuRD9MqjSUfRkJJLnFcMmxhg63sprTcqY
         sGhShvNYj5m9OjVr+YrwOA2QiBryEQHZGi/xs8Z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Seiderer <ps.report@gmx.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 074/879] mac80211: minstrel_ht: fix where rate stats are stored (fixes debugfs output)
Date:   Tue,  7 Jun 2022 18:53:12 +0200
Message-Id: <20220607165004.839967461@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Seiderer <ps.report@gmx.net>

[ Upstream commit 5c6dd7bd569b54c0d2904125d7366aa93f077f67 ]

Using an ath9k card the debugfs output of minstrel_ht looks like the following
(note the zero values for the first four rates sum-of success/attempts):

             best    ____________rate__________    ____statistics___    _____last____    ______sum-of________
mode guard #  rate   [name   idx airtime  max_tp]  [avg(tp) avg(prob)]  [retry|suc|att]  [#success | #attempts]
OFDM       1    DP     6.0M  272    1640     5.2       3.1      53.8       3     0 0             0   0
OFDM       1   C       9.0M  273    1104     7.7       4.6      53.8       4     0 0             0   0
OFDM       1  B       12.0M  274     836    10.0       6.0      53.8       4     0 0             0   0
OFDM       1 A    S   18.0M  275     568    14.3       8.5      53.8       5     0 0             0   0
OFDM       1      S   24.0M  276     436    18.1       0.0       0.0       5     0 1            80   1778
OFDM       1          36.0M  277     300    24.9       0.0       0.0       0     0 1             0   107
OFDM       1      S   48.0M  278     236    30.4       0.0       0.0       0     0 0             0   75
OFDM       1          54.0M  279     212    33.0       0.0       0.0       0     0 0             0   72

Total packet count::    ideal 16582      lookaround 885
Average # of aggregated frames per A-MPDU: 1.0

Debugging showed that the rate statistics for the first four rates where
stored in the MINSTREL_CCK_GROUP instead of the MINSTREL_OFDM_GROUP because
in minstrel_ht_get_stats() the supported check was not honoured as done in
various other places, e.g net/mac80211/rc80211_minstrel_ht_debugfs.c:

 74                 if (!(mi->supported[i] & BIT(j)))
 75                         continue;

With the patch applied the output looks good:

              best    ____________rate__________    ____statistics___    _____last____    ______sum-of________
mode guard #  rate   [name   idx airtime  max_tp]  [avg(tp) avg(prob)]  [retry|suc|att]  [#success | #attempts]
OFDM       1    D      6.0M  272    1640     5.2       5.2     100.0       3     0 0             1   1
OFDM       1   C       9.0M  273    1104     7.7       7.7     100.0       4     0 0            38   38
OFDM       1  B       12.0M  274     836    10.0       9.9      89.5       4     2 2           372   395
OFDM       1 A   P    18.0M  275     568    14.3      14.3      97.2       5    52 53         6956   7181
OFDM       1      S   24.0M  276     436    18.1       0.0       0.0       0     0 1             6   163
OFDM       1          36.0M  277     300    24.9       0.0       0.0       0     0 1             0   35
OFDM       1      S   48.0M  278     236    30.4       0.0       0.0       0     0 0             0   38
OFDM       1      S   54.0M  279     212    33.0       0.0       0.0       0     0 0             0   38

Total packet count::    ideal 7097      lookaround 287
Average # of aggregated frames per A-MPDU: 1.0

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Link: https://lore.kernel.org/r/20220404165414.1036-1-ps.report@gmx.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 9c6ace858107..5a6bf46a4248 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -362,6 +362,9 @@ minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 
 	group = MINSTREL_CCK_GROUP;
 	for (idx = 0; idx < ARRAY_SIZE(mp->cck_rates); idx++) {
+		if (!(mi->supported[group] & BIT(idx)))
+			continue;
+
 		if (rate->idx != mp->cck_rates[idx])
 			continue;
 
-- 
2.35.1



