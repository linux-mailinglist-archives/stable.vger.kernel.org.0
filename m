Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB51C59A317
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354190AbiHSQwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354468AbiHSQvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:51:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B90D4192;
        Fri, 19 Aug 2022 09:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F5FEB8281C;
        Fri, 19 Aug 2022 16:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67757C433C1;
        Fri, 19 Aug 2022 16:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925565;
        bh=9+haSAmpSNCpSQ93WhxmWz6akqKUaW0JkC/VW2kYV0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hy94WwflTXNBv/pFOBqAH06BThv+5/2td91uIH2ZpQPSHnDvdx9JZRFBvq1IC7nlc
         5IWVY37BlsqWdcEm7ZLGa+12aaVsMBbkD3TG5JSquPB8x4ZKX6e9CCQPHH8BJm2IY4
         7MfZs1m8cjEDcUDVagMjhw/C/ZXE7WmQHNsbs/PM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmed Zaki <anzaki@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Viacheslav Sablin <sablin@ispras.ru>
Subject: [PATCH 5.10 531/545] mac80211: fix a memory leak where sta_info is not freed
Date:   Fri, 19 Aug 2022 17:45:01 +0200
Message-Id: <20220819153853.344912739@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed Zaki <anzaki@gmail.com>

commit 8f9dcc29566626f683843ccac6113a12208315ca upstream.

The following is from a system that went OOM due to a memory leak:

wlan0: Allocated STA 74:83:c2:64:0b:87
wlan0: Allocated STA 74:83:c2:64:0b:87
wlan0: IBSS finish 74:83:c2:64:0b:87 (---from ieee80211_ibss_add_sta)
wlan0: Adding new IBSS station 74:83:c2:64:0b:87
wlan0: moving STA 74:83:c2:64:0b:87 to state 2
wlan0: moving STA 74:83:c2:64:0b:87 to state 3
wlan0: Inserted STA 74:83:c2:64:0b:87
wlan0: IBSS finish 74:83:c2:64:0b:87 (---from ieee80211_ibss_work)
wlan0: Adding new IBSS station 74:83:c2:64:0b:87
wlan0: moving STA 74:83:c2:64:0b:87 to state 2
wlan0: moving STA 74:83:c2:64:0b:87 to state 3
.
.
wlan0: expiring inactive not authorized STA 74:83:c2:64:0b:87
wlan0: moving STA 74:83:c2:64:0b:87 to state 2
wlan0: moving STA 74:83:c2:64:0b:87 to state 1
wlan0: Removed STA 74:83:c2:64:0b:87
wlan0: Destroyed STA 74:83:c2:64:0b:87

The ieee80211_ibss_finish_sta() is called twice on the same STA from 2
different locations. On the second attempt, the allocated STA is not
destroyed creating a kernel memory leak.

This is happening because sta_info_insert_finish() does not call
sta_info_free() the second time when the STA already exists (returns
-EEXIST). Note that the caller sta_info_insert_rcu() assumes STA is
destroyed upon errors.

Same fix is applied to -ENOMEM.

Signed-off-by: Ahmed Zaki <anzaki@gmail.com>
Link: https://lore.kernel.org/r/20211002145329.3125293-1-anzaki@gmail.com
[change the error path label to use the existing code]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Viacheslav Sablin <sablin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/sta_info.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -645,13 +645,13 @@ static int sta_info_insert_finish(struct
 	/* check if STA exists already */
 	if (sta_info_get_bss(sdata, sta->sta.addr)) {
 		err = -EEXIST;
-		goto out_err;
+		goto out_cleanup;
 	}
 
 	sinfo = kzalloc(sizeof(struct station_info), GFP_KERNEL);
 	if (!sinfo) {
 		err = -ENOMEM;
-		goto out_err;
+		goto out_cleanup;
 	}
 
 	local->num_sta++;
@@ -707,8 +707,8 @@ static int sta_info_insert_finish(struct
  out_drop_sta:
 	local->num_sta--;
 	synchronize_net();
+ out_cleanup:
 	cleanup_single_sta(sta);
- out_err:
 	mutex_unlock(&local->sta_mtx);
 	kfree(sinfo);
 	rcu_read_lock();


