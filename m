Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2957F3C5584
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhGLIKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353699AbhGLICr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D0946162D;
        Mon, 12 Jul 2021 07:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076612;
        bh=QIcrSoPAStZLEydIq7pJN/J5TiFrrMuUZPmEuxKOUuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0Xx9x4zkLTupMYW26drFr1xNhLryEjcLi9MnaOYDiXU2L3EputaFlG0B5ZhI6kMh
         kGkXLvoZlGLodITCIeG/RmbXnwZab0xpviouMd7o92JPqvi8YArZt+Ejk13pW4oPHC
         ei1gNAl+61Lv32TVzHM/1n0Miibiq1M0dOMuS3Bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 719/800] staging: rtl8712: fix memory leak in rtl871x_load_fw_cb
Date:   Mon, 12 Jul 2021 08:12:22 +0200
Message-Id: <20210712061043.232523837@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit e02a3b945816a77702a2769a70ef5f9b06e49d54 ]

There is a leak in rtl8712 driver.
The problem was in non-freed adapter data if
firmware load failed.

This leak can be reproduced with this code:
https://syzkaller.appspot.com/text?tag=ReproC&x=16612f02d00000,
Autoload must fail (to not hit memory leak reported by syzkaller)

There are 2 possible ways how rtl871x_load_fw_cb() and
r871xu_dev_remove() can be called (in case of fw load error).

1st case:
	r871xu_dev_remove() then rtl871x_load_fw_cb()

	In this case r871xu_dev_remove() will wait for
	completion and then will jump to the end, because
	rtl871x_load_fw_cb() set intfdata to NULL:

	if (pnetdev) {
		struct _adapter *padapter = netdev_priv(pnetdev);

		/* never exit with a firmware callback pending */
		wait_for_completion(&padapter->rtl8712_fw_ready);
		pnetdev = usb_get_intfdata(pusb_intf);
		usb_set_intfdata(pusb_intf, NULL);
		if (!pnetdev)
			goto firmware_load_fail;

		... clean up code here ...
	}

2nd case:
	rtl871x_load_fw_cb() then r871xu_dev_remove()

	In this case pnetdev (from code snippet above) will
	be zero (because rtl871x_load_fw_cb() set it to NULL)
	And clean up code won't be executed again.

So, in all cases we need to free adapted data in rtl871x_load_fw_cb(),
because disconnect function cannot take care of it. And there won't be
any race conditions, because complete() call happens after setting
intfdata to NULL.

In previous patch I moved out free_netdev() from r8712_free_drv_sw()
and that's why now it's possible to free adapter data and then call
complete.

Fixes: 8c213fa59199 ("staging: r8712u: Use asynchronous firmware loading")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/81e68fe0194499cc2e7692d35bc4dcf167827d8f.1623620630.git.paskripkin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8712/hal_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 715f1fe8b472..22974277afa0 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -40,7 +40,10 @@ static void rtl871x_load_fw_cb(const struct firmware *firmware, void *context)
 		dev_err(&udev->dev, "r8712u: Firmware request failed\n");
 		usb_put_dev(udev);
 		usb_set_intfdata(usb_intf, NULL);
+		r8712_free_drv_sw(adapter);
+		adapter->dvobj_deinit(adapter);
 		complete(&adapter->rtl8712_fw_ready);
+		free_netdev(adapter->pnetdev);
 		return;
 	}
 	adapter->fw = firmware;
-- 
2.30.2



