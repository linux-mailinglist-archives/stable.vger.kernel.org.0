Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A19C1131E8
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbfLDSDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:03:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730091AbfLDSDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:03:42 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32FA6206DF;
        Wed,  4 Dec 2019 18:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482621;
        bh=vdwaTwkiAhmYG/mez884oyyzASldPyX2HzsGMIGaA/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGVgBMxxvcT9vOI2jcDIrSFX5xATo7EOyKbPestKDShfm8nU7SIsRQt6cfmZyHTyn
         1nUynvyYV6Y+6AEI+0cdXB444gCBTCvj71jzfG3egSqiU+r+To7a+1jBzT++hOMsN8
         rq449fFth1bYeBxFAvizVQEtLFFMhBXrPGm7AZNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 069/209] bnxt_en: Return linux standard errors in bnxt_ethtool.c
Date:   Wed,  4 Dec 2019 18:54:41 +0100
Message-Id: <20191204175326.035833894@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 7c675421afef18253a86ffc383f57bc15ef32ea8 ]

Currently firmware specific errors are returned directly in flash_device
and reset ethtool hooks. Modify it to return linux standard errors
to userspace when flashing operations fail.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 56 +++++++++++++------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index a22336fef66b2..4879371ad0c75 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1339,14 +1339,22 @@ static int bnxt_flash_nvram(struct net_device *dev,
 	rc = hwrm_send_message(bp, &req, sizeof(req), FLASH_NVRAM_TIMEOUT);
 	dma_free_coherent(&bp->pdev->dev, data_len, kmem, dma_handle);
 
+	if (rc == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
+		netdev_info(dev,
+			    "PF does not have admin privileges to flash the device\n");
+		rc = -EACCES;
+	} else if (rc) {
+		rc = -EIO;
+	}
 	return rc;
 }
 
 static int bnxt_firmware_reset(struct net_device *dev,
 			       u16 dir_type)
 {
-	struct bnxt *bp = netdev_priv(dev);
 	struct hwrm_fw_reset_input req = {0};
+	struct bnxt *bp = netdev_priv(dev);
+	int rc;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FW_RESET, -1, -1);
 
@@ -1380,7 +1388,15 @@ static int bnxt_firmware_reset(struct net_device *dev,
 		return -EINVAL;
 	}
 
-	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
+		netdev_info(dev,
+			    "PF does not have admin privileges to reset the device\n");
+		rc = -EACCES;
+	} else if (rc) {
+		rc = -EIO;
+	}
+	return rc;
 }
 
 static int bnxt_flash_firmware(struct net_device *dev,
@@ -1587,9 +1603,9 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 	struct hwrm_nvm_install_update_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_nvm_install_update_input install = {0};
 	const struct firmware *fw;
+	int rc, hwrm_err = 0;
 	u32 item_len;
 	u16 index;
-	int rc;
 
 	bnxt_hwrm_fw_set_time(bp);
 
@@ -1632,15 +1648,16 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 			memcpy(kmem, fw->data, fw->size);
 			modify.host_src_addr = cpu_to_le64(dma_handle);
 
-			rc = hwrm_send_message(bp, &modify, sizeof(modify),
-					       FLASH_PACKAGE_TIMEOUT);
+			hwrm_err = hwrm_send_message(bp, &modify,
+						     sizeof(modify),
+						     FLASH_PACKAGE_TIMEOUT);
 			dma_free_coherent(&bp->pdev->dev, fw->size, kmem,
 					  dma_handle);
 		}
 	}
 	release_firmware(fw);
-	if (rc)
-		return rc;
+	if (rc || hwrm_err)
+		goto err_exit;
 
 	if ((install_type & 0xffff) == 0)
 		install_type >>= 16;
@@ -1648,12 +1665,10 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 	install.install_type = cpu_to_le32(install_type);
 
 	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, &install, sizeof(install),
-				INSTALL_PACKAGE_TIMEOUT);
-	if (rc) {
-		rc = -EOPNOTSUPP;
+	hwrm_err = _hwrm_send_message(bp, &install, sizeof(install),
+				      INSTALL_PACKAGE_TIMEOUT);
+	if (hwrm_err)
 		goto flash_pkg_exit;
-	}
 
 	if (resp->error_code) {
 		u8 error_code = ((struct hwrm_err_output *)resp)->cmd_err;
@@ -1661,12 +1676,11 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 		if (error_code == NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
 			install.flags |= cpu_to_le16(
 			       NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG);
-			rc = _hwrm_send_message(bp, &install, sizeof(install),
-						INSTALL_PACKAGE_TIMEOUT);
-			if (rc) {
-				rc = -EOPNOTSUPP;
+			hwrm_err = _hwrm_send_message(bp, &install,
+						      sizeof(install),
+						      INSTALL_PACKAGE_TIMEOUT);
+			if (hwrm_err)
 				goto flash_pkg_exit;
-			}
 		}
 	}
 
@@ -1677,6 +1691,14 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 	}
 flash_pkg_exit:
 	mutex_unlock(&bp->hwrm_cmd_lock);
+err_exit:
+	if (hwrm_err == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
+		netdev_info(dev,
+			    "PF does not have admin privileges to flash the device\n");
+		rc = -EACCES;
+	} else if (hwrm_err) {
+		rc = -EOPNOTSUPP;
+	}
 	return rc;
 }
 
-- 
2.20.1



