Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D3960869E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiJVHvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbiJVHtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FBF2C2AC2;
        Sat, 22 Oct 2022 00:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A3C160B91;
        Sat, 22 Oct 2022 07:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82659C433D6;
        Sat, 22 Oct 2022 07:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424602;
        bh=PBClYfgcUgCNfOMwp2cjYimZKZ/95lBXgpCYtvQU0AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5aI5RvX8CxCipiUtv23eGuNiLlIdq8xJ+S99mxsdn1K9BVcp9kf5GfLmDKW7oury
         9bAOs+f6zzvPKeaXIqZ5BG1lKYRlUDGIuiBjkzxDYZhFUgddqTCzgle34xZNvQ5g5g
         k7vJ0cqropbPhtADKxhCGjj6Vu35hXKPNqMInBpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaul Triebitz <shaul.triebitz@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 208/717] wifi: cfg80211: get correct AP link chandef
Date:   Sat, 22 Oct 2022 09:21:27 +0200
Message-Id: <20221022072452.095033007@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

[ Upstream commit bc1857619cc7612117d2ee1ed05b5bfeb638614b ]

When checking for channel regulatory validity, use the
AP link chandef (and not mesh's chandef).

Fixes: 7b0a0e3c3a88 ("wifi: cfg80211: do some rework towards MLO link APIs")
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c7383ede794f..d5c7a5aa6853 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2389,6 +2389,10 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 		switch (iftype) {
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_P2P_GO:
+			if (!wdev->links[link].ap.beacon_interval)
+				continue;
+			chandef = wdev->links[link].ap.chandef;
+			break;
 		case NL80211_IFTYPE_MESH_POINT:
 			if (!wdev->u.mesh.beacon_interval)
 				continue;
-- 
2.35.1



