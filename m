Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3664CF58C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbiCGJaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237385AbiCGJ2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEE25BD1E;
        Mon,  7 Mar 2022 01:25:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 077B9B810B2;
        Mon,  7 Mar 2022 09:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42397C340E9;
        Mon,  7 Mar 2022 09:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645117;
        bh=ZmDrpSXBxhFbiVSDxHqnr0OkvbLlHZXnWYI54QNgtlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rp+a5kW1MLJytD+dllVRHndVDWbxulxqH/UCP6HtElvgN9Ke5Tt1LEnIJJZA6447e
         dmFZoHvdQd8uhWydT/pLGybm2p0rRXyuE6YcDuUqAE0tIPhhCyyS3Tq4lzLIhgMPYl
         rJYv4SUbqR5R/J7tyzixx2ZtvI4C4AlVTl8HEIok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/51] nl80211: Handle nla_memdup failures in handle_nan_filter
Date:   Mon,  7 Mar 2022 10:19:19 +0100
Message-Id: <20220307091638.244181307@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
References: <20220307091636.988950823@linuxfoundation.org>
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
index 04c4fd376e1d..c5806f46f6c9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11791,6 +11791,9 @@ static int handle_nan_filter(struct nlattr *attr_filter,
 	i = 0;
 	nla_for_each_nested(attr, attr_filter, rem) {
 		filter[i].filter = nla_memdup(attr, GFP_KERNEL);
+		if (!filter[i].filter)
+			goto err;
+
 		filter[i].len = nla_len(attr);
 		i++;
 	}
@@ -11803,6 +11806,15 @@ static int handle_nan_filter(struct nlattr *attr_filter,
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



