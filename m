Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3D624B2E9
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgHTJiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728788AbgHTJit (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:38:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 489FD2075E;
        Thu, 20 Aug 2020 09:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916328;
        bh=fEdiXVCUATGjxgpl36gAhW7CNegS9vb79xmy4lwUylo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQt2ZS5EScbTZ6avA+/A3EPSdm2jGSkDP09l5Vxpua72US+BEN2G5n5EHXZJpLXIY
         P8j6bF/VSUHzYnW+9e2lNqP32KN8JThz1m5LjRunCbL0edKxqDRWHPyp+ThfNqCdkp
         /yDF9rzVqwqOQb4IsX7o/y1RiVZqynrUGF6pKsIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.7 061/204] mac80211: fix misplaced while instead of if
Date:   Thu, 20 Aug 2020 11:19:18 +0200
Message-Id: <20200820091609.315336854@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 5981fe5b0529ba25d95f37d7faa434183ad618c5 upstream.

This never was intended to be a 'while' loop, it should've
just been an 'if' instead of 'while'. Fix this.

I noticed this while applying another patch from Ben that
intended to fix a busy loop at this spot.

Cc: stable@vger.kernel.org
Fixes: b16798f5b907 ("mac80211: mark station unauthorized before key removal")
Reported-by: Ben Greear <greearb@candelatech.com>
Link: https://lore.kernel.org/r/20200803110209.253009ae41ff.I3522aad099392b31d5cf2dcca34cbac7e5832dde@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/sta_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1050,7 +1050,7 @@ static void __sta_info_destroy_part2(str
 	might_sleep();
 	lockdep_assert_held(&local->sta_mtx);
 
-	while (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
+	if (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
 		ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 		WARN_ON_ONCE(ret);
 	}


