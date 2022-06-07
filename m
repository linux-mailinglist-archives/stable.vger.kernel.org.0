Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6035405AE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346562AbiFGR2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346384AbiFGR1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:27:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBF710A61A;
        Tue,  7 Jun 2022 10:24:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4861060906;
        Tue,  7 Jun 2022 17:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5674DC34115;
        Tue,  7 Jun 2022 17:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622655;
        bh=FDU3UZzp9Fl7+xOPFRMbtKBd0947095LClhyo1lQEIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9IwYB/j97jcTondzU+O7BOnqa/5K4hBobR7xAyu1Aw9bsJRbY00rlDIG4vTrzDWy
         P0U5jMRMYaiH2CTHcJyquzLHTtM4Sd5EABx0NMWvShy8HgsPfWhnS5BU/o4jAYk6ap
         jYFI/EuLL2O8IyALALV5sBJx4aPbAbSRdzezPE6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/452] nl80211: show SSID for P2P_GO interfaces
Date:   Tue,  7 Jun 2022 18:59:54 +0200
Message-Id: <20220607164912.643283595@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a75971bc2b8453630e9f85e0beaa4da8db8277a3 ]

There's no real reason not to send the SSID to userspace
when it requests information about P2P_GO, it is, in that
respect, exactly the same as AP interfaces. Fix that.

Fixes: 44905265bc15 ("nl80211: don't expose wdev->ssid for most interfaces")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20220318134656.14354ae223f0.Ia25e85a512281b92e1645d4160766a4b1a471597@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f8d5f35cfc66..8a7f0c8fba5e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3485,6 +3485,7 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	wdev_lock(wdev);
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
 		if (wdev->ssid_len &&
 		    nla_put(msg, NL80211_ATTR_SSID, wdev->ssid_len, wdev->ssid))
 			goto nla_put_failure_locked;
-- 
2.35.1



