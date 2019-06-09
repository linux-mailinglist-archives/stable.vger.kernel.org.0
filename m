Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 667E23AAD5
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbfFIQoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729206AbfFIQoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:44:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2979320833;
        Sun,  9 Jun 2019 16:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098659;
        bh=vM+XpS86ehyLhuMx/xsTgBStL6Ffh2kI8sFMlWGzlhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEL9YnRD5OTQzxaVcGH7GoF7ezmIGbYiulF+nPjKpgGwPekykfAVgxSgsLp2WeG+m
         L4z41DEeJ4H5iVi8Aowts57hfAj9s7wRnV2R+K7L3uxAvlPDxcrmpRXPI/+PpCSe+s
         tjwXDHOdLOAy9ZY4lCGOeAMFcSW4Ff7awhOIWKB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikita Danilov <nikita.danilov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 15/70] net: aquantia: fix wol configuration not applied sometimes
Date:   Sun,  9 Jun 2019 18:41:26 +0200
Message-Id: <20190609164128.353423890@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Danilov <nikita.danilov@aquantia.com>

[ Upstream commit 930b9a0543385d4eb8ef887e88cf84d95a844577 ]

WoL magic packet configuration sometimes does not work due to
couple of leakages found.

Mainly there was a regression introduced during readx_poll refactoring.

Next, fw request waiting time was too small. Sometimes that
caused sleep proxy config function to return with an error
and to skip WoL configuration.
At last, WoL data were passed to FW from not clean buffer.
That could cause FW to accept garbage as a random configuration data.

Fixes: 6a7f2277313b ("net: aquantia: replace AQ_HW_WAIT_FOR with readx_poll_timeout_atomic")
Signed-off-by: Nikita Danilov <nikita.danilov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c      |   14 +++++-----
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c |    4 ++
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -335,13 +335,13 @@ static int hw_atl_utils_fw_upload_dwords
 {
 	u32 val;
 	int err = 0;
-	bool is_locked;
 
-	is_locked = hw_atl_sem_ram_get(self);
-	if (!is_locked) {
-		err = -ETIME;
+	err = readx_poll_timeout_atomic(hw_atl_sem_ram_get, self,
+					val, val == 1U,
+					10U, 100000U);
+	if (err < 0)
 		goto err_exit;
-	}
+
 	if (IS_CHIP_FEATURE(REVISION_B1)) {
 		u32 offset = 0;
 
@@ -353,8 +353,8 @@ static int hw_atl_utils_fw_upload_dwords
 			/* 1000 times by 10us = 10ms */
 			err = readx_poll_timeout_atomic(hw_atl_scrpad12_get,
 							self, val,
-							(val & 0xF0000000) ==
-							 0x80000000,
+							(val & 0xF0000000) !=
+							0x80000000,
 							10U, 10000U);
 		}
 	} else {
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -349,7 +349,7 @@ static int aq_fw2x_set_sleep_proxy(struc
 	err = readx_poll_timeout_atomic(aq_fw2x_state2_get,
 					self, val,
 					val & HW_ATL_FW2X_CTRL_SLEEP_PROXY,
-					1U, 10000U);
+					1U, 100000U);
 
 err_exit:
 	return err;
@@ -369,6 +369,8 @@ static int aq_fw2x_set_wol_params(struct
 
 	msg = (struct fw2x_msg_wol *)rpc;
 
+	memset(msg, 0, sizeof(*msg));
+
 	msg->msg_id = HAL_ATLANTIC_UTILS_FW2X_MSG_WOL;
 	msg->magic_packet_enabled = true;
 	memcpy(msg->hw_addr, mac, ETH_ALEN);


