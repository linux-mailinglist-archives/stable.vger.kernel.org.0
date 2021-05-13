Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D504437FABD
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhEMPcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhEMPce (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:32:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F16456143F;
        Thu, 13 May 2021 15:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620919884;
        bh=QYsZB1y5jYdSiOrJlmPeqGrWNpyyiCrk4+r898vhNKw=;
        h=Subject:To:From:Date:From;
        b=viCKRIADDwhYAV5x5V5MEexKicYIqt9IgB093+QwE3HQ/QVHyL6QhwJjVvPbK4bHS
         /OQzTBEW8gwTzWBIdKweuFpPxLLJVRQpXFTNisLz/GCawskWum6wAUFnVtjCdkNmmv
         frFBcZIpeqHGIN/crPXa9aKTRhxNWJcnrWQa5R6U=
Subject: patch "Revert "rtlwifi: fix a potential NULL pointer dereference"" added to char-misc-linus
To:     gregkh@linuxfoundation.org, hello@bryanbrattlof.com, kjlu@umn.edu,
        kvalo@codeaurora.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:31:05 +0200
Message-ID: <1620919865230204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "rtlwifi: fix a potential NULL pointer dereference"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 68c5634c4a7278672a3bed00eb5646884257c413 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:56:39 +0200
Subject: Revert "rtlwifi: fix a potential NULL pointer dereference"

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
Link: https://lore.kernel.org/r/20210503115736.2104747-13-gregkh@linuxfoundation.org
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


