Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 594EB99A23
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731771AbfHVRKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390734AbfHVRJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:20 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7225233FE;
        Thu, 22 Aug 2019 17:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493760;
        bh=Lja0FVf56EXqjcfkco10xOKcvCdEdpDIeNUFDwiV7NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmE4a/nb1YFMPh9Wuk28FOauYIVSadU4TA0wNNbzIu9lTpX28TlrdAfTL/Mwm9O6E
         vC85Mc+1ftILf3/X5JZZSqCZObnTTGXqvp0rWP2IYt/DHDhJl3uBClVW3otTLL2rvB
         R5Ho4XpIBaVqk/ODywcHrB8bxt7k2Y3i7jYgw/Sk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 122/135] bnxt_en: Suppress HWRM errors for HWRM_NVM_GET_VARIABLE command
Date:   Thu, 22 Aug 2019 13:07:58 -0400
Message-Id: <20190822170811.13303-123-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit b703ba751dbb4bcd086509ed4b28102bc1670b35 ]

For newly added NVM parameters, older firmware may not have the support.
Suppress the error message to avoid the unncessary error message which is
triggered when devlink calls the driver during initialization.

Fixes: 782a624d00fa ("bnxt_en: Add bnxt_en initial params table and register it.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 549c90d3e465f..c05d663212b20 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -98,10 +98,13 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 	if (idx)
 		req->dimensions = cpu_to_le16(1);
 
-	if (req->req_type == cpu_to_le16(HWRM_NVM_SET_VARIABLE))
+	if (req->req_type == cpu_to_le16(HWRM_NVM_SET_VARIABLE)) {
 		memcpy(data_addr, buf, bytesize);
-
-	rc = hwrm_send_message(bp, msg, msg_len, HWRM_CMD_TIMEOUT);
+		rc = hwrm_send_message(bp, msg, msg_len, HWRM_CMD_TIMEOUT);
+	} else {
+		rc = hwrm_send_message_silent(bp, msg, msg_len,
+					      HWRM_CMD_TIMEOUT);
+	}
 	if (!rc && req->req_type == cpu_to_le16(HWRM_NVM_GET_VARIABLE))
 		memcpy(buf, data_addr, bytesize);
 
-- 
2.20.1

