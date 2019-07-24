Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5F57463E
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfGYFuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387572AbfGYFnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:43:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F8CD21850;
        Thu, 25 Jul 2019 05:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033410;
        bh=oMhK2svDNQZluWMPovVKARVEW6yfUn3Wpof1lc/Qgvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFCo/Y2EdDoZoVX9mE1c+WtK8gG2FQfSRmh4jc56+7XaCQFyREYr7VWZh22R+lz2Z
         RgBn96T/yAEnpJFkdaKah5/q1XLiwlHJVk1nCi+t0JosutIOxwHYo3P9RaQnlxD1jo
         vvaTmtaX0R8XbuznR6ICpDLv23GQIKYYo7HVzYyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 4.19 197/271] iwlwifi: dont WARN when calling iwl_get_shared_mem_conf with RF-Kill
Date:   Wed, 24 Jul 2019 21:21:06 +0200
Message-Id: <20190724191711.990595571@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 0d53cfd0cca3c729a089c39eef0e7d8ae7662974 upstream.

iwl_mvm_send_cmd returns 0 when the command won't be sent
because RF-Kill is asserted. Do the same when we call
iwl_get_shared_mem_conf since it is not sent through
iwl_mvm_send_cmd but directly calls the transport layer.

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/fw/smem.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/fw/smem.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/smem.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -134,6 +134,7 @@ void iwl_get_shared_mem_conf(struct iwl_
 		.len = { 0, },
 	};
 	struct iwl_rx_packet *pkt;
+	int ret;
 
 	if (fw_has_capa(&fwrt->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG))
@@ -141,8 +142,13 @@ void iwl_get_shared_mem_conf(struct iwl_
 	else
 		cmd.id = SHARED_MEM_CFG;
 
-	if (WARN_ON(iwl_trans_send_cmd(fwrt->trans, &cmd)))
+	ret = iwl_trans_send_cmd(fwrt->trans, &cmd);
+
+	if (ret) {
+		WARN(ret != -ERFKILL,
+		     "Could not send the SMEM command: %d\n", ret);
 		return;
+	}
 
 	pkt = cmd.resp_pkt;
 	if (fwrt->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22000)


