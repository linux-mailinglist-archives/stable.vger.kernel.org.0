Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6E83C49F6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbhGLGrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234846AbhGLGqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:46:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0409661158;
        Mon, 12 Jul 2021 06:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072163;
        bh=z7U3MY4f6Y0b6ZUutogu3Nyqjy1yxBByU/HVNEf9hLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7BOfha3kyhrVI7BICMXeaknAVjNNa+lwYwaGLps3WN9akVdXehzgeUKPcDHiE0bR
         iy5VrrhwLATI5kX5z9o9+Ivvo03LCBWFo5kfEOgLS4Ml9pZnCSgKK0iHZ4KQiyVdO/
         4yGxI4oMAL8oB/IY6SUA4Q0W+BYatuiPGBHythrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 379/593] iwlwifi: increase PNVM load timeout
Date:   Mon, 12 Jul 2021 08:08:59 +0200
Message-Id: <20210712060928.599982596@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 5cc816ef9db1fe03f73e56e9d8f118add9c6efe4 ]

The FW has a watchdog of 200ms in the PNVM load flow, so the driver
should have a slightly higher timeout.  Change the timeout from 100ms
to 250ms.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: 70d3ca86b025 ("iwlwifi: mvm: ring the doorbell and wait for PNVM load completion")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210612142637.ba22aec1e2be.I36bfadc28c480f4fc57266c075a79e8ea4a6934f@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
index e4f91bce222d..61d3d4e0b7d9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /******************************************************************************
  *
- * Copyright(c) 2020 Intel Corporation
+ * Copyright(c) 2020-2021 Intel Corporation
  *
  *****************************************************************************/
 
@@ -10,7 +10,7 @@
 
 #include "fw/notif-wait.h"
 
-#define MVM_UCODE_PNVM_TIMEOUT	(HZ / 10)
+#define MVM_UCODE_PNVM_TIMEOUT	(HZ / 4)
 
 int iwl_pnvm_load(struct iwl_trans *trans,
 		  struct iwl_notif_wait_data *notif_wait);
-- 
2.30.2



