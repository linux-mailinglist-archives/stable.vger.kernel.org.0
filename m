Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D7055C2E5
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236494AbiF0LnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237014AbiF0Ll1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:41:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED00CE2E;
        Mon, 27 Jun 2022 04:35:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B022E6109A;
        Mon, 27 Jun 2022 11:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCA0C3411D;
        Mon, 27 Jun 2022 11:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329757;
        bh=RmxleTHRx9eDngqkQmJd38Pc//gTKX73d1yQFgoNmmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nVb2WoPLvRkF/+/uowenZcyDlmUfNQ8mxWJV+GnNMBqhER1GlGrVSV5FzfYaPZhOk
         bt0hIpYeHUvPKs+p4xq6hRmwh30ileWVe2LarCxd+A8o45eGDv8MCsqgMzpTwjrAI5
         9hbs1CH+4njdZsDXJUsEHavsTddBURARZ+9ReuRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Beguin <liambeguin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Peter Rosin <peda@axentia.se>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 105/135] iio: afe: rescale: Fix boolean logic bug
Date:   Mon, 27 Jun 2022 13:21:52 +0200
Message-Id: <20220627111941.202746905@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 9decacd8b3a432316d61c4366f302e63384cb08d upstream.

When introducing support for processed channels I needed
to invert the expression:

  if (!iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
      !iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE))
        dev_err(dev, "source channel does not support raw/scale\n");

To the inverse, meaning detect when we can usse raw+scale
rather than when we can not. This was the result:

  if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
      iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE))
       dev_info(dev, "using raw+scale source channel\n");

Ooops. Spot the error. Yep old George Boole came up and bit me.
That should be an &&.

The current code "mostly works" because we have not run into
systems supporting only raw but not scale or only scale but not
raw, and I doubt there are few using the rescaler on anything
such, but let's fix the logic.

Cc: Liam Beguin <liambeguin@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 53ebee949980 ("iio: afe: iio-rescale: Support processed channels")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Liam Beguin <liambeguin@gmail.com>
Acked-by: Peter Rosin <peda@axentia.se>
Link: https://lore.kernel.org/r/20220524075448.140238-1-linus.walleij@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/afe/iio-rescale.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/afe/iio-rescale.c
+++ b/drivers/iio/afe/iio-rescale.c
@@ -148,7 +148,7 @@ static int rescale_configure_channel(str
 	chan->ext_info = rescale->ext_info;
 	chan->type = rescale->cfg->type;
 
-	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
+	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) &&
 	    iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE)) {
 		dev_info(dev, "using raw+scale source channel\n");
 	} else if (iio_channel_has_info(schan, IIO_CHAN_INFO_PROCESSED)) {


