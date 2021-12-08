Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B6546D3C8
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbhLHM5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbhLHM5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 07:57:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855E4C061746
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 04:54:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD164CE2167
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 12:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78000C00446;
        Wed,  8 Dec 2021 12:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968056;
        bh=l3PTzdl2giIZ1dGxpBWP8CjAYylsDopWE786F6xSDi4=;
        h=Subject:To:From:Date:From;
        b=Fs39VPOh+aM4VKvz674Sf0tj8JitzmMpvF+bI9RKIMDdwCl3H6rb2SwB+tR7ZSiQw
         k3MCpa4fQyMcrSf4ftcL+d2daWDzE1Xim9HubMwGCEFGZEdCnCIfS4Z2H2LUZ9HePZ
         r2eIXC2h5XEY+YUabRH0fAjJ6ZarTYz+AyrH1aWw=
Subject: patch "iio: dln2: Check return value of devm_iio_trigger_register()" added to char-misc-linus
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:55 +0100
Message-ID: <1638968035211126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: dln2: Check return value of devm_iio_trigger_register()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 90751fb9f224e0e1555b49a8aa9e68f6537e4cec Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Mon, 1 Nov 2021 14:30:43 +0100
Subject: iio: dln2: Check return value of devm_iio_trigger_register()

Registering a trigger can fail and the return value of
devm_iio_trigger_register() must be checked. Otherwise undefined behavior
can occur when the trigger is used.

Fixes: 7c0299e879dd ("iio: adc: Add support for DLN2 ADC")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20211101133043.6974-1-lars@metafoo.de
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/dln2-adc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/dln2-adc.c b/drivers/iio/adc/dln2-adc.c
index 6c67192946aa..97d162a3cba4 100644
--- a/drivers/iio/adc/dln2-adc.c
+++ b/drivers/iio/adc/dln2-adc.c
@@ -655,7 +655,11 @@ static int dln2_adc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	iio_trigger_set_drvdata(dln2->trig, dln2);
-	devm_iio_trigger_register(dev, dln2->trig);
+	ret = devm_iio_trigger_register(dev, dln2->trig);
+	if (ret) {
+		dev_err(dev, "failed to register trigger: %d\n", ret);
+		return ret;
+	}
 	iio_trigger_set_immutable(indio_dev, dln2->trig);
 
 	ret = devm_iio_triggered_buffer_setup(dev, indio_dev, NULL,
-- 
2.34.1


