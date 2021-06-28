Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B613B5FF6
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbhF1OVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232738AbhF1OVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0ACC61C75;
        Mon, 28 Jun 2021 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889934;
        bh=EKWFR62OC53Ool/73TihiUZRikghbx9/5caVVvFCek4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRDQQ4CUjE75qU0eU2g3wcly3ZBuCfBHVSEFWL76xg8VgQcIsT9XVf37PvvSxSAiS
         D/3TaMhsZIjzP3Jv3QBqBMG1CjddFxpr+i/MKWvMsFousZOuKckAisEEIoGpovHpFT
         nYJHL2B+FelGLAhQ+I5L7E+kMM4N40CYWwGNEsO2pGB0xuJtZBhRFkQszVqQnIsIK+
         RkCnF5KpPQAjCNRZQInqTE9C9b4REwKncKeVJsSmvEWvndZBN3ii/REeV98DwqEYBA
         3kzblMJblPjQyYhEdAu+K9mKQBFkkKfu9TPnrKVkTLh5L2QMUmOnrPiiDJmTN4KUO1
         pezJqCue7fVRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Du Cheng <ducheng2@gmail.com>,
        syzbot+105896fac213f26056f9@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 028/110] cfg80211: call cfg80211_leave_ocb when switching away from OCB
Date:   Mon, 28 Jun 2021 10:17:06 -0400
Message-Id: <20210628141828.31757-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index f342b6147675..726e7d2342bd 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1059,6 +1059,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
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

