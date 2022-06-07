Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DA654132A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356109AbiFGT4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357034AbiFGTyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:54:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB0881499;
        Tue,  7 Jun 2022 11:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97254B82340;
        Tue,  7 Jun 2022 18:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0C9C385A5;
        Tue,  7 Jun 2022 18:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626210;
        bh=Y6XVSDQIQqH4KWDzX8d/ookexY2fa+XPD1DwkyN8ET0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riVa8yyce+0FaBxBieoge1UzEllMWSuKFcVwo2MrjlXSTpw4gJMFvCh6gD8wLSWyj
         MMa0kbx/XNBW3zH6hi9UMmOsKTd8gkfQOb79AmLkqtEalTGJNbTJvLHu0dw3Ry+5/q
         gtxd5mh3D/xR5i0eVI48TCSqYTnRlCij43nbvUwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 256/772] nl80211: show SSID for P2P_GO interfaces
Date:   Tue,  7 Jun 2022 18:57:28 +0200
Message-Id: <20220607164956.566349852@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 0c20df052db3..ba53bc820d81 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3674,6 +3674,7 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	wdev_lock(wdev);
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
 		if (wdev->ssid_len &&
 		    nla_put(msg, NL80211_ATTR_SSID, wdev->ssid_len, wdev->ssid))
 			goto nla_put_failure_locked;
-- 
2.35.1



