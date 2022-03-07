Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B4A4CFA6C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbiCGKQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239152AbiCGKPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:15:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955937B553;
        Mon,  7 Mar 2022 01:57:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B4E3CE0DF4;
        Mon,  7 Mar 2022 09:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C45C340F5;
        Mon,  7 Mar 2022 09:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646996;
        bh=fdPXcfk+r7MAY/CS3iNHs7XATdAsqDDd+PTYNYkarAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cI3hQZOVObB/eVLA3gzAHTSP/CWahHLolfHw5Jw+VbGIOZfy+o86ZmuqNc8yZ4ZIA
         636gVk+kz9Gm6rRSpB0ljcYtpabF7nBEsf2+82FXnj4UqrBOB79ZLBzSrt8wOJxWAv
         rVtlRmK/zCact9r46VWItaEdDp1i8ezQPE8R/bq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 160/186] nl80211: Handle nla_memdup failures in handle_nan_filter
Date:   Mon,  7 Mar 2022 10:19:58 +0100
Message-Id: <20220307091658.549469050@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
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
index a27b3b5fa210..f73251828782 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13379,6 +13379,9 @@ static int handle_nan_filter(struct nlattr *attr_filter,
 	i = 0;
 	nla_for_each_nested(attr, attr_filter, rem) {
 		filter[i].filter = nla_memdup(attr, GFP_KERNEL);
+		if (!filter[i].filter)
+			goto err;
+
 		filter[i].len = nla_len(attr);
 		i++;
 	}
@@ -13391,6 +13394,15 @@ static int handle_nan_filter(struct nlattr *attr_filter,
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



