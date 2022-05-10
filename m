Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED56E5216FE
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243042AbiEJNWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242972AbiEJNVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:21:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C332C0D1D;
        Tue, 10 May 2022 06:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 697E461574;
        Tue, 10 May 2022 13:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B600C385C6;
        Tue, 10 May 2022 13:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188464;
        bh=Za0+Kg0GzcGKimpUtf0svjSHqpztZKZgkSCW3XGCFmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1H3dvzvr0plHbXvGQoBUxBCrdxWBJSz+Plt5F7k4dPCn8MftXQHSVM+WoQaTkW/1
         j2sChWl1VdV/rlgdl3DPa2pFkBVx/kqZ0xbOG5A+xqtfHAA8A0EfD2NUVe/3c4e9Q3
         kGEfoR52+JypcWkJ3k7najC+ZUwMbDbKHOrHwPeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 17/78] iio: magnetometer: ak8975: Fix the error handling in ak8975_power_on()
Date:   Tue, 10 May 2022 15:07:03 +0200
Message-Id: <20220510130733.042088677@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

commit 3a26787dacf04257a68b16315c984eb2c340bc5e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/ak8975.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -404,6 +404,7 @@ static int ak8975_power_on(const struct
 	if (ret) {
 		dev_warn(&data->client->dev,
 			 "Failed to enable specified Vid supply\n");
+		regulator_disable(data->vdd);
 		return ret;
 	}
 	/*


