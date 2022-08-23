Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A4459E3EF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244624AbiHWMmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239933AbiHWMlz (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 23 Aug 2022 08:41:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6B310A744
        for <Stable@vger.kernel.org>; Tue, 23 Aug 2022 02:51:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AB4D6152D
        for <Stable@vger.kernel.org>; Tue, 23 Aug 2022 09:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5296DC433D6;
        Tue, 23 Aug 2022 09:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247876;
        bh=zFxkzXmRFfH4VWQzczaWNdLn10+77ACeLJcMm/dSmwo=;
        h=Subject:To:From:Date:From;
        b=F6zg/RtZwdoGNomjxw0GamO5kN9YxD/9p+OICDvp3j4RHPMAYwhls77jylUnwNQeW
         62Q++TcA3yVoWtuvbay4ozaGRJ2ObqjPc9ERkzTtANiRJzfrrxw2W7O+V76ajIuNT/
         v5J88OeEBYdth7YsN3jPZgHFdhEGxIqjgBgMrSmM=
Subject: patch "iio: ad7292: Prevent regulator double disable" added to char-misc-linus
To:     mazziesaccount@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, marcelo.schmitt1@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Aug 2022 10:43:00 +0200
Message-ID: <16612441808942@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: ad7292: Prevent regulator double disable

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 22b4277641c6823ec03d5b1cd82628e5e53e75b7 Mon Sep 17 00:00:00 2001
From: Matti Vaittinen <mazziesaccount@gmail.com>
Date: Fri, 19 Aug 2022 11:51:07 +0300
Subject: iio: ad7292: Prevent regulator double disable

The ad7292 tries to add an devm_action for disabling a regulator at
device detach using devm_add_action_or_reset(). The
devm_add_action_or_reset() does call the release function should adding
action fail. The driver inspects the value returned by
devm_add_action_or_reset() and manually calls regulator_disable() if
adding the action has failed. This leads to double disable and messes
the enable count for regulator.

Do not manually call disable if devm_add_action_or_reset() fails.

Fixes: 506d2e317a0a ("iio: adc: Add driver support for AD7292")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Tested-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Link: https://lore.kernel.org/r/Yv9O+9sxU7gAv3vM@fedora
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ad7292.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ad7292.c b/drivers/iio/adc/ad7292.c
index 92c68d467c50..a2f9fda25ff3 100644
--- a/drivers/iio/adc/ad7292.c
+++ b/drivers/iio/adc/ad7292.c
@@ -287,10 +287,8 @@ static int ad7292_probe(struct spi_device *spi)
 
 		ret = devm_add_action_or_reset(&spi->dev,
 					       ad7292_regulator_disable, st);
-		if (ret) {
-			regulator_disable(st->reg);
+		if (ret)
 			return ret;
-		}
 
 		ret = regulator_get_voltage(st->reg);
 		if (ret < 0)
-- 
2.37.2


