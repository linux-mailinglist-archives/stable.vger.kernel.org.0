Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8685817FE7F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgCJMn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbgCJMn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:43:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06DA924686;
        Tue, 10 Mar 2020 12:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844237;
        bh=zelQCojRdjTRJfT/utokvhhGatHdiVoh5veId4tJeag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1DkBiyFMHB81QRoaEVnEF2rMml+6DKV/A4NcwESl6UZAWa5tbA4C2YLyX/TiVxNn
         eaZlulIdtsJ4ygoGoWCL5PtOG4pwvbQ5jC+LIqWk/rufXHA6trInUo5xk8/lrHxXHQ
         9+nfforcqX/fJTU3GP5Cf8cr69sEkYJP3oRu0w9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ajay Kaher <akaher@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 01/88] iwlwifi: pcie: fix rb_allocator workqueue allocation
Date:   Tue, 10 Mar 2020 13:38:09 +0100
Message-Id: <20200310123606.848982431@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
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
[Ajay: Rewrote this patch for v4.9.y, as 4.9.y codebase is different from mainline]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index a2ebe46bcfc5b..395bbe2c0f983 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -898,9 +898,13 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 			return err;
 	}
 	def_rxq = trans_pcie->rxq;
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



