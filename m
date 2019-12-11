Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9AD011B584
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732034AbfLKPRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:17:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729663AbfLKPRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:17:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 531EB24682;
        Wed, 11 Dec 2019 15:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077457;
        bh=V80Xt/F5molGZym4VsMs8r/TwMbFXOPehtRwwyqzMC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+yMSgwkJD/gcLI1UFUoCZ9NS6CIghrbqN0k/qv7k/8myNOaPSFWsjgmOt1KXWH+f
         Hi86mFVY2nm7iRPr3e0n7C7+gzfvU5F3OiHNUCs3LnfYhowjArB+yHFxg2QGtUeh+h
         HVBhvEX8bWbIp8Wzu7H7YPHg1SwcYRsgrZbOyvuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/243] iwlwifi: mvm: synchronize TID queue removal
Date:   Wed, 11 Dec 2019 16:03:11 +0100
Message-Id: <20191211150340.826896898@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 06bc6f6ed4ae0246a5e52094d1be90906a1361c7 ]

When we mark a TID as no longer having a queue, there's no
guarantee the TX path isn't using this txq_id right now,
having accessed it just before we reset the value. To fix
this, add synchronize_net() when we change the TIDs from
having a queue to not having one, so that we can then be
sure that the TX path is no longer accessing that queue.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 04ea516bddcc0..e850aa504b608 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -440,6 +440,16 @@ static int iwl_mvm_remove_sta_queue_marking(struct iwl_mvm *mvm, int queue)
 
 	rcu_read_unlock();
 
+	/*
+	 * The TX path may have been using this TXQ_ID from the tid_data,
+	 * so make sure it's no longer running so that we can safely reuse
+	 * this TXQ later. We've set all the TIDs to IWL_MVM_INVALID_QUEUE
+	 * above, but nothing guarantees we've stopped using them. Thus,
+	 * without this, we could get to iwl_mvm_disable_txq() and remove
+	 * the queue while still sending frames to it.
+	 */
+	synchronize_net();
+
 	return disable_agg_tids;
 }
 
-- 
2.20.1



