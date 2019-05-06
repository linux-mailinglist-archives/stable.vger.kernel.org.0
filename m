Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A5714F57
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfEFOeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbfEFOeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DC34204EC;
        Mon,  6 May 2019 14:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153254;
        bh=sk1zI6W2S4kVafifJaY+W3PSy5uyXPMd4QgwYZREVB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvDJOxsSOfX06SUrKTd34DUxuHvpA/t9DeFxwVH99lS6e0JewQGoShOhzBl547dXU
         6l8UFk9mpDNIuHyrAGgpTCK3eycxuq889M/+NijlslBxU72GbhqZkEc21U4c6Gl9xt
         yxN9wV4WtFpM+JtqKOBOYuP1qFvNC8x3zNX+Wo7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.0 004/122] iwlwifi: fix driver operation for 5350
Date:   Mon,  6 May 2019 16:31:02 +0200
Message-Id: <20190506143055.106408185@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 5c9adef9789148d382d7d1307c3d6bfaf51d143d upstream.

We introduced a bug that prevented this old device from
working. The driver would simply not be able to complete
the INIT flow while spewing this warning:

 CSR addresses aren't configured
 WARNING: CPU: 0 PID: 819 at drivers/net/wireless/intel/iwlwifi/pcie/drv.c:917
 iwl_pci_probe+0x160/0x1e0 [iwlwifi]

Cc: stable@vger.kernel.org # v4.18+
Fixes: a8cbb46f831d ("iwlwifi: allow different csr flags for different device families")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Fixes: c8f1b51e506d ("iwlwifi: allow different csr flags for different device families")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/cfg/5000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/5000.c
@@ -1,7 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -136,6 +136,7 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.ht_params = &iwl5000_ht_params,
 	.led_mode = IWL_LED_BLINK,
 	.internal_wimax_coex = true,
+	.csr = &iwl_csr_v1,
 };
 
 #define IWL_DEVICE_5150						\


