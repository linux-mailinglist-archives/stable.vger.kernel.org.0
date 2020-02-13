Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89DE15C38A
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgBMPmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729604AbgBMP2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:17 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C22E120661;
        Thu, 13 Feb 2020 15:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607696;
        bh=egsv0F3QI165Kw4Zy5KRqStiuf+/g6ZG+gWYqu5O9EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRjs4jL69pyuq2VgIEa1gzJ2+1JoWluYdSFROUDu9KPP3I0PQ79g5h2xhxnBYp0y6
         5ouPRXXE+KWd9djGvfKILj9Eg80hZ8MJeO45Jp4ueaLCixNvfSEzWQwm1m2vWjgq7X
         jRng+DCSwGPn9dYn1rA4ek59dafZBIM3SsGcNdb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.5 021/120] iwlwifi: mvm: avoid use after free for pmsr request
Date:   Thu, 13 Feb 2020 07:20:17 -0800
Message-Id: <20200213151909.416453795@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

commit cc4255eff523f25187bb95561642941de0e57497 upstream.

When a FTM request is aborted, the driver sends the abort command to
the fw and waits for a response. When the response arrives, the driver
calls cfg80211_pmsr_complete() for that request.
However, cfg80211 frees the requested data immediately after sending
the abort command, so this may lead to use after free.

Fix it by clearing the request data in the driver when the abort
command arrives and ignoring the fw notification that will come
afterwards.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Fixes: fc36ffda3267 ("iwlwifi: mvm: support FTM initiator")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * Copyright (C) 2018 Intel Corporation
  * Copyright (C) 2019 Intel Corporation
+ * Copyright (C) 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * Copyright (C) 2018 Intel Corporation
  * Copyright (C) 2019 Intel Corporation
+ * Copyright (C) 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -389,6 +391,8 @@ void iwl_mvm_ftm_abort(struct iwl_mvm *m
 	if (req != mvm->ftm_initiator.req)
 		return;
 
+	iwl_mvm_ftm_reset(mvm);
+
 	if (iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_RANGE_ABORT_CMD,
 						 LOCATION_GROUP, 0),
 				 0, sizeof(cmd), &cmd))
@@ -502,7 +506,6 @@ void iwl_mvm_ftm_range_resp(struct iwl_m
 	lockdep_assert_held(&mvm->mutex);
 
 	if (!mvm->ftm_initiator.req) {
-		IWL_ERR(mvm, "Got FTM response but have no request?\n");
 		return;
 	}
 


