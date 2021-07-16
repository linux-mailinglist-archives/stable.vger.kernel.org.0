Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35283CB2F1
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbhGPHHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:07:37 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6942 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235393AbhGPHHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 03:07:36 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GR2Fs1FNdz7vRW;
        Fri, 16 Jul 2021 15:01:05 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 15:04:40 +0800
Received: from localhost.localdomain (10.175.127.227) by
 dggpeml500012.china.huawei.com (7.185.36.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 15:04:39 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <gregkh@linuxfoundation.org>, <Mathy.Vanhoef@kuleuven.be>,
        <johannes.berg@intel.com>
CC:     <stable@vger.kernel.org>, <yuehaibing@huawei.com>,
        <zhangjinhao2@huawei.com>, <zhengyejian1@huawei.com>
Subject: [RFC PATCH 4.4] mac80211: fix handling A-MSDUs that start with an RFC 1042 header
Date:   Fri, 16 Jul 2021 15:11:26 +0800
Message-ID: <20210716071126.672549-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In v4.4, commit e76511a6fbb5 ("mac80211: properly handle A-MSDUs that
start with an RFC 1042 header") looks like an incomplete backport.

There is no functional changes in the commit, since
__ieee80211_data_to_8023() which defined in net/wireless/util.c is
only called by ieee80211_data_to_8023() and parameter 'is_amsdu' is
always input as false.

By comparing with its upstream, I found that following snippet has not
been backported:
  > --- a/net/mac80211/rx.c
  > +++ b/net/mac80211/rx.c
  > @@ -2682,7 +2682,7 @@ __ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx, u8 data_offset)
  >  	if (ieee80211_data_to_8023_exthdr(skb, &ethhdr,
  >  					  rx->sdata->vif.addr,
  >  					  rx->sdata->vif.type,
  > -					  data_offset))
  > +					  data_offset, true))
  >  		return RX_DROP_UNUSABLE;

I think that's where really causing changes and also needs to be
backported, so I try to do it.

Fixes: e76511a6fbb5 ("mac80211: properly handle A-MSDUs that start with an RFC 1042 header")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 84c0a96b3cb6d..a2b35e6619697 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -664,7 +664,7 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 	u8 dst[ETH_ALEN], src[ETH_ALEN];
 
 	if (has_80211_header) {
-		err = ieee80211_data_to_8023(skb, addr, iftype);
+		err = __ieee80211_data_to_8023(skb, addr, iftype, true);
 		if (err)
 			goto out;
 
-- 
2.31.1

