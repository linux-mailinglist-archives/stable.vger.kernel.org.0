Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4F0328C00
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240566AbhCASnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240359AbhCASit (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:38:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D4C1652D7;
        Mon,  1 Mar 2021 17:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620315;
        bh=LUdE3yDlXGBAS/McQ6G5goaqrB3PWmfyJ6OI6V0lgtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qftPv/uapLFMgd28Y5TO6hhccFMNQ55Hn6xKBxrRw8+tC3hgM7x7uct4pG162BKx9
         wIDzWBggMF8CLLgMFX8hxMxLBVNE/Nrbka1fG3f3MPKqcu/wAfBYg3P3XhrzCWtepn
         ybidc9Xaayvw5qTumwPIr7B2waERtQ8IySf2vpuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 101/775] bnxt_en: Fix devlink infos stored fw.psid version format.
Date:   Mon,  1 Mar 2021 17:04:29 +0100
Message-Id: <20210301161206.648409644@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit db28b6c77f4050f62599267a886b61fbd6504633 ]

The running fw.psid version is in decimal format but the stored
fw.psid is in hex format.  This can mislead the user to reset the
NIC to activate the stored version to become the running version.

Fix it to display the stored fw.psid in decimal format.

Fixes: 1388875b3916 ("bnxt_en: Add stored FW version info to devlink info_get cb.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 6b7b69ed62db0..a9bcf887d2fbe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -472,8 +472,8 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (BNXT_PF(bp) && !bnxt_hwrm_get_nvm_cfg_ver(bp, &nvm_cfg_ver)) {
 		u32 ver = nvm_cfg_ver.vu32;
 
-		sprintf(buf, "%X.%X.%X", (ver >> 16) & 0xF, (ver >> 8) & 0xF,
-			ver & 0xF);
+		sprintf(buf, "%d.%d.%d", (ver >> 16) & 0xf, (ver >> 8) & 0xf,
+			ver & 0xf);
 		rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
 				      DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
 				      buf);
-- 
2.27.0



