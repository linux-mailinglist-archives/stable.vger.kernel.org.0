Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69B85AEC39
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbiIFO0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241815AbiIFOWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:22:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCCD7CB42;
        Tue,  6 Sep 2022 06:52:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E5AFB818C4;
        Tue,  6 Sep 2022 13:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C52DC433C1;
        Tue,  6 Sep 2022 13:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471473;
        bh=083OfJKByJziQrYc13jloizTv4GyIcdcB08yBp/+ttU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJKII7rIlvJxFxkS8eBqzB5aDXQIrkEZhmqtWZTb97CH11mDH/BoXpj+HJI2RZ7Kc
         MqdHUDosnyZ7mgze0h3qkBMrNv3pEMwdGAVcb59jTJXdLaekKPiH5r2Mk0SPcHni+Q
         hvWLst/LhO5R+N8LXN+BQekY6lkeyca6WRpLt3Iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matti Vaittinen <mazziesaccount@gmail.com>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 039/107] iio: ad7292: Prevent regulator double disable
Date:   Tue,  6 Sep 2022 15:30:20 +0200
Message-Id: <20220906132823.461582332@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit 22b4277641c6823ec03d5b1cd82628e5e53e75b7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7292.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/iio/adc/ad7292.c
+++ b/drivers/iio/adc/ad7292.c
@@ -287,10 +287,8 @@ static int ad7292_probe(struct spi_devic
 
 		ret = devm_add_action_or_reset(&spi->dev,
 					       ad7292_regulator_disable, st);
-		if (ret) {
-			regulator_disable(st->reg);
+		if (ret)
 			return ret;
-		}
 
 		ret = regulator_get_voltage(st->reg);
 		if (ret < 0)


