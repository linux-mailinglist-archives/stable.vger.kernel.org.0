Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788273B63F8
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbhF1PCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235121AbhF1PAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:00:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40B7561D71;
        Mon, 28 Jun 2021 14:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891254;
        bh=YjMQQNSfaScEzvJu+y3rMQN1J8VxpsR+ojdXx1M6n7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVwz7w2f5DjrcCl3Awqj1Wer5jl/dRedO8j0yUiWc8CHQfoWPemoIkvGGk/YIEhPb
         X12d6TcpIo70OZRA0iugAg34WyfZUQ4/qa3apewmV6PGQ71XLopLjfHIjohM0BmtV5
         GXSFHuB+OhdudgY+mHnm7F+Or+IuyTo5ecsDYOR0mWEv3+97NumQsHL0wz00Hp4+l7
         3ttOI/kf/vp3oxP+C1QqvMgIKEky3pEloZxbfsDX1DP3pEUDuaI7fa5k+Pm0DeKfN3
         vEGA9IKb2zKd0tJV4ZS/I4K7Ykqb+Gi0hxNP8jF+629rc6Wa6VonIh8kTCdMuaLlQ9
         RyOB46mW6SI4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Du Cheng <ducheng2@gmail.com>,
        syzbot+105896fac213f26056f9@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 57/71] cfg80211: call cfg80211_leave_ocb when switching away from OCB
Date:   Mon, 28 Jun 2021 10:39:49 -0400
Message-Id: <20210628144003.34260-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

[ Upstream commit a64b6a25dd9f984ed05fade603a00e2eae787d2f ]

If the userland switches back-and-forth between NL80211_IFTYPE_OCB and
NL80211_IFTYPE_ADHOC via send_msg(NL80211_CMD_SET_INTERFACE), there is a
chance where the cleanup cfg80211_leave_ocb() is not called. This leads
to initialization of in-use memory (e.g. init u.ibss while in-use by
u.ocb) due to a shared struct/union within ieee80211_sub_if_data:

struct ieee80211_sub_if_data {
    ...
    union {
        struct ieee80211_if_ap ap;
        struct ieee80211_if_vlan vlan;
        struct ieee80211_if_managed mgd;
        struct ieee80211_if_ibss ibss; // <- shares address
        struct ieee80211_if_mesh mesh;
        struct ieee80211_if_ocb ocb; // <- shares address
        struct ieee80211_if_mntr mntr;
        struct ieee80211_if_nan nan;
    } u;
    ...
}

Therefore add handling of otype == NL80211_IFTYPE_OCB, during
cfg80211_change_iface() to perform cleanup when leaving OCB mode.

link to syzkaller bug:
https://syzkaller.appspot.com/bug?id=0612dbfa595bf4b9b680ff7b4948257b8e3732d5

Reported-by: syzbot+105896fac213f26056f9@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Link: https://lore.kernel.org/r/20210428063941.105161-1-ducheng2@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 939320571d71..a16e805c4857 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1050,6 +1050,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		case NL80211_IFTYPE_MESH_POINT:
 			/* mesh should be handled? */
 			break;
+		case NL80211_IFTYPE_OCB:
+			cfg80211_leave_ocb(rdev, dev);
+			break;
 		default:
 			break;
 		}
-- 
2.30.2

