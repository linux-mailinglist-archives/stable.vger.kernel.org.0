Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A24429107
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243977AbhJKOO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239831AbhJKOM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:12:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C4B360F21;
        Mon, 11 Oct 2021 14:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961036;
        bh=Sa7aI8yrea0RsQR0jfcq3Sd19V1UsA6qiIfmHushLHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHlkyDkmZ230AAFFCJJflBk7zZ6H1f+ofK6byszcne0DAtI0kcRJNyliMwULKtZUQ
         iiqh9dhOOig1q/D6f8dcwp+F5mEkhG75bh3XabUsI/4UFzeBj9c+oLjKMgQpwVOJPf
         Sv9Gnzeap6gylGyhclaK+66wJjMt+h0JWz2AS3FM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Stefan Assmann <sassmann@kpanic.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 116/151] iavf: fix double unlock of crit_lock
Date:   Mon, 11 Oct 2021 15:46:28 +0200
Message-Id: <20211011134521.564466672@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit 54ee39439acd9f8b161703c6ad4f4e1835585277 ]

The crit_lock mutex could be unlocked twice as reported here
https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210823/025525.html

Remove the superfluous unlock. Technically the problem was already
present before 5ac49f3c2702 as that commit only replaced the locking
primitive, but no functional change.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 5ac49f3c2702 ("iavf: use mutexes for locking of critical sections")
Fixes: bac8486116b0 ("iavf: Refactor the watchdog state machine")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 23762a7ef740..cada4e0e40b4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1965,7 +1965,6 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
-- 
2.33.0



