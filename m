Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E314CF954
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240073AbiCGKEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240217AbiCGKAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9517CDD6;
        Mon,  7 Mar 2022 01:47:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE69D612D2;
        Mon,  7 Mar 2022 09:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8569DC340E9;
        Mon,  7 Mar 2022 09:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646425;
        bh=h9h2o3jdKB0EJC63XRK6TMLdRJFf75P1eATU6GsJJcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKoaipIi0joZvNL84ResHLDTAf8zq17U/vz/uWOwaj6Gljbol5T/JYr2mmFwP7cf2
         U7dHqey6qeK3Gdg3VlBWdhEY42gOEnAbIZl4B06uIZlXlwM+vAnrcQmn+DuwW418fp
         utgQnWMc5lwncH7Llnq09H7c0rt4zh1IcBRoAIHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/262] nl80211: Handle nla_memdup failures in handle_nan_filter
Date:   Mon,  7 Mar 2022 10:19:43 +0100
Message-Id: <20220307091710.139690829@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 6ad27f522cb3b210476daf63ce6ddb6568c0508b ]

As there's potential for failure of the nla_memdup(),
check the return value.

Fixes: a442b761b24b ("cfg80211: add add_nan_func / del_nan_func")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220301100020.3801187-1-jiasheng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 16b3d0cc0bdb..99564db14aa1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13177,6 +13177,9 @@ static int handle_nan_filter(struct nlattr *attr_filter,
 	i = 0;
 	nla_for_each_nested(attr, attr_filter, rem) {
 		filter[i].filter = nla_memdup(attr, GFP_KERNEL);
+		if (!filter[i].filter)
+			goto err;
+
 		filter[i].len = nla_len(attr);
 		i++;
 	}
@@ -13189,6 +13192,15 @@ static int handle_nan_filter(struct nlattr *attr_filter,
 	}
 
 	return 0;
+
+err:
+	i = 0;
+	nla_for_each_nested(attr, attr_filter, rem) {
+		kfree(filter[i].filter);
+		i++;
+	}
+	kfree(filter);
+	return -ENOMEM;
 }
 
 static int nl80211_nan_add_func(struct sk_buff *skb,
-- 
2.34.1



