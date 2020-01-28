Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2919814B66E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgA1OFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:05:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgA1OFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:05:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8542205F4;
        Tue, 28 Jan 2020 14:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220302;
        bh=cEY9Csq2IFQ1dLpeGxnxbWt/b8IdDawC5oUSWrgUMaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPRierrFvbrIbW1jN0hUZAtdtIOnHargfliL7qObkiHgiQDTAKyETSx5rJrJRELEt
         D1hkeF/prSk/7n7U9JJ2G0BLis57dg7tAxUn7ld4tT9BeLtc8fnMGSS9bKMtx+S1Mp
         CK+IEL7PeyAaI/u0E/uKLW9Q7fVbNIXBkJrRYjY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.4 080/104] iwlwifi: mvm: fix SKB leak on invalid queue
Date:   Tue, 28 Jan 2020 15:00:41 +0100
Message-Id: <20200128135828.240592538@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit b9f726c94224e863d4d3458dfec2e7e1284a39ce upstream.

It used to be the case that if we got here, we wouldn't warn
but instead allocate the queue (DQA). With using the mac80211
TXQs model this changed, and we really have nothing to do with
the frame here anymore, hence the warning now.

However, clearly we missed in coding & review that this is now
a pure error path and leaks the SKB if we return 0 instead of
an indication that the SKB needs to be freed. Fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: cfbc6c4c5b91 ("iwlwifi: mvm: support mac80211 TXQs model")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1151,7 +1151,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mv
 	if (WARN_ONCE(txq_id == IWL_MVM_INVALID_QUEUE, "Invalid TXQ id")) {
 		iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
 		spin_unlock(&mvmsta->lock);
-		return 0;
+		return -1;
 	}
 
 	if (!iwl_mvm_has_new_tx_api(mvm)) {


