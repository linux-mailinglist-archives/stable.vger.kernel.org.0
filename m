Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C016AEE6F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbjCGSL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbjCGSLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:11:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC1937702
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:06:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5595C614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF23C433EF;
        Tue,  7 Mar 2023 18:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212400;
        bh=zNmdqPUPoeZyJ3wcugg7wk8X3C8p58xBXgu2ZKEUwAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfovWZ1x6kG7Ncz45D5CwclSP0UKkG1lbAuI3+iLhYnP0gpQ6ahyNWujWrBy8/QGw
         pa0bOquyuztT3c1GngZvcJh62ZPDT76wNrF1vJZoPMFpyT2zKUnXgnh26upuJBDvp3
         2qk4BDCU+DrWm+9NEscBjF1pgHnEl2uEmQ6vD92M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shivani Baranwal <quic_shivbara@quicinc.com>,
        Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/885] wifi: cfg80211: Fix extended KCK key length check in nl80211_set_rekey_data()
Date:   Tue,  7 Mar 2023 17:51:46 +0100
Message-Id: <20230307170009.436205189@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index d2321c6833985..4d4de49f7ab65 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13808,7 +13808,7 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 		return -ERANGE;
 	if (nla_len(tb[NL80211_REKEY_DATA_KCK]) != NL80211_KCK_LEN &&
 	    !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK &&
-	      nla_len(tb[NL80211_REKEY_DATA_KEK]) == NL80211_KCK_EXT_LEN))
+	      nla_len(tb[NL80211_REKEY_DATA_KCK]) == NL80211_KCK_EXT_LEN))
 		return -ERANGE;
 
 	rekey_data.kek = nla_data(tb[NL80211_REKEY_DATA_KEK]);
-- 
2.39.2



