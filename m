Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579E3147DBE
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388944AbgAXKCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:02:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733082AbgAXKCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:02:49 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03706214DB;
        Fri, 24 Jan 2020 10:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860168;
        bh=YmBL2CPWV4hwaByqEwZAwjeOagvG0g9aVx+hvBBv79o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAcaMFYJ/jM9tpMZSUIp6obrmZTVcBclSlY1aLuDIjVGhWsNUGaINfxYB95qTy+7K
         3mHsAyctvsM+d3IbYs86yJ2csdPJPonCL/Ki35HJByg4g6tMtXTQY/tDfUZAypAQyw
         5uz4ArkURIbgS+/eCHF/5bOOSbmPoqhYUwoHC8fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 274/343] bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails
Date:   Fri, 24 Jan 2020 10:31:32 +0100
Message-Id: <20200124092955.957791665@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit dd2ebf3404c7c295014bc025dea23960960ceb1a ]

If FW returns FRAG_ERR in response error code, driver is resending the
command only when HWRM command returns success. Fix the code to resend
NVM_INSTALL_UPDATE command with DEFRAG install flags, if FW returns
FRAG_ERR in its response error code.

Fixes: cb4d1d626145 ("bnxt_en: Retry failed NVM_INSTALL_UPDATE with defragmentation flag enabled.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 963beaa8fabbc..3c78cd1cdd6fb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1667,21 +1667,19 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 	mutex_lock(&bp->hwrm_cmd_lock);
 	hwrm_err = _hwrm_send_message(bp, &install, sizeof(install),
 				      INSTALL_PACKAGE_TIMEOUT);
-	if (hwrm_err)
-		goto flash_pkg_exit;
-
-	if (resp->error_code) {
+	if (hwrm_err) {
 		u8 error_code = ((struct hwrm_err_output *)resp)->cmd_err;
 
-		if (error_code == NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
+		if (resp->error_code && error_code ==
+		    NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
 			install.flags |= cpu_to_le16(
 			       NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG);
 			hwrm_err = _hwrm_send_message(bp, &install,
 						      sizeof(install),
 						      INSTALL_PACKAGE_TIMEOUT);
-			if (hwrm_err)
-				goto flash_pkg_exit;
 		}
+		if (hwrm_err)
+			goto flash_pkg_exit;
 	}
 
 	if (resp->result) {
-- 
2.20.1



