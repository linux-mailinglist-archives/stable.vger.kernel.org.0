Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13C2420FAB
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237876AbhJDNhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237379AbhJDNfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1325963237;
        Mon,  4 Oct 2021 13:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353348;
        bh=dkaVwAlz6CyVqyM8xECrBznTqLQIOxNjSqT/gmsxpwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtU6vFaLgD9nvCTDtmlI/J0ncvTm8SYAv2BPQgsVY89vpxWCrXwRnoYAJXK2sumH7
         0o3QwmAp8OTLGwvGdOVpGbjxsggRXMSbPNB+Y1Kz9IWGarq8oc0CBYWWA2PFj17Lg4
         YeGy+ux2N6kkCaCIYM8ruPvNmp+tJ1cLDAJfINKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot+0e964fad69a9c462bc1e@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 092/172] mac80211-hwsim: fix late beacon hrtimer handling
Date:   Mon,  4 Oct 2021 14:52:22 +0200
Message-Id: <20211004125047.963354066@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 313bbd1990b6ddfdaa7da098d0c56b098a833572 ]

Thomas explained in https://lore.kernel.org/r/87mtoeb4hb.ffs@tglx
that our handling of the hrtimer here is wrong: If the timer fires
late (e.g. due to vCPU scheduling, as reported by Dmitry/syzbot)
then it tries to actually rearm the timer at the next deadline,
which might be in the past already:

 1          2          3          N          N+1
 |          |          |   ...    |          |

 ^ intended to fire here (1)
            ^ next deadline here (2)
                                      ^ actually fired here

The next time it fires, it's later, but will still try to schedule
for the next deadline (now 3), etc. until it catches up with N,
but that might take a long time, causing stalls etc.

Now, all of this is simulation, so we just have to fix it, but
note that the behaviour is wrong even per spec, since there's no
value then in sending all those beacons unaligned - they should be
aligned to the TBTT (1, 2, 3, ... in the picture), and if we're a
bit (or a lot) late, then just resume at that point.

Therefore, change the code to use hrtimer_forward_now() which will
ensure that the next firing of the timer would be at N+1 (in the
picture), i.e. the next interval point after the current time.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: syzbot+0e964fad69a9c462bc1e@syzkaller.appspotmail.com
Fixes: 01e59e467ecf ("mac80211_hwsim: hrtimer beacon")
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210915112936.544f383472eb.I3f9712009027aa09244b65399bf18bf482a8c4f1@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ffa894f7312a..0adae76eb8df 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1867,8 +1867,8 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 		bcn_int -= data->bcn_delta;
 		data->bcn_delta = 0;
 	}
-	hrtimer_forward(&data->beacon_timer, hrtimer_get_expires(timer),
-			ns_to_ktime(bcn_int * NSEC_PER_USEC));
+	hrtimer_forward_now(&data->beacon_timer,
+			    ns_to_ktime(bcn_int * NSEC_PER_USEC));
 	return HRTIMER_RESTART;
 }
 
-- 
2.33.0



