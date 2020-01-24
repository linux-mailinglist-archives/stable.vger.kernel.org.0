Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 164CC148296
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391777AbgAXL3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:29:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391681AbgAXL3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:29:18 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FD872075D;
        Fri, 24 Jan 2020 11:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865358;
        bh=lmUc0VtjCgXhUX9tYSOjITsm7gVF5YfOIr6LCpdPBGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/Y/apHxkMik3pOD26IkokGzCipIZJ8qO1VOybzoNXhWwISQNU187MUw/Q8darXlK
         B7PTI2eZRrJSE8qf3B/nAZHDbpi2BBdnEI+0LzapLisErpmx5GTK/YGdKzlql0ZelU
         M+aovN+3aUk84gPfzht8XEJ3jUSgyE7xmW+pyCJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 511/639] bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails
Date:   Fri, 24 Jan 2020 10:31:21 +0100
Message-Id: <20200124093152.821324986@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
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
index dc63d269f01dc..cdbb8940a4ae5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1778,21 +1778,19 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
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



