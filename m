Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C09F45B9E8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhKXMGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:06:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:32806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242170AbhKXMFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:05:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50CF961056;
        Wed, 24 Nov 2021 12:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755348;
        bh=cpBt1ifw0n2R4OGfiPYHzMmy037FOwLpMDeUoVANk0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jR25DBY37aEJZvLfaZ7YX9LieQEfvo2Zl4hMdg97o8caP3PEn8MPYluOHfFDpG/DR
         boKKVd59wdqxp007aM5Aujuz+5b4I996nZqnSn4/VGe38SNPUwh+6D45QLAGW2kHhs
         G+dMNIMYuPOOU9jCvWQtvIGMnbVRgAfbPZGIEIlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 063/162] mwl8k: Fix use-after-free in mwl8k_fw_state_machine()
Date:   Wed, 24 Nov 2021 12:56:06 +0100
Message-Id: <20211124115700.366963787@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 257051a235c17e33782b6e24a4b17f2d7915aaec ]

When the driver fails to request the firmware, it calls its error
handler. In the error handler, the driver detaches device from driver
first before releasing the firmware, which can cause a use-after-free bug.

Fix this by releasing firmware first.

The following log reveals it:

[    9.007301 ] BUG: KASAN: use-after-free in mwl8k_fw_state_machine+0x320/0xba0
[    9.010143 ] Workqueue: events request_firmware_work_func
[    9.010830 ] Call Trace:
[    9.010830 ]  dump_stack_lvl+0xa8/0xd1
[    9.010830 ]  print_address_description+0x87/0x3b0
[    9.010830 ]  kasan_report+0x172/0x1c0
[    9.010830 ]  ? mutex_unlock+0xd/0x10
[    9.010830 ]  ? mwl8k_fw_state_machine+0x320/0xba0
[    9.010830 ]  ? mwl8k_fw_state_machine+0x320/0xba0
[    9.010830 ]  __asan_report_load8_noabort+0x14/0x20
[    9.010830 ]  mwl8k_fw_state_machine+0x320/0xba0
[    9.010830 ]  ? mwl8k_load_firmware+0x5f0/0x5f0
[    9.010830 ]  request_firmware_work_func+0x172/0x250
[    9.010830 ]  ? read_lock_is_recursive+0x20/0x20
[    9.010830 ]  ? process_one_work+0x7a1/0x1100
[    9.010830 ]  ? request_firmware_nowait+0x460/0x460
[    9.010830 ]  ? __this_cpu_preempt_check+0x13/0x20
[    9.010830 ]  process_one_work+0x9bb/0x1100

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1634356979-6211-1-git-send-email-zheyuma97@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mwl8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index d448480b84063..073968eccbc2b 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5783,8 +5783,8 @@ static void mwl8k_fw_state_machine(const struct firmware *fw, void *context)
 fail:
 	priv->fw_state = FW_STATE_ERROR;
 	complete(&priv->firmware_loading_complete);
-	device_release_driver(&priv->pdev->dev);
 	mwl8k_release_firmware(priv);
+	device_release_driver(&priv->pdev->dev);
 }
 
 #define MAX_RESTART_ATTEMPTS 1
-- 
2.33.0



