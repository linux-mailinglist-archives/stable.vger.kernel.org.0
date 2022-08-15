Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5595B593D3F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241207AbiHOUOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347039AbiHOUMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:12:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE50E8A6DD;
        Mon, 15 Aug 2022 11:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57934B8109E;
        Mon, 15 Aug 2022 18:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1272C433D7;
        Mon, 15 Aug 2022 18:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589929;
        bh=72iw2wQ65KIGB4P3ShPzgBQnjxHwzejp/XEhvwJNXXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1XA/N6LgXn6nIa85f6a/k9Eztrr+RU0Tn4xxUv51wSgzk4NLdYa30J2CfJ1EA7DC
         4BueSnOY6XVrZ6/WmkyiwogTBiu4zISeb5S0ANTElkwzIieS+39t5ALZmsXUu93m6p
         QPfu4EiQwZuRqv9q7VoS9HvBzK4i1k63KubHKSck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.18 0093/1095] iio: light: isl29028: Fix the warning in isl29028_remove()
Date:   Mon, 15 Aug 2022 19:51:32 +0200
Message-Id: <20220815180433.391445328@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Zheyu Ma <zheyuma97@gmail.com>

commit 06674fc7c003b9d0aa1d37fef7ab2c24802cc6ad upstream.

The driver use the non-managed form of the register function in
isl29028_remove(). To keep the release order as mirroring the ordering
in probe, the driver should use non-managed form in probe, too.

The following log reveals it:

[   32.374955] isl29028 0-0010: remove
[   32.376861] general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN PTI
[   32.377676] KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
[   32.379432] RIP: 0010:kernfs_find_and_get_ns+0x28/0xe0
[   32.385461] Call Trace:
[   32.385807]  sysfs_unmerge_group+0x59/0x110
[   32.386110]  dpm_sysfs_remove+0x58/0xc0
[   32.386391]  device_del+0x296/0xe50
[   32.386959]  cdev_device_del+0x1d/0xd0
[   32.387231]  devm_iio_device_unreg+0x27/0xb0
[   32.387542]  devres_release_group+0x319/0x3d0
[   32.388162]  i2c_device_remove+0x93/0x1f0

Fixes: 2db5054ac28d ("staging: iio: isl29028: add runtime power management support")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Link: https://lore.kernel.org/r/20220717004241.2281028-1-zheyuma97@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/isl29028.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/isl29028.c
+++ b/drivers/iio/light/isl29028.c
@@ -625,7 +625,7 @@ static int isl29028_probe(struct i2c_cli
 					 ISL29028_POWER_OFF_DELAY_MS);
 	pm_runtime_use_autosuspend(&client->dev);
 
-	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
+	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev,
 			"%s(): iio registration failed with error %d\n",


