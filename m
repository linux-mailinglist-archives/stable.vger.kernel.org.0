Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFAC34C60B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhC2IEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231381AbhC2IDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:03:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FDA661477;
        Mon, 29 Mar 2021 08:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005033;
        bh=E8E3yMYgdHqnln8qh5YZzz0QoMWvj530Q8pTa26fGsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmfU1H8AXqYsk/usgIEOVBqLCg/Ap26LUGlggXEgGQjzEV170h+Dg2GqNQmaLXNIm
         7Mpou++wOR6d+1NIZ4ofwRWD57tr0lj3rwNj/eGP8IXHq4FtsG9j86HcgLSsZtd034
         bZ5GgdmBdWNUsvUQ3EbnrEjhG2Y/s7JHpBZih/Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vitaly Lifshits <vitaly.lifshits@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 24/53] e1000e: add rtnl_lock() to e1000_reset_task
Date:   Mon, 29 Mar 2021 09:57:59 +0200
Message-Id: <20210329075608.333369956@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

[ Upstream commit 21f857f0321d0d0ea9b1a758bd55dc63d1cb2437 ]

A possible race condition was found in e1000_reset_task,
after discovering a similar issue in igb driver via
commit 024a8168b749 ("igb: reinit_locked() should be called
with rtnl_lock").

Added rtnl_lock() and rtnl_unlock() to avoid this.

Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 3c01bc43889a..46323019aa63 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5920,15 +5920,19 @@ static void e1000_reset_task(struct work_struct *work)
 	struct e1000_adapter *adapter;
 	adapter = container_of(work, struct e1000_adapter, reset_task);
 
+	rtnl_lock();
 	/* don't run the task if already down */
-	if (test_bit(__E1000_DOWN, &adapter->state))
+	if (test_bit(__E1000_DOWN, &adapter->state)) {
+		rtnl_unlock();
 		return;
+	}
 
 	if (!(adapter->flags & FLAG_RESTART_NOW)) {
 		e1000e_dump(adapter);
 		e_err("Reset adapter unexpectedly\n");
 	}
 	e1000e_reinit_locked(adapter);
+	rtnl_unlock();
 }
 
 /**
-- 
2.30.1



