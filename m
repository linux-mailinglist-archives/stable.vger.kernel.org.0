Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FAF51370E
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 16:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiD1Olk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 10:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348351AbiD1Oli (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 28 Apr 2022 10:41:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F994AC91F
        for <Stable@vger.kernel.org>; Thu, 28 Apr 2022 07:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BCE9B82DA7
        for <Stable@vger.kernel.org>; Thu, 28 Apr 2022 14:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DF2C385A0;
        Thu, 28 Apr 2022 14:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651156701;
        bh=lfBHfdm5i8Z30Nk7JLdy5HgX/l1XJiIuk0A72YvZREs=;
        h=Subject:To:From:Date:From;
        b=X3GW8UTXnzZ/IcELQ8whV5mJrdiTgj+byab8wNf03ZW1Pt4HbvTkl/UmjeAC/QpoG
         O/BETrSrvi1KrUum3orMLVOtEzUVnt8XwHLQefBHFpp69HKswqEh+WPq2Mrg+BfTah
         CbIbsTR53ZlF6b1Bcoj1zD1iduXUCLIDygEtDkdU=
Subject: patch "iio: magnetometer: ak8975: Fix the error handling in" added to char-misc-linus
To:     zheyuma97@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 28 Apr 2022 16:37:53 +0200
Message-ID: <165115667349178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: magnetometer: ak8975: Fix the error handling in

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3a26787dacf04257a68b16315c984eb2c340bc5e Mon Sep 17 00:00:00 2001
From: Zheyu Ma <zheyuma97@gmail.com>
Date: Sat, 9 Apr 2022 11:48:49 +0800
Subject: iio: magnetometer: ak8975: Fix the error handling in
 ak8975_power_on()

When the driver fails to enable the regulator 'vid', we will get the
following splat:

[   79.955610] WARNING: CPU: 5 PID: 441 at drivers/regulator/core.c:2257 _regulator_put+0x3ec/0x4e0
[   79.959641] RIP: 0010:_regulator_put+0x3ec/0x4e0
[   79.967570] Call Trace:
[   79.967773]  <TASK>
[   79.967951]  regulator_put+0x1f/0x30
[   79.968254]  devres_release_group+0x319/0x3d0
[   79.968608]  i2c_device_probe+0x766/0x940

Fix this by disabling the 'vdd' regulator when failing to enable 'vid'
regulator.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Link: https://lore.kernel.org/r/20220409034849.3717231-2-zheyuma97@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/magnetometer/ak8975.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index 088f748b683e..2432e697150c 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -416,6 +416,7 @@ static int ak8975_power_on(const struct ak8975_data *data)
 	if (ret) {
 		dev_warn(&data->client->dev,
 			 "Failed to enable specified Vid supply\n");
+		regulator_disable(data->vdd);
 		return ret;
 	}
 
-- 
2.36.0


