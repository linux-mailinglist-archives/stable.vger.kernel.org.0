Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A854C137BD6
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 07:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgAKGQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 01:16:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgAKGQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 01:16:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9C952072E;
        Sat, 11 Jan 2020 06:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578723385;
        bh=DOl1cId/6NtQZrWQf88AYsudY/JuMvNqDOG+X7l05sQ=;
        h=Subject:To:From:Date:From;
        b=oiS4EmWFLx4d/afNTE2Wv4arL0Hrzq9WvYT4JuyUJuYgVJlUuCJk3glpbP5b9f5ao
         9mwS3KAUytwS4JW4zJBqODgXCWu4MwhjR3umIL9xROVeY41KhPm/xId11pRFsvwIPu
         tvdLoxtIbq7PgYyU98uEmDmha1GbHgALiINfX54Q=
Subject: patch "nvmem: imx: scu: fix write SIP" added to char-misc-next
To:     peng.fan@nxp.com, gregkh@linuxfoundation.org,
        srinivas.kandagatla@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 11 Jan 2020 07:16:18 +0100
Message-ID: <15787233787222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    nvmem: imx: scu: fix write SIP

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 40bb95dbb8acca35f8d52a833393ddbb01cfa2db Mon Sep 17 00:00:00 2001
From: Peng Fan <peng.fan@nxp.com>
Date: Thu, 9 Jan 2020 10:40:14 +0000
Subject: nvmem: imx: scu: fix write SIP

SIP number 0xC200000A is for reading, 0xC200000B is for writing.
And the following two args for write are word index, data to write.

Fixes: 885ce72a09d0 ("nvmem: imx: scu: support write")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200109104017.6249-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/imx-ocotp-scu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvmem/imx-ocotp-scu.c b/drivers/nvmem/imx-ocotp-scu.c
index 03f1ab23ad51..455675dd8efe 100644
--- a/drivers/nvmem/imx-ocotp-scu.c
+++ b/drivers/nvmem/imx-ocotp-scu.c
@@ -15,8 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#define IMX_SIP_OTP			0xC200000A
-#define IMX_SIP_OTP_WRITE		0x2
+#define IMX_SIP_OTP_WRITE		0xc200000B
 
 enum ocotp_devtype {
 	IMX8QXP,
@@ -212,8 +211,7 @@ static int imx_scu_ocotp_write(void *context, unsigned int offset,
 
 	mutex_lock(&scu_ocotp_mutex);
 
-	arm_smccc_smc(IMX_SIP_OTP, IMX_SIP_OTP_WRITE, index, *buf,
-		      0, 0, 0, 0, &res);
+	arm_smccc_smc(IMX_SIP_OTP_WRITE, index, *buf, 0, 0, 0, 0, 0, &res);
 
 	mutex_unlock(&scu_ocotp_mutex);
 
-- 
2.24.1


