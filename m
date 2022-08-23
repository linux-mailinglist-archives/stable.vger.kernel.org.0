Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F43359E2E7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242679AbiHWLKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356928AbiHWLJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:09:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104A8B600F;
        Tue, 23 Aug 2022 02:16:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18E916122D;
        Tue, 23 Aug 2022 09:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F48FC433C1;
        Tue, 23 Aug 2022 09:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246194;
        bh=G88VyuaJY6zu5QACzDNnVCsG0jKFiacsIaEoFMegvaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpsUsg56RVBkZzONc3qN4mvI2WlWFQ3GhaDKsIs3HNLDtSW64u+ohzpbX/TXzrQEQ
         3DZM25W+9Qvs029lxgs0oUv+qdXmfydj6aujiokD5I/OOIoweZI24z2wXVI2iHIvUf
         vGTU+99EefoobMLMAjdIYUbMylt5ugQlgIWLdLRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jeongik Cha <jeongik@google.com>
Subject: [PATCH 5.4 007/389] wifi: mac80211_hwsim: add back erroneously removed cast
Date:   Tue, 23 Aug 2022 10:21:25 +0200
Message-Id: <20220823080115.958517669@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
@@ -3289,7 +3289,7 @@ static int hwsim_tx_info_frame_received_
 		u64 skb_cookie;
 
 		txi = IEEE80211_SKB_CB(skb);
-		skb_cookie = (u64)txi->rate_driver_data[0];
+		skb_cookie = (u64)(uintptr_t)txi->rate_driver_data[0];
 
 		if (skb_cookie == ret_skb_cookie) {
 			__skb_unlink(skb, &data2->pending);


