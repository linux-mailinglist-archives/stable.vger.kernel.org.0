Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10F0111D09
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbfLCWtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:49:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728950AbfLCWtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:49:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0016320863;
        Tue,  3 Dec 2019 22:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413381;
        bh=RuXCy8MiSHwkFqpJv3UmmnKuGufeTgueNF/f4E5Vf+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHbjCVSv0PhmiUshCxLUyLE2wbFzkjT9wkLGlTGTJgViuTu9QT32Sl0lJ/tznvr+D
         vAZ/HWPYO9JIzRNQHoMVS3Rn5VPFxwRjcLZCsAiWmuO6RkfxcsRF1uMU4XU9UQ0cgN
         mOn8dV19pNyyJF3h7Ac1CkKTd3aI//IPZVAp3aRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/321] iwlwifi: mvm: force TCM re-evaluation on TCM resume
Date:   Tue,  3 Dec 2019 23:32:52 +0100
Message-Id: <20191203223432.666549212@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 7bc2468277033e05401d5f8fd48a772f407338c2 ]

When traffic load is not low or low latency is active, TCM schedules
re-evaluation work so in case traffic stops TCM will detect that
traffic load has become low or that low latency is no longer active.
However, if TCM is paused when the re-evaluation work runs, it does
not re-evaluate and the re-evaluation work is no longer scheduled.
As a result, TCM will not indicate that low latency is no longer
active or that traffic load is low when traffic stops.

Fix this by forcing TCM re-evaluation when TCM is resumed in case
low latency is active or traffic load is not low.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 6a5349401aa99..00712205c05f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1804,6 +1804,7 @@ void iwl_mvm_pause_tcm(struct iwl_mvm *mvm, bool with_cancel)
 void iwl_mvm_resume_tcm(struct iwl_mvm *mvm)
 {
 	int mac;
+	bool low_latency = false;
 
 	spin_lock_bh(&mvm->tcm.lock);
 	mvm->tcm.ts = jiffies;
@@ -1815,10 +1816,23 @@ void iwl_mvm_resume_tcm(struct iwl_mvm *mvm)
 		memset(&mdata->tx.pkts, 0, sizeof(mdata->tx.pkts));
 		memset(&mdata->rx.airtime, 0, sizeof(mdata->rx.airtime));
 		memset(&mdata->tx.airtime, 0, sizeof(mdata->tx.airtime));
+
+		if (mvm->tcm.result.low_latency[mac])
+			low_latency = true;
 	}
 	/* The TCM data needs to be reset before "paused" flag changes */
 	smp_mb();
 	mvm->tcm.paused = false;
+
+	/*
+	 * if the current load is not low or low latency is active, force
+	 * re-evaluation to cover the case of no traffic.
+	 */
+	if (mvm->tcm.result.global_load > IWL_MVM_TRAFFIC_LOW)
+		schedule_delayed_work(&mvm->tcm.work, MVM_TCM_PERIOD);
+	else if (low_latency)
+		schedule_delayed_work(&mvm->tcm.work, MVM_LL_PERIOD);
+
 	spin_unlock_bh(&mvm->tcm.lock);
 }
 
-- 
2.20.1



