Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE2124B5B6
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbgHTK1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731677AbgHTKWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:22:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46BB520658;
        Thu, 20 Aug 2020 10:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918954;
        bh=peVkpFOhZGuRw9SB7/KqhBJFgfeMdu5lbq25QTO9714=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+k6iEPcYyiNWFXbUhGJRRaRV0GtOnPk8OQxKhqh8+iqYohQgkr6GqLIQ4JyU3qE+
         3vF/wtwydbbiqXUGtWoUCoFPPNcKEMrJ2xJOoUO4J6lligmYkjz+PXIqsE4AOHYOSV
         4pCgpnsp/VjHArUjitfaegrxLQznebxd+fuHTOQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 128/149] mac80211: fix misplaced while instead of if
Date:   Thu, 20 Aug 2020 11:23:25 +0200
Message-Id: <20200820092131.904271328@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
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
@@ -906,7 +906,7 @@ static void __sta_info_destroy_part2(str
 	might_sleep();
 	lockdep_assert_held(&local->sta_mtx);
 
-	while (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
+	if (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
 		ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 		WARN_ON_ONCE(ret);
 	}


