Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3E05AEA48
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbiIFNlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240980AbiIFNjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:39:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6097C754;
        Tue,  6 Sep 2022 06:36:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA848B81636;
        Tue,  6 Sep 2022 13:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036DEC433D7;
        Tue,  6 Sep 2022 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471305;
        bh=1Tev2jxG3NPeuKTJm2dciF1qaqKl/9tuXk2U0t4KUnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLsc0bzgfqk2WbFQmDb0qWOySAWQb/g9/nuMeGwnDUw1VTO0zRG/A5vEgX7U7ETml
         nR0bFiNS4NGlXoPbNp2Wx3aHJ2D9ULX8Z8LCg9KcUCywIhn6J7LHzAxZiPb2TfgL0p
         RD5hUB3y7doeu+ddV/19xi6qlUHqjdEZP83zoyWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com,
        Siddh Raman Pant <code@siddh.me>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 65/80] wifi: mac80211: Dont finalize CSA in IBSS mode if state is disconnected
Date:   Tue,  6 Sep 2022 15:31:02 +0200
Message-Id: <20220906132819.786626829@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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

From: Siddh Raman Pant <code@siddh.me>

commit 15bc8966b6d3a5b9bfe4c9facfa02f2b69b1e5f0 upstream.

When we are not connected to a channel, sending channel "switch"
announcement doesn't make any sense.

The BSS list is empty in that case. This causes the for loop in
cfg80211_get_bss() to be bypassed, so the function returns NULL
(check line 1424 of net/wireless/scan.c), causing the WARN_ON()
in ieee80211_ibss_csa_beacon() to get triggered (check line 500
of net/mac80211/ibss.c), which was consequently reported on the
syzkaller dashboard.

Thus, check if we have an existing connection before generating
the CSA beacon in ieee80211_ibss_finish_csa().

Cc: stable@vger.kernel.org
Fixes: cd7760e62c2a ("mac80211: add support for CSA in IBSS mode")
Link: https://syzkaller.appspot.com/bug?id=05603ef4ae8926761b678d2939a3b2ad28ab9ca6
Reported-by: syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com
Signed-off-by: Siddh Raman Pant <code@siddh.me>
Tested-by: syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20220814151512.9985-1-code@siddh.me
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ibss.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -541,6 +541,10 @@ int ieee80211_ibss_finish_csa(struct iee
 
 	sdata_assert_lock(sdata);
 
+	/* When not connected/joined, sending CSA doesn't make sense. */
+	if (ifibss->state != IEEE80211_IBSS_MLME_JOINED)
+		return -ENOLINK;
+
 	/* update cfg80211 bss information with the new channel */
 	if (!is_zero_ether_addr(ifibss->bssid)) {
 		cbss = cfg80211_get_bss(sdata->local->hw.wiphy,


