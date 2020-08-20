Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A09A24B37C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgHTJrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729423AbgHTJrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:47:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94B3E20724;
        Thu, 20 Aug 2020 09:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916873;
        bh=0r476CZefNg6z1mu1eOCPZYFPBbeVIl0xPyCXY1Ajmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FPyADIf0Cq6fhzuHYpkejrQpXrTiqmOTZkbvIKGkofiPJf5jDalrCIZHY4aKZSlWk
         afsB6rRC2s0Fgw/1mwRrF9Opi874zazssM0ROPK4xFINgcjoA8kHmjafOSvhlY7ZlJ
         4V2mJpbLtlfiUvcUc8mCwUSpc2NNYk+m2SRN1ac0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 047/152] mac80211: fix misplaced while instead of if
Date:   Thu, 20 Aug 2020 11:20:14 +0200
Message-Id: <20200820091556.107422877@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
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
@@ -1033,7 +1033,7 @@ static void __sta_info_destroy_part2(str
 	might_sleep();
 	lockdep_assert_held(&local->sta_mtx);
 
-	while (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
+	if (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
 		ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 		WARN_ON_ONCE(ret);
 	}


