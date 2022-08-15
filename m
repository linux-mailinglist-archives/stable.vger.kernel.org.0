Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E356759349E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbiHOSNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbiHOSNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:13:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B0E2A252;
        Mon, 15 Aug 2022 11:13:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A202EB81063;
        Mon, 15 Aug 2022 18:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0560DC433C1;
        Mon, 15 Aug 2022 18:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587211;
        bh=QpFvSv5tEOSTMhJicikr1Svf17aM09RphEQgN5rhjmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpCXns2zhSMUHfhWEO1OpDjtlNc5xLzbSjL6kXdXVh1A9gN8OF0WzQpNyqGwES36X
         1560SEKTkjNYDVFZcdh1lRcd23caYV8paaCxTB+CGRKbge13PXraLKxYxJ6sJaUvSl
         BTvtDZhp37JH1F7d8OBzZgRjl6zPI+z3Ed2apcCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jeongik Cha <jeongik@google.com>
Subject: [PATCH 5.15 013/779] wifi: mac80211_hwsim: add back erroneously removed cast
Date:   Mon, 15 Aug 2022 19:54:17 +0200
Message-Id: <20220815180337.755768092@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
@@ -3614,7 +3614,7 @@ static int hwsim_tx_info_frame_received_
 		u64 skb_cookie;
 
 		txi = IEEE80211_SKB_CB(skb);
-		skb_cookie = (u64)txi->rate_driver_data[0];
+		skb_cookie = (u64)(uintptr_t)txi->rate_driver_data[0];
 
 		if (skb_cookie == ret_skb_cookie) {
 			__skb_unlink(skb, &data2->pending);


