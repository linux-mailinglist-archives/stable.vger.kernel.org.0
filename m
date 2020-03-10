Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B142217F794
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgCJMkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgCJMkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:40:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C31924686;
        Tue, 10 Mar 2020 12:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844039;
        bh=IdntsGZLSt9J7mVOpIa0Dd9fmT7qJTZmAKiJ51naKDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lad9p1BmjffmNn0NtqX18iQS+WYTOncNqCryf7FrKGhSue1a+5QWP+0kAT5FBNfVt
         lLf8uCKO/AK/ZJYfUzVoW+GDHK5+ryufv2koZ74HMuBSVXUkrfDSv7VtkE3fdkC3gQ
         NTx2an99WMPICLUU1dzC/h+RHhpALaeb1L/LqJ9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ajay Kaher <akaher@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/72] iwlwifi: pcie: fix rb_allocator workqueue allocation
Date:   Tue, 10 Mar 2020 13:38:14 +0100
Message-Id: <20200310123601.631803602@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 8188a18ee2e48c9a7461139838048363bfce3fef upstream

We don't handle failures in the rb_allocator workqueue allocation
correctly. To fix that, move the code earlier so the cleanup is
easier and we don't have to undo all the interrupt allocations in
this case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
[Ajay: Rewrote this patch for v4.4.y, as 4.4.y codebase is different from mainline]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index d6f9858ff2de4..7fdb3ad9f53d8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -708,9 +708,13 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 		if (err)
 			return err;
 	}
-	if (!rba->alloc_wq)
+	if (!rba->alloc_wq) {
 		rba->alloc_wq = alloc_workqueue("rb_allocator",
 						WQ_HIGHPRI | WQ_UNBOUND, 1);
+		if (!rba->alloc_wq)
+			return -ENOMEM;
+	}
+
 	INIT_WORK(&rba->rx_alloc, iwl_pcie_rx_allocator_work);
 
 	cancel_work_sync(&rba->rx_alloc);
-- 
2.20.1



