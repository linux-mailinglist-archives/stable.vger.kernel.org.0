Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5274559A0E1
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350132AbiHSPrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350188AbiHSPq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:46:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447AB41996;
        Fri, 19 Aug 2022 08:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3F0A616C0;
        Fri, 19 Aug 2022 15:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E276DC433D7;
        Fri, 19 Aug 2022 15:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923999;
        bh=GbrGJbi7e0JWVfzqMk8s61COOFR/Bvdx7Rf05jG7KD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmIAs/I6bwelI6B8qctb0kvaSw3u9R5AwYRMn4ev7hQGX9DNX+OjEriWi3Onvd/cP
         ViXZDkGmJqbZiQEWBkB/n6ncadjsq0fUm7qsuMUs6h50j+tyXmUw+Pf4Vpx9mr1HEv
         HCOybUizK+5sR3puDXDDrD2hEEn0u652a/Df00ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jeongik Cha <jeongik@google.com>
Subject: [PATCH 5.10 009/545] wifi: mac80211_hwsim: add back erroneously removed cast
Date:   Fri, 19 Aug 2022 17:36:19 +0200
Message-Id: <20220819153829.594079550@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit 58b6259d820d63c2adf1c7541b54cce5a2ae6073 upstream.

The robots report that we're now casting to a differently
sized integer, which is correct, and the previous patch
had erroneously removed it.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 4ee186fa7e40 ("wifi: mac80211_hwsim: fix race condition in pending packet")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Jeongik Cha <jeongik@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3540,7 +3540,7 @@ static int hwsim_tx_info_frame_received_
 		u64 skb_cookie;
 
 		txi = IEEE80211_SKB_CB(skb);
-		skb_cookie = (u64)txi->rate_driver_data[0];
+		skb_cookie = (u64)(uintptr_t)txi->rate_driver_data[0];
 
 		if (skb_cookie == ret_skb_cookie) {
 			__skb_unlink(skb, &data2->pending);


