Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B20328C36
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240438AbhCASrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:47:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236845AbhCASjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A140265004;
        Mon,  1 Mar 2021 17:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618555;
        bh=EbGvPKEonl1pIs0mpQhSYMEsajxJXlBdjh798VJ8bfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGddnxkb6jGEy0g2LJ1C2GD4POtmMBi/TwLMjQXtehEHNRRsaCr/6TslBbcMwjzku
         FkgMlmpvTKxcDPyO7tB9UVnifSpI300HN4EP5JzIz4Kf4YxxOFKPOfcvIxnqndXJZr
         lr9FA74RfX5PTsHupNn+HnDLbDaFfb8BpIq2Z5+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/663] bnxt_en: Fix devlink infos stored fw.psid version format.
Date:   Mon,  1 Mar 2021 17:05:47 +0100
Message-Id: <20210301161146.626646736@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 184b6d0513b2a..8b0e916afe6b1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -474,8 +474,8 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
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



