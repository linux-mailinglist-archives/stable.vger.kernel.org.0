Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34F9531701
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242376AbiEWRkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243578AbiEWRiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:38:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B42A6B7C2;
        Mon, 23 May 2022 10:32:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAA24B811FE;
        Mon, 23 May 2022 17:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B56EC385AA;
        Mon, 23 May 2022 17:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327069;
        bh=m80PVdEZX1lH4vWt6edcuHR6RqQ39qIO0Eig5ttw22Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgMJj3SHumIOJ5vu2MdieIW4Nns6uIwxpPEncdk9VIRlIQe1LzEJiWfB6LGrO0yGD
         Ir04TLEhMzqk/4jOl/99NozQNvnJWBKrtYdw7gR4NdOUisBdHy04GAW8Ye0gAe59B6
         My8FqnADKJ6viZofD7FdhXob4EDYFnd4OhTKc+3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 147/158] nl80211: fix locking in nl80211_set_tx_bitrate_mask()
Date:   Mon, 23 May 2022 19:05:04 +0200
Message-Id: <20220523165854.543117070@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f971e1887fdb3ab500c9bebf4b98f62d49a20655 ]

This accesses the wdev's chandef etc., so cannot safely
be used without holding the lock.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20220506102136.06b7205419e6.I2a87c05fbd8bc5e565e84d190d4cfd2e92695a90@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 06a35f1bec23..0c20df052db3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11573,18 +11573,23 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	struct cfg80211_bitrate_mask mask;
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
 	if (!rdev->ops->set_bitrate_mask)
 		return -EOPNOTSUPP;
 
+	wdev_lock(wdev);
 	err = nl80211_parse_tx_bitrate_mask(info, info->attrs,
 					    NL80211_ATTR_TX_RATES, &mask,
 					    dev, true);
 	if (err)
-		return err;
+		goto out;
 
-	return rdev_set_bitrate_mask(rdev, dev, NULL, &mask);
+	err = rdev_set_bitrate_mask(rdev, dev, NULL, &mask);
+out:
+	wdev_unlock(wdev);
+	return err;
 }
 
 static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
-- 
2.35.1



