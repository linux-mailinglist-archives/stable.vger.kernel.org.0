Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B036E618A
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbjDRMZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjDRMZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:25:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE2FAD33
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:25:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1127F6313A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23042C433EF;
        Tue, 18 Apr 2023 12:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820709;
        bh=RCcIzMqCRkDHlbXcY9Qu9etEFyg9ePZW9O64p7a5/C4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=epJ2L2X7qMAWDAXVyO5GX75+u/rKECxZyYziB7Gcy6OEIjPPUYR0zZEQffsThi1zI
         16XahZMgyhUTuVTaDsCP2BxLd6Qln8fsH7RvOU/sLmatuXzlV3NG4GyzbzNmBNwswe
         5SjQVfjE9TMsSIDyOoDVcERpmc6cHvp4jUcUCSsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        William Breathitt Gray <william.gray@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 09/37] iio: dac: cio-dac: Fix max DAC write value check for 12-bit
Date:   Tue, 18 Apr 2023 14:21:19 +0200
Message-Id: <20230418120255.002127672@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
References: <20230418120254.687480980@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <william.gray@linaro.org>

commit c3701185ee1973845db088d8b0fc443397ab0eb2 upstream.

The CIO-DAC series of devices only supports DAC values up to 12-bit
rather than 16-bit. Trying to write a 16-bit value results in only the
lower 12 bits affecting the DAC output which is not what the user
expects. Instead, adjust the DAC write value check to reject values
larger than 12-bit so that they fail explicitly as invalid for the user.

Fixes: 3b8df5fd526e ("iio: Add IIO support for the Measurement Computing CIO-DAC family")
Cc: stable@vger.kernel.org
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/20230311002248.8548-1-william.gray@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/cio-dac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/dac/cio-dac.c
+++ b/drivers/iio/dac/cio-dac.c
@@ -74,8 +74,8 @@ static int cio_dac_write_raw(struct iio_
 	if (mask != IIO_CHAN_INFO_RAW)
 		return -EINVAL;
 
-	/* DAC can only accept up to a 16-bit value */
-	if ((unsigned int)val > 65535)
+	/* DAC can only accept up to a 12-bit value */
+	if ((unsigned int)val > 4095)
 		return -EINVAL;
 
 	priv->chan_out_states[chan->channel] = val;


