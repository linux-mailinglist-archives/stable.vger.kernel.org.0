Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CB25949FA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355459AbiHOX4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355369AbiHOXwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:52:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD8592F4C;
        Mon, 15 Aug 2022 13:16:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAA24B81135;
        Mon, 15 Aug 2022 20:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EA3C433C1;
        Mon, 15 Aug 2022 20:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594599;
        bh=/HDOzt1fxq18AH8twZPBlkZvpI2voQRH1kRapURW0Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dydQNzT5HsIbr4/SCl27P5CKJAq6pjT/b7ti+RxD205uEcFu6QkJhg8xck2v2VTMP
         o8i6D0tTnbEYWXCoM5G0+1V+c5K4Kg3h6+dN5Rp9CVHVottg0yXcGmGqGBSSpMswxj
         MfTW5zJ8kSPEDnwx1xhUH2FS5HrB2pe/1/I5lVdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0499/1157] wifi: nl80211: acquire wdev mutex for dump_survey
Date:   Mon, 15 Aug 2022 19:57:35 +0200
Message-Id: <20220815180459.646326974@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 284b38b6902a7154e3675482418a7b6df47808fe ]

At least the quantenna driver calls wdev_chandef() here
which now requires the lock, so acquire it.

Fixes: 7b0a0e3c3a88 ("wifi: cfg80211: do some rework towards MLO link APIs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index af31978fc9cc..c4014ee3f667 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10126,7 +10126,9 @@ static int nl80211_dump_survey(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 
 	while (1) {
+		wdev_lock(wdev);
 		res = rdev_dump_survey(rdev, wdev->netdev, survey_idx, &survey);
+		wdev_unlock(wdev);
 		if (res == -ENOENT)
 			break;
 		if (res)
-- 
2.35.1



