Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6AF4AA53A
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 02:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241639AbiBEBCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 20:02:37 -0500
Received: from mga04.intel.com ([192.55.52.120]:3577 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233537AbiBEBCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Feb 2022 20:02:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644022957; x=1675558957;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xkyVW7E/+O7tWkj/9uNn3xGmnPUBci6DZeRuJO3bhE0=;
  b=bGL/Km8tyjNS+bp5TX/DfqHR0C0TivoBMbaeuJoO7d4L1EqgIbPTYDmB
   nN2c4qeErWKg138eYAGGpgee0uOIlITZxNNatwZ0nzYDB5be8RNu48DaC
   uTbtTj5u1xBst/v6tOTH+St9UqAgNHg/TaOLjFT2x8quL+ms2sPjBMMga
   Iz0JnHeSvRLMUPLLixjDaAGidk7ZYclKQg1P9F5Yl7glCHEtZ6uGuqtdL
   lkUN7PQ40ykIUNF9JhPh42GnNuU7O4CqV3iEF1Q+BFnBJVviNPDg3MnK5
   7wCXl20ok8a9G4ufii6oKjVVCBLrkoWYlhcXl2o01blxQIXM+zzC8Hkjn
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="247303919"
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="247303919"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 17:02:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="535690177"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.231.200])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 17:02:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()
Date:   Fri,  4 Feb 2022 17:02:31 -0800
Message-Id: <20220205010231.189151-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8e9eacad7ec7a9cbf262649ebf1fa6e6f6cc7d82 upstream.

The upstream commit had to handle a lookup_by_id variable that is only
present in 5.17. This version of the patch removes that variable, so the
__lookup_addr() function only handles the lookup as it is implemented in
5.15 and 5.16. It also removes one 'const' keyword to prevent a warning
due to differing const-ness in the 5.17 version of addresses_equal().

The MPTCP endpoint list is under RCU protection, guarded by the
pernet spinlock. mptcp_nl_cmd_set_flags() traverses the list
without acquiring the spin-lock nor under the RCU critical section.

This change addresses the issue performing the lookup and the endpoint
update under the pernet spinlock.

Cc: <stable@vger.kernel.org> # 5.15.x
Cc: <stable@vger.kernel.org> # 5.16.x
Fixes: 0f9f696a502e ("mptcp: add set_flags command in PM netlink")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 65764c8171b3..5d305fafd0e9 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -459,6 +459,18 @@ static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullm
 	return i;
 }
 
+static struct mptcp_pm_addr_entry *
+__lookup_addr(struct pm_nl_pernet *pernet, struct mptcp_addr_info *info)
+{
+	struct mptcp_pm_addr_entry *entry;
+
+	list_for_each_entry(entry, &pernet->local_addr_list, list) {
+		if (addresses_equal(&entry->addr, info, true))
+			return entry;
+	}
+	return NULL;
+}
+
 static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
@@ -1725,17 +1737,21 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 	if (addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
 		bkup = 1;
 
-	list_for_each_entry(entry, &pernet->local_addr_list, list) {
-		if (addresses_equal(&entry->addr, &addr.addr, true)) {
-			mptcp_nl_addr_backup(net, &entry->addr, bkup);
-
-			if (bkup)
-				entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
-			else
-				entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
-		}
+	spin_lock_bh(&pernet->lock);
+	entry = __lookup_addr(pernet, &addr.addr);
+	if (!entry) {
+		spin_unlock_bh(&pernet->lock);
+		return -EINVAL;
 	}
 
+	if (bkup)
+		entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
+	else
+		entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
+	addr = *entry;
+	spin_unlock_bh(&pernet->lock);
+
+	mptcp_nl_addr_backup(net, &addr.addr, bkup);
 	return 0;
 }
 
-- 
2.35.1

