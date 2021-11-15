Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047814520D1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350439AbhKPA4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343589AbhKOTVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6941E6334C;
        Mon, 15 Nov 2021 18:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001749;
        bh=XlPWwDSBSAjUuVU7E2K8k4ivOtXtQoxJIestpEVm9rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b83rCgFJDKS3NqOwRVx6TGs9bKz87InsTLCIjBc/+pNEpfoh2ZcSrM1QKvOItJ7kV
         PcP7zaddnyKoBJvTqxYDmw+Mm+K1nDSv1X72iaWCz9S7plAQ/OGb/mJPeHafz7xQeE
         Aw/gGyA7hdy+of74iIgm6mIl9QuJ1aiXA56Dkb7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/917] mwl8k: Fix use-after-free in mwl8k_fw_state_machine()
Date:   Mon, 15 Nov 2021 17:56:08 +0100
Message-Id: <20211115165438.035750452@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
 drivers/net/wireless/marvell/mwl8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 3bf6571f41490..529e325498cdb 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -5800,8 +5800,8 @@ static void mwl8k_fw_state_machine(const struct firmware *fw, void *context)
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



