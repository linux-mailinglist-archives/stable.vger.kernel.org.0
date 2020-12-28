Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433352E40D0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436590AbgL1O5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:57:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440624AbgL1OPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11D2B20731;
        Mon, 28 Dec 2020 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164904;
        bh=QUCzMLjXo7RbE+T5uGyeAbkNHSENdxL1Gl/rAZhHAiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAuIwDq+LrWoUuzSfs8DhZpBtnosmAvpFeae3CnsdXyLyUSwqD/jo75HqSmFVoM0J
         dwOdY4pAPhItyDF0q5hAI26pDjI/yV31f+1vPkjDAiaW2DOIB6lt7TsbpZNojG36Ci
         c10K4H9B77PfO46Tml0/ctJXblbmfIR9CtM9uS3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 339/717] Bluetooth: btmtksdio: Add the missed release_firmware() in mtk_setup_firmware()
Date:   Mon, 28 Dec 2020 13:45:37 +0100
Message-Id: <20201228125037.263315306@linuxfoundation.org>
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

[ Upstream commit b73b5781a85c03113476f62346c390f0277baa4b ]

mtk_setup_firmware() misses to call release_firmware() in an error
path. Jump to free_fw to fix it.

Fixes: 737cd06072a7 ("Bluetooth: btmtksdio: fix up firmware download sequence")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index ba45c59bd9f36..5f9f027956317 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -704,7 +704,7 @@ static int mtk_setup_firmware(struct hci_dev *hdev, const char *fwname)
 	err = mtk_hci_wmt_sync(hdev, &wmt_params);
 	if (err < 0) {
 		bt_dev_err(hdev, "Failed to power on data RAM (%d)", err);
-		return err;
+		goto free_fw;
 	}
 
 	fw_ptr = fw->data;
-- 
2.27.0



