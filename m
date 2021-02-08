Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF25C313807
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhBHPfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:35:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232439AbhBHPSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DA2E64EBD;
        Mon,  8 Feb 2021 15:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797138;
        bh=Rs2PfzWRnHFXSQd3qh3MTr43Mp/QqRruHckN2F0wIgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pk8dnY16pCKrnYz8pYwrF06eQSBSaZmsXhd+NTZrDsjvz6BYIxvlLdNzOI8GIX73m
         2p9xuxwU4zV5oRPXUFHwd/VwOCJYSFoDF+iq4fvzh2ZDYqGWySgs1qD6iHDoBopZFz
         6qp4j7psoF1KXSvzr3OcyCvAMeR/LpvtNSbk+Dos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 56/65] iwlwifi: mvm: dont send RFH_QUEUE_CONFIG_CMD with no queues
Date:   Mon,  8 Feb 2021 16:01:28 +0100
Message-Id: <20210208145812.389394956@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

commit 64f55156f7adedb1ac5bb9cdbcbc9ac05ff5a724 upstream.

If we have only a single RX queue, such as when MSI-X is not
available, we should not send the RFH_QUEUEU_CONFIG_CMD, because our
only queue is the same as the command queue and will be configured as
part of the context info.  Our code was actually trying to send the
command with 0 queues, which caused UMAC assert 0x1D04.

Fix that by not sending the command when we have a single queue.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20201008180656.c35eeb3299f8.I08f79a6ebe150a7d180b7005b24504bfdba6d8b5@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -134,7 +134,14 @@ static int iwl_configure_rxq(struct iwl_
 		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
 	};
 
-	/* Do not configure default queue, it is configured via context info */
+	/*
+	 * The default queue is configured via context info, so if we
+	 * have a single queue, there's nothing to do here.
+	 */
+	if (mvm->trans->num_rx_queues == 1)
+		return 0;
+
+	/* skip the default queue */
 	num_queues = mvm->trans->num_rx_queues - 1;
 
 	size = struct_size(cmd, data, num_queues);


