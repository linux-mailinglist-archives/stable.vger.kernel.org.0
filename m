Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC031016A3
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731948AbfKSFzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:55:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:53552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731923AbfKSFzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:55:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7B9C218BA;
        Tue, 19 Nov 2019 05:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142911;
        bh=M7N5LztpDw2kyJ5yB4iPmtwbve+0kgH1XBI6bCkxHh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vv9j9oP9xLlsK5HijNx/XN2BZ9fEb9mNQsLykvsHRF+4thJbVzWk4b5zZv6Lfl4ii
         qyoRUxDU0k62OZpXC05f9twhg8rWJwSha5cl/W7UnplyhgN1ZasTJF6GL07IiNMRkv
         nVO/Ej1UlfR1AUGHMBkbhaJuvC9FKYtBtGQkXB8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 217/239] iwlwifi: dbg: dont crash if the firmware crashes in the middle of a debug dump
Date:   Tue, 19 Nov 2019 06:20:17 +0100
Message-Id: <20191119051339.238673966@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 79f25b10c9da3dbc953e47033d0494e51580ac3b ]

We can dump data from the firmware either when it crashes,
or when the firmware is alive.
Not all the data is available if the firmware is running
(like the Tx / Rx FIFOs which are available only when the
firmware is halted), so we first check that the firmware
is alive to compute the required size for the dump and then
fill the buffer with the data.

When we allocate the buffer, we test the STATUS_FW_ERROR
bit to check if the firmware is alive or not. This bit
can be changed during the course of the dump since it is
modified in the interrupt handler.

We hit a case where we allocate the buffer while the
firmware is sill working, and while we start to fill the
buffer, the firmware crashes. Then we test STATUS_FW_ERROR
again and decide to fill the buffer with data like the
FIFOs even if no room was allocated for this data in the
buffer. This means that we overflow the buffer that was
allocated leading to memory corruption.

To fix this, test the STATUS_FW_ERROR bit only once and
rely on local variables to check if we should dump fifos
or other firmware components.

Fixes: 04fd2c28226f ("iwlwifi: mvm: add rxf and txf to dump data")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index e72c0b825420c..4650b9e5da2bc 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -775,7 +775,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	dump_data = iwl_fw_error_next_data(dump_data);
 
 	/* We only dump the FIFOs if the FW is in error state */
-	if (test_bit(STATUS_FW_ERROR, &fwrt->trans->status)) {
+	if (fifo_data_len) {
 		iwl_fw_dump_fifos(fwrt, &dump_data);
 		if (radio_len)
 			iwl_read_radio_regs(fwrt, &dump_data);
-- 
2.20.1



