Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC72B6C189C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbjCTP0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbjCTPZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:25:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6256EEFA1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 433956158B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5100CC433D2;
        Mon, 20 Mar 2023 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325542;
        bh=ReNAFS40A9VoRE5YPx0RxiBs/b7/Ht6LJvTbjr69eKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bw5YTGssb8z/Rx4DgBnlwCiVw7CH9pXw+xRvv+9AHPSTAHOiw2WSeotVxQw9HT9hT
         XyFFKLQwJs+92bjeQqbuxQt40qr5RAz2hkgHXbXWdErJsA1KZ/uU7NpHNluTuLUCuw
         S1SrSWaUlwML9MsmPcKu6cq4BEBqYbSE0cMw6Spw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 035/211] wifi: nl80211: fix NULL-ptr deref in offchan check
Date:   Mon, 20 Mar 2023 15:52:50 +0100
Message-Id: <20230320145514.717132325@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f624bb6fad23df3270580b4fcef415c6e7bf7705 ]

If, e.g. in AP mode, the link was already created by userspace
but not activated yet, it has a chandef but the chandef isn't
valid and has no channel. Check for this and ignore this link.

Fixes: 7b0a0e3c3a88 ("wifi: cfg80211: do some rework towards MLO link APIs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230301115906.71bd4803fbb9.Iee39c0f6c2d3a59a8227674dc55d52e38b1090cf@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 02b9a0280896c..326c6e50e9db5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8816,7 +8816,7 @@ static bool cfg80211_off_channel_oper_allowed(struct wireless_dev *wdev,
 		struct cfg80211_chan_def *chandef;
 
 		chandef = wdev_chandef(wdev, link_id);
-		if (!chandef)
+		if (!chandef || !chandef->chan)
 			continue;
 
 		/*
-- 
2.39.2



