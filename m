Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F5E6CBDC0
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbjC1LcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbjC1Lb6 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 28 Mar 2023 07:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD73983D9
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 04:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5772760ADD
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 11:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB76C433EF;
        Tue, 28 Mar 2023 11:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003095;
        bh=ttuqKUJr0RkwIK8jLh+Q5+vnmGvNKPxNBMQ4jpao514=;
        h=Subject:To:From:Date:From;
        b=0DDfoXkvg98MorGb/+u+m7U4wbvICyldxwujgn8UKdEC60DxU3/nYsXAO/qUp9usI
         pIeMSglesC0P6soG0HusOskUAHQK6qgiFFXBNL/YM4xvYYz9/0WMFkSK7Nv4aegyT2
         yLhYAejApxtZt2e3KkRM/kIm9AL/7b61QgnEk1Jw=
Subject: patch "iio: light: vcnl4000: Fix WARN_ON on uninitialized lock" added to char-misc-linus
To:     marten.lindahl@axis.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andriy.shevchenko@linux.intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:31:26 +0200
Message-ID: <16800030863296@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: vcnl4000: Fix WARN_ON on uninitialized lock

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 42ec40b0883c1cce58b06e8fa82049a61033151c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>
Date: Tue, 31 Jan 2023 15:01:09 +0100
Subject: iio: light: vcnl4000: Fix WARN_ON on uninitialized lock
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There are different init functions for the sensors in this driver in
which only one initializes the generic vcnl4000_lock. With commit
e21b5b1f2669 ("iio: light: vcnl4000: Preserve conf bits when toggle power")
the vcnl4040 sensor started to depend on the lock, but it was missed to
initialize it in vcnl4040's init function. This has not been visible
until we run lockdep on it:

  DEBUG_LOCKS_WARN_ON(lock->magic != lock)
  at kernel/locking/mutex.c:575 __mutex_lock+0x4f8/0x890
  Call trace:
  __mutex_lock
  mutex_lock_nested
  vcnl4200_set_power_state
  vcnl4200_init
  vcnl4000_probe

Fix this by initializing the lock in the probe function instead of doing
it in the chip specific init functions.

Fixes: e21b5b1f2669 ("iio: light: vcnl4000: Preserve conf bits when toggle power")
Signed-off-by: Mårten Lindahl <marten.lindahl@axis.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230131140109.2067577-1-marten.lindahl@axis.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/vcnl4000.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index cc1a2062e76d..69c5bc987e26 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -199,7 +199,6 @@ static int vcnl4000_init(struct vcnl4000_data *data)
 
 	data->rev = ret & 0xf;
 	data->al_scale = 250000;
-	mutex_init(&data->vcnl4000_lock);
 
 	return data->chip_spec->set_power_state(data, true);
 };
@@ -1197,6 +1196,8 @@ static int vcnl4000_probe(struct i2c_client *client)
 	data->id = id->driver_data;
 	data->chip_spec = &vcnl4000_chip_spec_cfg[data->id];
 
+	mutex_init(&data->vcnl4000_lock);
+
 	ret = data->chip_spec->init(data);
 	if (ret < 0)
 		return ret;
-- 
2.40.0


