Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA6F2E3D73
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440726AbgL1OPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:15:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440721AbgL1OPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6B3221D94;
        Mon, 28 Dec 2020 14:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164901;
        bh=LESRNoLnrgKCZu3BkKCQUvmXtiRK7LFBQ1IWXDI4R08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxPQmreNt71Qx6beoTitQXBPiNt+NFuaooKMlynh9o5gpu5L3I1Rw/RMSCRDn3lkj
         IkC7bBJF7yihtx54jTjUolP9jy/fYaWFMFZ+uMvh9o+PhSXJiG97Fhm1D9Y01+/G4d
         eSsG6fYISv2oqRJIBakB6XbNwM92r8i1gNHjHpyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/717] Bluetooth: btusb: Add the missed release_firmware() in btusb_mtk_setup_firmware()
Date:   Mon, 28 Dec 2020 13:45:36 +0100
Message-Id: <20201228125037.217743756@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit d1e9d232e1e60fa63df1b836ec3ecba5abd3fa9d ]

btusb_mtk_setup_firmware() misses to call release_firmware() in an error
path. Jump to err_release_fw to fix it.

Fixes: f645125711c8 ("Bluetooth: btusb: fix up firmware download sequence")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1005b6e8ff743..a9981678199d7 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3067,7 +3067,7 @@ static int btusb_mtk_setup_firmware(struct hci_dev *hdev, const char *fwname)
 	err = btusb_mtk_hci_wmt_sync(hdev, &wmt_params);
 	if (err < 0) {
 		bt_dev_err(hdev, "Failed to power on data RAM (%d)", err);
-		return err;
+		goto err_release_fw;
 	}
 
 	fw_ptr = fw->data;
-- 
2.27.0



