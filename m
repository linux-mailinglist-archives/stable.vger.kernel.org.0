Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE211D4FF6
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 16:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgEOOGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 10:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgEOOGN (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 15 May 2020 10:06:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CD2F20671;
        Fri, 15 May 2020 14:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589551571;
        bh=9r+634N/hPmURoWoI8r3fHqRJ+LlnFwHszfWY+Wi2zo=;
        h=Subject:To:From:Date:From;
        b=0CiP5CWFiR2QhLr9HHo8f//vhFzQjh6xcqEqAj4IGJejT43GLlRbCheIvmh2yxMDl
         mt3o5f0K0SzxVrKPNOvaZCG7XPHaFOOj0dtlUKab5vYhQVMxNB59IQZI2cHZuroODy
         Dv1SW7LKQmYP2eRdl2mESG0di/V10fJS++sPqpYo=
Subject: patch "iio: dac: vf610: Fix an error handling path in 'vf610_dac_probe()'" added to staging-linus
To:     christophe.jaillet@wanadoo.fr, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 May 2020 16:06:07 +0200
Message-ID: <1589551567191149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: dac: vf610: Fix an error handling path in 'vf610_dac_probe()'

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From aad4742fbf0a560c25827adb58695a4497ffc204 Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 26 Apr 2020 21:44:03 +0200
Subject: iio: dac: vf610: Fix an error handling path in 'vf610_dac_probe()'

A call to 'vf610_dac_exit()' is missing in an error handling path.

Fixes: 1b983bf42fad ("iio: dac: vf610_dac: Add IIO DAC driver for Vybrid SoC")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/dac/vf610_dac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/dac/vf610_dac.c b/drivers/iio/dac/vf610_dac.c
index 71f8a5c471c4..7f1e9317c3f3 100644
--- a/drivers/iio/dac/vf610_dac.c
+++ b/drivers/iio/dac/vf610_dac.c
@@ -223,6 +223,7 @@ static int vf610_dac_probe(struct platform_device *pdev)
 	return 0;
 
 error_iio_device_register:
+	vf610_dac_exit(info);
 	clk_disable_unprepare(info->clk);
 
 	return ret;
-- 
2.26.2


