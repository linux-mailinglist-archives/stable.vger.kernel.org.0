Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFFC38ED19
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbhEXPdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:33:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233274AbhEXPcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:32:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E187F613D0;
        Mon, 24 May 2021 15:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870258;
        bh=PwZyXvvsQj6OH8etcpIiEPUTgcPTFwVs5Hi0HRYzK9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBkzR++1TuJHonhvi4tt6pgJwMPhr3RNASpEFcfAl5lzZ3+RyCtYoQHR0TxEpY/JO
         yDwPjpugvNAmEGXwN75CE9ZoJUsqXrafYLqnQTpxAK/rYi7OWFd+gg+rzkwm5LurRQ
         YrM4zktX562rH2rFRZNCWINd++lpFRXQcbEdZ9M8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Bryan Brattlof <hello@bryanbrattlof.com>
Subject: [PATCH 4.4 20/31] Revert "rtlwifi: fix a potential NULL pointer dereference"
Date:   Mon, 24 May 2021 17:25:03 +0200
Message-Id: <20210524152323.582040033@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152322.919918360@linuxfoundation.org>
References: <20210524152322.919918360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 68c5634c4a7278672a3bed00eb5646884257c413 upstream.

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
 drivers/net/wireless/realtek/rtlwifi/base.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -466,11 +466,6 @@ static void _rtl_init_deferred_work(stru
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
 	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
-	if (unlikely(!rtlpriv->works.rtl_wq)) {
-		pr_err("Failed to allocate work queue\n");
-		return;
-	}
-
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,


