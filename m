Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D2F2E628E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405992AbgL1Nsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:48:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405984AbgL1Nsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:48:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24D032072C;
        Mon, 28 Dec 2020 13:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163314;
        bh=IsUwDPqynoOASa/y75Diw+kc2CaFnyzBxeGtKKxJ+FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CY5Y9WlEeqJVtiBn5rHa1M0QtqEIu1hX1dH4B9nMjnEy7lhobhTxY7u9DCERZOari
         Pb8am1bf56LwMvlT1QHdJ203hAiTv0lnu1vLPV/n5QW8NAsVNyofU09QzgzIz7mhEh
         2U46G9Afh7iOwF8WL4134E5tEivWC1KYm7s+WAMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 236/453] Bluetooth: btmtksdio: Add the missed release_firmware() in mtk_setup_firmware()
Date:   Mon, 28 Dec 2020 13:47:52 +0100
Message-Id: <20201228124948.575744463@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index b7de7cb8cca90..304178be1ef40 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -703,7 +703,7 @@ static int mtk_setup_firmware(struct hci_dev *hdev, const char *fwname)
 	err = mtk_hci_wmt_sync(hdev, &wmt_params);
 	if (err < 0) {
 		bt_dev_err(hdev, "Failed to power on data RAM (%d)", err);
-		return err;
+		goto free_fw;
 	}
 
 	fw_ptr = fw->data;
-- 
2.27.0



