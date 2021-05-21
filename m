Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B3938C821
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 15:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhEUNbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 09:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232172AbhEUNbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 09:31:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 061EF610CB;
        Fri, 21 May 2021 13:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621603829;
        bh=DgSfnqgX8iAJF8CgJVRj6UxP6HXcUcoeisNmrM46YX8=;
        h=From:To:Cc:Subject:Date:From;
        b=g7OtleNjz6iGFBsYuSb4zRjfyQz9uUglSD21ywr0RyMPosjj6n5UlIP54yur6orbo
         E2lzAOQzz43sex9CLMHDPZnu6Ar9+Jwm6tpNYQInhIxDJyzN34XxSnSIEcNXPE/M2J
         Atf7YvlkvzPkbvwtlhXNndUeKLlYR+rchs7mb8yN/NnpcyRDTCkJAZ2Fq5+H7Va1M2
         CpOukwWo3RGWl40nh5f5cLaFLB3vvGeyhrODLrG/UwUtdxwml/JBCEq6UTRbQzWDu5
         /1CZPykn3tdxUF2qg5j0glxpdr4nVHZE/lQR5K5HwNDBRAvB1sc1gD399MdwmMf0rX
         x6/X3jI4Dykdw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lk5EU-0004Vh-44; Fri, 21 May 2021 15:30:30 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-mmc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] mmc: vub3000: fix control-request direction
Date:   Fri, 21 May 2021 15:30:26 +0200
Message-Id: <20210521133026.17296-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the SET_ROM_WAIT_STATES request which erroneously used
usb_rcvctrlpipe().

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Cc: stable@vger.kernel.org      # 3.0
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/mmc/host/vub300.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 739cf63ef6e2..4950d10d3a19 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2279,7 +2279,7 @@ static int vub300_probe(struct usb_interface *interface,
 	if (retval < 0)
 		goto error5;
 	retval =
-		usb_control_msg(vub300->udev, usb_rcvctrlpipe(vub300->udev, 0),
+		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_ROM_WAIT_STATES,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				firmware_rom_wait_states, 0x0000, NULL, 0, HZ);
-- 
2.26.3

