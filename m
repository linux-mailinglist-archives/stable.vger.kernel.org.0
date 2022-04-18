Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F59505098
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbiDRM0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238778AbiDRM0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:26:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09E0E01E;
        Mon, 18 Apr 2022 05:20:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 725DEB80EC1;
        Mon, 18 Apr 2022 12:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F0DC385A1;
        Mon, 18 Apr 2022 12:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284405;
        bh=qZQBsX8kMeWOoOIEuv5t0Jmahj8cLDrFPtcjkPWKtWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fopWR2STUs33FpbhfytReWvgQSUE+g9xS7B94JB3k4EwxWL6WejC5aIS/huEBydC9
         9Kr+98l02icV+A1YX8nIxzGEG1PiTOCTgtLDXFwDnbFs5LoNBrTINBuBsIswHfi4Xl
         B5ObOzfdUa5uau27UHAhT2oeBXOYBMX5h9r+5b2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rameshkumar Sundaram <quic_ramess@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 087/219] cfg80211: hold bss_lock while updating nontrans_list
Date:   Mon, 18 Apr 2022 14:10:56 +0200
Message-Id: <20220418121208.920151613@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rameshkumar Sundaram <quic_ramess@quicinc.com>

[ Upstream commit a5199b5626cd6913cf8776a835bc63d40e0686ad ]

Synchronize additions to nontrans_list of transmitting BSS with
bss_lock to avoid races. Also when cfg80211_add_nontrans_list() fails
__cfg80211_unlink_bss() needs bss_lock to be held (has lockdep assert
on bss_lock). So protect the whole block with bss_lock to avoid
races and warnings. Found during code review.

Fixes: 0b8fb8235be8 ("cfg80211: Parsing of Multiple BSSID information in scanning")
Signed-off-by: Rameshkumar Sundaram <quic_ramess@quicinc.com>
Link: https://lore.kernel.org/r/1649668071-9370-1-git-send-email-quic_ramess@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index b2fdac96bab0..4a6d86432910 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2018,11 +2018,13 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 		/* this is a nontransmitting bss, we need to add it to
 		 * transmitting bss' list if it is not there
 		 */
+		spin_lock_bh(&rdev->bss_lock);
 		if (cfg80211_add_nontrans_list(non_tx_data->tx_bss,
 					       &res->pub)) {
 			if (__cfg80211_unlink_bss(rdev, res))
 				rdev->bss_generation++;
 		}
+		spin_unlock_bh(&rdev->bss_lock);
 	}
 
 	trace_cfg80211_return_bss(&res->pub);
-- 
2.35.1



