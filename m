Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271856AF362
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbjCGTEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbjCGTEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:04:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3979476BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:49:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E92E8B8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548F3C433AC;
        Tue,  7 Mar 2023 18:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214965;
        bh=UhjXiqHYf3s33ULRKFA3w1ziziMmutAfX2v3Zg62rqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0UHaMzRscG2IaCiKQdHfQF6jtkVxxaITKlD9+AFfLCPQXqJWPLYfVtZwnmmjbHEw
         q2osjPxCHCbBz58Ex8dpv4nwBPg/LrG91gAX2wBiAm22h3t5j0VAJ9DYp22WCKzKPV
         WsBkkail1TV/bSJjE2iRsrFhtBcp0qPGoh8tCvm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shivani Baranwal <quic_shivbara@quicinc.com>,
        Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/567] wifi: cfg80211: Fix extended KCK key length check in nl80211_set_rekey_data()
Date:   Tue,  7 Mar 2023 17:57:23 +0100
Message-Id: <20230307165910.530390956@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shivani Baranwal <quic_shivbara@quicinc.com>

[ Upstream commit df4969ca135b9b3b2c38c07514aaa775112ac835 ]

The extended KCK key length check wrongly using the KEK key attribute
for validation. Due to this GTK rekey offload is failing when the KCK
key length is 24 bytes even though the driver advertising
WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK flag. Use correct attribute to fix the
same.

Fixes: 093a48d2aa4b ("cfg80211: support bigger kek/kck key length")
Signed-off-by: Shivani Baranwal <quic_shivbara@quicinc.com>
Signed-off-by: Veerendranath Jakkam <quic_vjakkam@quicinc.com>
Link: https://lore.kernel.org/r/20221206143715.1802987-2-quic_vjakkam@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bb46a6a346146..1b91a9c208969 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12922,7 +12922,7 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 		return -ERANGE;
 	if (nla_len(tb[NL80211_REKEY_DATA_KCK]) != NL80211_KCK_LEN &&
 	    !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK &&
-	      nla_len(tb[NL80211_REKEY_DATA_KEK]) == NL80211_KCK_EXT_LEN))
+	      nla_len(tb[NL80211_REKEY_DATA_KCK]) == NL80211_KCK_EXT_LEN))
 		return -ERANGE;
 
 	rekey_data.kek = nla_data(tb[NL80211_REKEY_DATA_KEK]);
-- 
2.39.2



