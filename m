Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D041CAAF0
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgEHMiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728373AbgEHMiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CB6121835;
        Fri,  8 May 2020 12:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941501;
        bh=PbT681jOOI7ZWJTo+4QR9HI1FqWfboxcgTDxZnPyIwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HN+QPsYOMq5RbwySvO3BkD/lUy/LuVGGMfELwTlfvlglFt2vVHvAFRJggnCJ+icnT
         jU0dTnGwz1RdXPezFuBeAXVoWzQUWnbsPmaU81MNnMtx8qZef4x3BW4KH/33zF7KEY
         xaH7GB9a6hypTxSQwAO4ua0UOyCafKAvruPfW4WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chin-Ran Lo <crlo@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.4 056/312] Bluetooth: btmrvl: fix hung task warning dump
Date:   Fri,  8 May 2020 14:30:47 +0200
Message-Id: <20200508123128.498002009@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chin-Ran Lo <crlo@marvell.com>

commit 86f7ac77d4035e22ec7e58dcdb96327e2ecc3a9b upstream.

It's been observed that when bluetooth driver fails to
activate the firmware, below hung task warning dump is
displayed after 120 seconds.

[   36.461022] Bluetooth: vendor=0x2df, device=0x912e, class=255, fn=2
[   56.512128] Bluetooth: FW failed to be active in time!
[   56.517264] Bluetooth: Downloading firmware failed!
[  240.252176] INFO: task kworker/3:2:129 blocked for more than 120 seconds.
[  240.258931]       Not tainted 3.18.0 #254
[  240.262972] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.270751] kworker/3:2     D ffffffc000205760     0   129      2 0x00000000
[  240.277825] Workqueue: events request_firmware_work_func
[  240.283134] Call trace:
[  240.285581] [<ffffffc000205760>] __switch_to+0x80/0x8c
[  240.290693] [<ffffffc00088dae0>] __schedule+0x540/0x7b8
[  240.295921] [<ffffffc00088ddd0>] schedule+0x78/0x84
[  240.300764] [<ffffffc0006dfd48>] __mmc_claim_host+0xe8/0x1c8
[  240.306395] [<ffffffc0006edd6c>] sdio_claim_host+0x74/0x84
[  240.311840] [<ffffffbffc163d08>] 0xffffffbffc163d08
[  240.316685] [<ffffffbffc165104>] 0xffffffbffc165104
[  240.321524] [<ffffffbffc130cf8>] mwifiex_dnld_fw+0x98/0x110 [mwifiex]
[  240.327918] [<ffffffbffc12ee88>] mwifiex_remove_card+0x2c4/0x5fc [mwifiex]
[  240.334741] [<ffffffc000596780>] request_firmware_work_func+0x44/0x80
[  240.341127] [<ffffffc00023b934>] process_one_work+0x2ec/0x50c
[  240.346831] [<ffffffc00023c6a0>] worker_thread+0x350/0x470
[  240.352272] [<ffffffc0002419bc>] kthread+0xf0/0xfc
[  240.357019] 2 locks held by kworker/3:2/129:
[  240.361248]  #0:  ("events"){.+.+.+}, at: [<ffffffc00023b840>] process_one_work+0x1f8/0x50c
[  240.369562]  #1:  ((&fw_work->work)){+.+.+.}, at: [<ffffffc00023b840>] process_one_work+0x1f8/0x50c
[  240.378589]   task                        PC stack   pid father
[  240.384501] kworker/1:1     D ffffffc000205760     0    40      2 0x00000000
[  240.391524] Workqueue: events mtk_atomic_work
[  240.395884] Call trace:
[  240.398317] [<ffffffc000205760>] __switch_to+0x80/0x8c
[  240.403448] [<ffffffc00027279c>] lock_acquire+0x128/0x164
[  240.408821] kworker/3:2     D ffffffc000205760     0   129      2 0x00000000
[  240.415867] Workqueue: events request_firmware_work_func
[  240.421138] Call trace:
[  240.423589] [<ffffffc000205760>] __switch_to+0x80/0x8c
[  240.428688] [<ffffffc00088dae0>] __schedule+0x540/0x7b8
[  240.433886] [<ffffffc00088ddd0>] schedule+0x78/0x84
[  240.438732] [<ffffffc0006dfd48>] __mmc_claim_host+0xe8/0x1c8
[  240.444361] [<ffffffc0006edd6c>] sdio_claim_host+0x74/0x84
[  240.449801] [<ffffffbffc163d08>] 0xffffffbffc163d08
[  240.454649] [<ffffffbffc165104>] 0xffffffbffc165104
[  240.459486] [<ffffffbffc130cf8>] mwifiex_dnld_fw+0x98/0x110 [mwifiex]
[  240.465882] [<ffffffbffc12ee88>] mwifiex_remove_card+0x2c4/0x5fc [mwifiex]
[  240.472705] [<ffffffc000596780>] request_firmware_work_func+0x44/0x80
[  240.479090] [<ffffffc00023b934>] process_one_work+0x2ec/0x50c
[  240.484794] [<ffffffc00023c6a0>] worker_thread+0x350/0x470
[  240.490231] [<ffffffc0002419bc>] kthread+0xf0/0xfc

This patch adds missing sdio_release_host() call so that wlan driver
thread can claim sdio host.

Fixes: 4863e4cc31d647e1 ("Bluetooth: btmrvl: release sdio bus after firmware is up")
Signed-off-by: Chin-Ran Lo <crlo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btmrvl_sdio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -1112,7 +1112,8 @@ static int btmrvl_sdio_download_fw(struc
 	 */
 	if (btmrvl_sdio_verify_fw_download(card, pollnum)) {
 		BT_ERR("FW failed to be active in time!");
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto done;
 	}
 
 	sdio_release_host(card->func);


