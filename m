Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA7D16759B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388473AbgBUI37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:29:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387534AbgBUIQf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:16:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1325A24689;
        Fri, 21 Feb 2020 08:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272994;
        bh=Q7eAQjp9GAiJ/dGofjdEh5xK+sfrtDdEUMzVTFqX9cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXiUwd8PTwjkon9o5tebYjzMG7AmHIrTUkA8m0ISv4lC1EWM9yzWonNKM50GlaX3E
         hHj5aAoWCf04nzg+GDYCUl2p8piHJ3IXTFQ2zUP/9m5DOoA5fYWQG0DkX7or93cK7g
         j965VvR+hSJaEtFZoqNmAByu6D4u+Eu/LwChaOUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 329/344] iwlwifi: mvm: Check the sta is not NULL in iwl_mvm_cfg_he_sta()
Date:   Fri, 21 Feb 2020 08:42:08 +0100
Message-Id: <20200221072420.156263943@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

[ Upstream commit 12d47f0ea5e0aa63f19ba618da55a7c67850ca10 ]

Fix a kernel panic by checking that the sta is not NULL.
This could happen during a reconfig flow, as mac80211 moves the sta
between all the states without really checking if the previous state was
successfully set. So, if for some reason we failed to add back the
station, subsequent calls to sta_state() callback will be done when the
station is NULL. This would result in a following panic:

BUG: unable to handle kernel NULL pointer dereference at
0000000000000040
IP: iwl_mvm_cfg_he_sta+0xfc/0x690 [iwlmvm]
[..]
Call Trace:
 iwl_mvm_mac_sta_state+0x629/0x6f0 [iwlmvm]
 drv_sta_state+0xf4/0x950 [mac80211]
 ieee80211_reconfig+0xa12/0x2180 [mac80211]
 ieee80211_restart_work+0xbb/0xe0 [mac80211]
 process_one_work+0x1e2/0x610
 worker_thread+0x4d/0x3e0
[..]

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 18ccc2692437f..6ca087ffd163b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -5,10 +5,9 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2012 - 2014, 2018 - 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -28,10 +27,9 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2012 - 2014, 2018 - 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -2025,7 +2023,7 @@ static void iwl_mvm_cfg_he_sta(struct iwl_mvm *mvm,
 	rcu_read_lock();
 
 	sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_ctxt_cmd.sta_id]);
-	if (IS_ERR(sta)) {
+	if (IS_ERR_OR_NULL(sta)) {
 		rcu_read_unlock();
 		WARN(1, "Can't find STA to configure HE\n");
 		return;
-- 
2.20.1



