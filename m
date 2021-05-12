Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F73C37CA45
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhELQ2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232985AbhELQS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A551B61D8A;
        Wed, 12 May 2021 15:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834340;
        bh=xjrIk0+xR8m4aU2GltyO9DyXQmSvcMIJzUgBmGkC99c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xb8IEO3ar8HKe4G4ZFRsKsMNDzTECJV3+1V8gX0b6MMfZHWQCYUKUDiQcOFUz6k8M
         JBPrtZUfmAzN0kkGu2Ydyu/c9CqTJsQtAvPzm55E0y36zcAUmPdZ9J2mmj1p2vXk6L
         YYbYhFiaL4XzwiT+ThL1fq+K+ORSzo7MF+e1u+V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 505/601] iwlwifi: dbg: disable ini debug in 9000 family and below
Date:   Wed, 12 May 2021 16:49:42 +0200
Message-Id: <20210512144844.469127497@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

[ Upstream commit 7c81a025054cd0aeeeaf17aba2e9757f0a6a38a1 ]

Yoyo based debug is not applicable to old devices.  As init debug is
enabled by default in the driver, it needs to be disabled to work the
old debug mechanism in old devices.

Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Fixes: b0d8d2c27007 ("iwlwifi: yoyo: enable yoyo by default")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210411132130.805401a1b8ec.I30db38184a418cfc1c5ca1a305cc14a52501d415@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index a80a35a7740f..900bf546d86e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 #include <linux/firmware.h>
 #include "iwl-drv.h"
@@ -424,7 +424,8 @@ void iwl_dbg_tlv_load_bin(struct device *dev, struct iwl_trans *trans)
 	const struct firmware *fw;
 	int res;
 
-	if (!iwlwifi_mod_params.enable_ini)
+	if (!iwlwifi_mod_params.enable_ini ||
+	    trans->trans_cfg->device_family <= IWL_DEVICE_FAMILY_9000)
 		return;
 
 	res = firmware_request_nowarn(&fw, "iwl-debug-yoyo.bin", dev);
-- 
2.30.2



