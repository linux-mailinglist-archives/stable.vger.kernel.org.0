Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04841111C82
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfLCWos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:44:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:32802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728663AbfLCWor (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:44:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F61206EC;
        Tue,  3 Dec 2019 22:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413086;
        bh=NHzBsxP56xjA1s7nkjexOr7DjOW7Bmyz1+WJUlNZdFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhD83EZCs0rRxZtc0mTFwSJcWmgNKj9gY2Vhrg1mFeN8plkZ+x/t4utc2/P5kn/pZ
         wKSnL77IRnIU0NtQiUY5VmblPToxsSxP7ArC6AY3AKXKhXuaO6/CjGroHPX3FY3C5g
         Dr9N/s0VFg6u4tYCjG2RB0JIxzfZdLCFPYT3gLck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 089/135] mac80211: fix ieee80211_txq_setup_flows() failure path
Date:   Tue,  3 Dec 2019 23:35:29 +0100
Message-Id: <20191203213036.056617451@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6dd47d9754ff0589715054b11294771f2c9a16ac ]

If ieee80211_txq_setup_flows() fails, we don't clean up LED
state properly, leading to crashes later on, fix that.

Fixes: dc8b274f0952 ("mac80211: Move up init of TXQs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://lore.kernel.org/r/20191105154110.1ccf7112ba5d.I0ba865792446d051867b33153be65ce6b063d98c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4c2702f128f3a..868705ed5cbbb 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1297,8 +1297,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	ieee80211_remove_interfaces(local);
  fail_rate:
 	rtnl_unlock();
-	ieee80211_led_exit(local);
  fail_flows:
+	ieee80211_led_exit(local);
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
 	wiphy_unregister(local->hw.wiphy);
-- 
2.20.1



