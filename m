Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875073714A8
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhECL7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 07:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233159AbhECL7u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 07:59:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AADF61185;
        Mon,  3 May 2021 11:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043137;
        bh=g1tOpKVPnvyJA/ZiAz0Ix/eQbFE0id+QJ90BSgu9Tow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnO7a4lHZ5gS5Ohutab2U9u+Rf8oe41PzoZ/Tmqv6si9Gm+6TXiBT6SyhwDpYnsZ1
         DQkAnUB9sd69+F92SHmXm4hjI5kJxAtiPXe9CWWX6XwQLVzqILhStw4JgY5wS9tbjL
         8x6ZzLoZ7PnrqI0VlvFWxBRkwP+6HoGc1+FAPpTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        Bryan Brattlof <hello@bryanbrattlof.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 12/69] Revert "rtlwifi: fix a potential NULL pointer dereference"
Date:   Mon,  3 May 2021 13:56:39 +0200
Message-Id: <20210503115736.2104747-13-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 765976285a8c8db3f0eb7f033829a899d0c2786e.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

This commit is not correct, it should not have used unlikely() and is
not propagating the error properly to the calling function, so it should
be reverted at this point in time.  Also, if the check failed, the
work queue was still assumed to be allocated, so further accesses would
have continued to fail, meaning this patch does nothing to solve the
root issues at all.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Bryan Brattlof <hello@bryanbrattlof.com>
Fixes: 765976285a8c ("rtlwifi: fix a potential NULL pointer dereference")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 2a7ee90a3f54..4136d7c63254 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -452,11 +452,6 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
 	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
-	if (unlikely(!rtlpriv->works.rtl_wq)) {
-		pr_err("Failed to allocate work queue\n");
-		return;
-	}
-
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
-- 
2.31.1

