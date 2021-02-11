Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD95318E30
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhBKPWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:22:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230013AbhBKPRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:17:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F343464F04;
        Thu, 11 Feb 2021 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055923;
        bh=cLcsa51PyK+Y+1DrJUenXnA+a2UDeaAi47p99Do7Sq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5cOwd0C3qmDESReSDdqM/qgsG2/so7m2xTONeGFXmKD7rkX3le4K/FM+VGkl17ql
         bYpxKJE6nELiJslxtBBjLdASaOP9qr2C2xabxrIY3mSNHG0NHEmPOI46tXmEYEkaq9
         JHkmDz5XiNMp9mrIevY15OaxbytUnAa3H/Uffn/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/54] iwlwifi: queue: bail out on invalid freeing
Date:   Thu, 11 Feb 2021 16:02:22 +0100
Message-Id: <20210211150154.536382640@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0bed6a2a14afaae240cc431e49c260568488b51c ]

If we find an entry without an SKB, we currently continue, but
that will just result in an infinite loop since we won't increment
the read pointer, and will try the same thing over and over again.
Fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210122144849.abe2dedcc3ac.Ia6b03f9eeb617fd819e56dd5376f4bb8edc7b98a@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/queue/tx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.c b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
index af0b27a68d84d..9181221a2434d 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
@@ -887,10 +887,8 @@ void iwl_txq_gen2_unmap(struct iwl_trans *trans, int txq_id)
 			int idx = iwl_txq_get_cmd_index(txq, txq->read_ptr);
 			struct sk_buff *skb = txq->entries[idx].skb;
 
-			if (WARN_ON_ONCE(!skb))
-				continue;
-
-			iwl_txq_free_tso_page(trans, skb);
+			if (!WARN_ON_ONCE(!skb))
+				iwl_txq_free_tso_page(trans, skb);
 		}
 		iwl_txq_gen2_free_tfd(trans, txq);
 		txq->read_ptr = iwl_txq_inc_wrap(trans, txq->read_ptr);
-- 
2.27.0



