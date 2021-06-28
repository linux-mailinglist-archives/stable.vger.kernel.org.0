Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5163B63AD
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhF1O6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236989AbhF1O4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:56:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 773E161CC4;
        Mon, 28 Jun 2021 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891221;
        bh=ThBSO06UKB7mlVCJTUyvOhXnkl1Q5NbivqCM/cNJTS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g29yQZo6f0MezaGbYRjCcBCVjCVKxyZE9muLBTZfoElCYEEyTI9cWSibEqRwjYuEZ
         cArRFS3o/QQxJZP6SD57pKD7y0pxMSkUGjI+DFdL2hxjobVYyRNkWNs0IQeZ1r6cl7
         ndEqGCAFeSIX6CLEWQ4Ms6yq+3TiZDAeuwYJiWDS6GPzReanpXx0NQ5iSfqOP/HE73
         jKzvRx7hz14c4Me4KExaxePvlzs5l6AAr2nHBc9i5jaaGr3xkoAdUmnuA0OomqNqAC
         fazKBnI+FR7GWvJduCGHfYPdwtfEaTMxsX8shEGagCwC8Zy9j/PyN6a0Nr0HTr8R2t
         Z06ZBBRvy/d8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot+c0b807de416427ff3dd1@syzkaller.appspotmail.com,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 18/71] batman-adv: Avoid WARN_ON timing related checks
Date:   Mon, 28 Jun 2021 10:39:10 -0400
Message-Id: <20210628144003.34260-19-sashal@kernel.org>
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

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 9f460ae31c4435fd022c443a6029352217a16ac1 ]

The soft/batadv interface for a queued OGM can be changed during the time
the OGM was queued for transmission and when the OGM is actually
transmitted by the worker.

But WARN_ON must be used to denote kernel bugs and not to print simple
warnings. A warning can simply be printed using pr_warn.

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Reported-by: syzbot+c0b807de416427ff3dd1@syzkaller.appspotmail.com
Fixes: ef0a937f7a14 ("batman-adv: consider outgoing interface in OGM sending")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 2b663622bdb4..f85e6a9ee5ea 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -585,8 +585,10 @@ static void batadv_iv_ogm_emit(struct batadv_forw_packet *forw_packet)
 	if (WARN_ON(!forw_packet->if_outgoing))
 		return;
 
-	if (WARN_ON(forw_packet->if_outgoing->soft_iface != soft_iface))
+	if (forw_packet->if_outgoing->soft_iface != soft_iface) {
+		pr_warn("%s: soft interface switch for queued OGM\n", __func__);
 		return;
+	}
 
 	if (forw_packet->if_incoming->if_status != BATADV_IF_ACTIVE)
 		return;
-- 
2.30.2

