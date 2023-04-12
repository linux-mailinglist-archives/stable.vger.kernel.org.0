Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591556DEF7A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjDLIvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjDLIvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:51:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B4A9772
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 968E563163
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A778DC433D2;
        Wed, 12 Apr 2023 08:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289392;
        bh=21OnGELfFIqpPmaF6jBtOcYh5Fp4wg3v95cGurPvF2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmL7FxzjOZjRJjKn/pJvPpZ1fIxPH0SNhgo6vf84EhoJpXLepZY5BLyGLi6bMRjca
         Wtp1qnnowWUxHd+fmez8S5kTP045TcyfzuMFJCEj8JZFKF+fc8fLYlAnd6G/e9vSv9
         APnhbB+KUQqgdjBn8f7FlxicuvcYuCrmLcqTRzHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 081/173] iio: light: vcnl4000: Fix WARN_ON on uninitialized lock
Date:   Wed, 12 Apr 2023 10:33:27 +0200
Message-Id: <20230412082841.329969092@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mårten Lindahl <marten.lindahl@axis.com>

commit 42ec40b0883c1cce58b06e8fa82049a61033151c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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



