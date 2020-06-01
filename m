Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4816C1E9D64
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 07:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgFAFni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 01:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgFAFni (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 01:43:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1E9C20734;
        Mon,  1 Jun 2020 05:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590990217;
        bh=6+2q9+Z2HM6yQkHj8vRwEZjnALyA7HpAhMpjCzSXjUo=;
        h=Subject:To:From:Date:From;
        b=Sd3MrF38SzzHB/1wM8r7U5LV21NgZUyRNFfNdsukA/YE52H5bs8lQ17MdOr8QDbwb
         Y2c3SpjsNkM2ypq5LBTgEivaqsX11XlsTGHSWHjDGPFSOm9GNPtMfAHH5Y8vjGrrRK
         e0AwypQ6re69Qtw2n7MjEdWHays93IHiPd2xezts=
Subject: patch "gnss: sirf: fix error return code in sirf_probe()" added to char-misc-next
To:     weiyongjun1@huawei.com, hulkci@huawei.com, johan@kernel.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jun 2020 07:43:34 +0200
Message-ID: <15909902147456@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    gnss: sirf: fix error return code in sirf_probe()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 43d7ce70ae43dd8523754b17f567417e0e75dbce Mon Sep 17 00:00:00 2001
From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Thu, 7 May 2020 09:42:52 +0000
Subject: gnss: sirf: fix error return code in sirf_probe()

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

This avoids a use-after-free in case the driver is later unbound.

Fixes: d2efbbd18b1e ("gnss: add driver for sirfstar-based receivers")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
[ johan: amend commit message; mention potential use-after-free ]
Cc: stable <stable@vger.kernel.org>	# 4.19
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gnss/sirf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gnss/sirf.c b/drivers/gnss/sirf.c
index effed3a8d398..2ecb1d3e8eeb 100644
--- a/drivers/gnss/sirf.c
+++ b/drivers/gnss/sirf.c
@@ -439,14 +439,18 @@ static int sirf_probe(struct serdev_device *serdev)
 
 	data->on_off = devm_gpiod_get_optional(dev, "sirf,onoff",
 			GPIOD_OUT_LOW);
-	if (IS_ERR(data->on_off))
+	if (IS_ERR(data->on_off)) {
+		ret = PTR_ERR(data->on_off);
 		goto err_put_device;
+	}
 
 	if (data->on_off) {
 		data->wakeup = devm_gpiod_get_optional(dev, "sirf,wakeup",
 				GPIOD_IN);
-		if (IS_ERR(data->wakeup))
+		if (IS_ERR(data->wakeup)) {
+			ret = PTR_ERR(data->wakeup);
 			goto err_put_device;
+		}
 
 		ret = regulator_enable(data->vcc);
 		if (ret)
-- 
2.26.2


