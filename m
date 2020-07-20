Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A448226B5D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgGTPoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730371AbgGTPoN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:44:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 651B322CE3;
        Mon, 20 Jul 2020 15:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259853;
        bh=djqM4YUbI96j7kSVZZOD7dgY/OOmgHA2ULUgKYKOgA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdKgk58oEL4BrfGz5zAEL+UJlKChECFnhOxAS6IdgQVvlbbFrF/iVyMiJVGFpj7Wp
         XquUjoXaP5EuN191C3IjKo/v2T30dRN7S+JbSlT5VcbWGE0xcAppn5i2axo2xUxzVp
         7rYzFyTjn4rQ13sxgeKMQUHr5Z67OqFSqsAsum78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Li Heng <liheng40@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 017/125] net: cxgb4: fix return error value in t4_prep_fw
Date:   Mon, 20 Jul 2020 17:35:56 +0200
Message-Id: <20200720152803.813629255@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Heng <liheng40@huawei.com>

[ Upstream commit 8a259e6b73ad8181b0b2ef338b35043433db1075 ]

t4_prep_fw goto bye tag with positive return value when something
bad happened and which can not free resource in adap_init0.
so fix it to return negative value.

Fixes: 16e47624e76b ("cxgb4: Add new scheme to update T4/T5 firmware")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Li Heng <liheng40@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 0f126ce4645f3..ecb8ef4a756fc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3361,7 +3361,7 @@ int t4_prep_fw(struct adapter *adap, struct fw_info *fw_info,
 	drv_fw = &fw_info->fw_hdr;
 
 	/* Read the header of the firmware on the card */
-	ret = -t4_read_flash(adap, FLASH_FW_START,
+	ret = t4_read_flash(adap, FLASH_FW_START,
 			    sizeof(*card_fw) / sizeof(uint32_t),
 			    (uint32_t *)card_fw, 1);
 	if (ret == 0) {
@@ -3390,8 +3390,8 @@ int t4_prep_fw(struct adapter *adap, struct fw_info *fw_info,
 		   should_install_fs_fw(adap, card_fw_usable,
 					be32_to_cpu(fs_fw->fw_ver),
 					be32_to_cpu(card_fw->fw_ver))) {
-		ret = -t4_fw_upgrade(adap, adap->mbox, fw_data,
-				     fw_size, 0);
+		ret = t4_fw_upgrade(adap, adap->mbox, fw_data,
+				    fw_size, 0);
 		if (ret != 0) {
 			dev_err(adap->pdev_dev,
 				"failed to install firmware: %d\n", ret);
@@ -3422,7 +3422,7 @@ int t4_prep_fw(struct adapter *adap, struct fw_info *fw_info,
 			FW_HDR_FW_VER_MICRO_G(c), FW_HDR_FW_VER_BUILD_G(c),
 			FW_HDR_FW_VER_MAJOR_G(k), FW_HDR_FW_VER_MINOR_G(k),
 			FW_HDR_FW_VER_MICRO_G(k), FW_HDR_FW_VER_BUILD_G(k));
-		ret = EINVAL;
+		ret = -EINVAL;
 		goto bye;
 	}
 
-- 
2.25.1



