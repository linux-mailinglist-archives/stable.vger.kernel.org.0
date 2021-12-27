Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4043D47FFBC
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238602AbhL0Pk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:40:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38870 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239166AbhL0Piz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:38:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A6F5610A5;
        Mon, 27 Dec 2021 15:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40930C36AEB;
        Mon, 27 Dec 2021 15:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619535;
        bh=aMf62lmELlMgl/sZ1vAVs3WnmW2vcCiO5X1r7qp5b6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLyjE6fllmXuUnyvCe4VqznqykJhB6v1jRWm4EafdBNzWcTZvfOzkyum8urlvM/kH
         jrI74DA/PbAzjrqLjDgFZl2VN3QrBF6iosIx6VA6i+T81eiWbcfi/ucsYZwE9ZEWkl
         C4qqLwC7BrBX7G3C5EYzsaN+s2dMPU/+evK4q0p0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+11c342e5e30e9539cabd@syzkaller.appspotmail.com
Subject: [PATCH 5.10 57/76] mac80211: fix locking in ieee80211_start_ap error path
Date:   Mon, 27 Dec 2021 16:31:12 +0100
Message-Id: <20211227151326.672695122@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 87a270625a89fc841f1a7e21aae6176543d8385c upstream.

We need to hold the local->mtx to release the channel context,
as even encoded by the lockdep_assert_held() there. Fix it.

Cc: stable@vger.kernel.org
Fixes: 295b02c4be74 ("mac80211: Add FILS discovery support")
Reported-and-tested-by: syzbot+11c342e5e30e9539cabd@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20211220090836.cee3d59a1915.I36bba9b79dc2ff4d57c3c7aa30dff9a003fe8c5c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1217,7 +1217,10 @@ static int ieee80211_start_ap(struct wip
 	return 0;
 
 error:
+	mutex_lock(&local->mtx);
 	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&local->mtx);
+
 	return err;
 }
 


