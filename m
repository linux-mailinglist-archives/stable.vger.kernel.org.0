Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82BB3F63EB
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbhHXQ7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237888AbhHXQ6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B572761357;
        Tue, 24 Aug 2021 16:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824229;
        bh=iFZD3EUwr3qMB1k2li68u9oMJ2KEEa45qBAseRPycl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyY+kF8FeunSXko4ZuSmDB6YqXJ117OcqyBpF9aU5OFjEK4vmA8UFzy9hjaOFmmvf
         Gf67vDGLMlcBm2FMFOoJBenY9tXkoOvf8UiH4XlmixaeNGT0s0Fts8qtDKorNFgPf2
         IanNpAJ9G8wrrdqawG9cFD57r/z4c81pJTx9gp5WyvhWj0VLR28jxrud9WtcBe+td6
         rhibh9R54Oq6+O8guqygE5ntx4mSOyp6lOwKwKxvO+CTHAlBxASORPJXAqPoO6ShDl
         MYTH8C29xNckmHpkG2UHMLq9GEGS0iLW89nNEaQMBwBYJ+2ATLcplfGCl8Jsz8eLqs
         865OEcGsTGWhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 062/127] mac80211: fix locking in ieee80211_restart_work()
Date:   Tue, 24 Aug 2021 12:55:02 -0400
Message-Id: <20210824165607.709387-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 276e189f8e4e3cce1634d6bac4ed0d9ca242441b ]

Ilan's change to move locking around accidentally lost the
wiphy_lock() during some porting, add it back.

Fixes: 45daaa131841 ("mac80211: Properly WARN on HW scan before restart")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20210817121210.47bdb177064f.Ib1ef79440cd27f318c028ddfc0c642406917f512@changeid
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2481bfdfafd0..efe5c3295455 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -260,6 +260,8 @@ static void ieee80211_restart_work(struct work_struct *work)
 	flush_work(&local->radar_detected_work);
 
 	rtnl_lock();
+	/* we might do interface manipulations, so need both */
+	wiphy_lock(local->hw.wiphy);
 
 	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
 	     "%s called with hardware scan in progress\n", __func__);
-- 
2.30.2

