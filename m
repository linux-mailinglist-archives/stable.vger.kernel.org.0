Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9B33D4856
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 17:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhGXOrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Jul 2021 10:47:36 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:33589 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhGXOrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Jul 2021 10:47:35 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 16OFS0nN018768;
        Sat, 24 Jul 2021 17:28:00 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Subject: [PATCH] USB: serial: ch341: fix character loss at high transfer rates
Date:   Sat, 24 Jul 2021 17:27:39 +0200
Message-Id: <20210724152739.18726-1-w@1wt.eu>
X-Mailer: git-send-email 2.17.5
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The chip supports high transfer rates, but with the small default buffers
(64 bytes read), some entire blocks are regularly lost. This typically
happens at 1.5 Mbps (which is the default speed on Rockchip devices) when
used as a console to access U-Boot where the output of the "help" command
misses many lines and where "printenv" mangles the environment.

The FTDI driver doesn't suffer at all from this. One difference is that
it uses 512 bytes rx buffers and 256 bytes tx buffers. Adopting these
values completely resolved the issue, even the output of "dmesg" is
reliable. I preferred to leave the Tx value unchanged as it is not
involved in this issue, while a change could increase the risk of
triggering the same issue with other devices having too small buffers.

I verified that it backports well (and works) at least to 5.4. It's of
low importance enough to be dropped where it doesn't trivially apply
anymore.

Cc: stable@vger.kernel.org
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/serial/ch341.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 2db917eab799..8a521b5ea769 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -851,6 +851,7 @@ static struct usb_serial_driver ch341_device = {
 		.owner	= THIS_MODULE,
 		.name	= "ch341-uart",
 	},
+	.bulk_in_size      = 512,
 	.id_table          = id_table,
 	.num_ports         = 1,
 	.open              = ch341_open,
-- 
2.17.5

