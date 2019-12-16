Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4A112127B
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLPRxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbfLPRxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:53:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85D272166E;
        Mon, 16 Dec 2019 17:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518780;
        bh=l8vmj9ogPn3skiz7aMXSpTKDK2qnZilRS/XoaFSQH+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z66n1GUZEHICxigzWn7OJ6lEf96Tm26RSwJO4ewL6Jtxk5Ac5K/BvUPL/ZlI2xMU7
         h0/fk8XDp6ZzxEp5/BWjJk3ifuZsINcS7gN9ZV/kmXSaIGm6H54SapKoCrhCp0to/7
         KhAxfRk7x7WmfhUi18189pM2AYJ+fF5Jc7nZSBRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 024/267] iwlwifi: mvm: synchronize TID queue removal
Date:   Mon, 16 Dec 2019 18:45:50 +0100
Message-Id: <20191216174851.549379891@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index d16e2ed4419fe..0cfdbaa2af3a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -436,6 +436,16 @@ static int iwl_mvm_remove_sta_queue_marking(struct iwl_mvm *mvm, int queue)
 
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



