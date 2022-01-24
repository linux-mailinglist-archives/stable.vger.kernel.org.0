Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EA449A46C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1847008AbiAYAHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2364101AbiAXXqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56571C07E300;
        Mon, 24 Jan 2022 13:42:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CFDAB8123D;
        Mon, 24 Jan 2022 21:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FD4C340E4;
        Mon, 24 Jan 2022 21:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060553;
        bh=2PTn4U8QrvFxiZVeAWyU4GTHX3jAXc7OZFieR3may00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnbD6aNZom/jj+y0Gys3aKKHwLlmhEsKS9JGgz8ST0uAfVFGrWaJ2Y50u890SR+jf
         YNyG0ofIapwp7Si90igGRGhewO16mMEm/FbSWmBkv2nKtvcH9qp+yo/3ypUDBfydz7
         EhBaMVMafzA7mk38DiETsk2AcCt+MOkCywl9PXhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.16 0987/1039] iwlwifi: fix Bz NMI behaviour
Date:   Mon, 24 Jan 2022 19:46:16 +0100
Message-Id: <20220124184158.456652014@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit fdfde0cb79264f88992e72b5a056a3a3284fcaad upstream.

Contrary to what was stated before, the hardware hasn't changed
the bits here yet. In any case, the new CSR is also directly
(lower 16 bits) connected to UREG_DOORBELL_TO_ISR6, so if it
still changes the changes would be there. Adjust the code and
comments accordingly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 6c0795f1a524 ("iwlwifi: implement Bz NMI behaviour")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211210090244.75b6207536e3.I7d170a48a9096e6b7269c3a9f447c326f929b171@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h |    5 +++--
 drivers/net/wireless/intel/iwlwifi/iwl-io.c  |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -105,9 +105,10 @@
 /* GIO Chicken Bits (PCI Express bus link power management) */
 #define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
 
-/* Doorbell NMI (since Bz) */
+/* Doorbell - since Bz
+ * connected to UREG_DOORBELL_TO_ISR6 (lower 16 bits only)
+ */
 #define CSR_DOORBELL_VECTOR	(CSR_BASE + 0x130)
-#define CSR_DOORBELL_VECTOR_NMI	BIT(1)
 
 /* host chicken bits */
 #define CSR_HOST_CHICKEN	(CSR_BASE + 0x204)
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -218,7 +218,7 @@ void iwl_force_nmi(struct iwl_trans *tra
 				    UREG_DOORBELL_TO_ISR6_NMI_BIT);
 	else
 		iwl_write32(trans, CSR_DOORBELL_VECTOR,
-			    CSR_DOORBELL_VECTOR_NMI);
+			    UREG_DOORBELL_TO_ISR6_NMI_BIT);
 }
 IWL_EXPORT_SYMBOL(iwl_force_nmi);
 


