Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0067451A604
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353785AbiEDQwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353737AbiEDQwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C09E4706C;
        Wed,  4 May 2022 09:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ECB5B82553;
        Wed,  4 May 2022 16:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00721C385A4;
        Wed,  4 May 2022 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682910;
        bh=BUOk1zYNp2SO4CFbYAyT2aAi+mKxa4j9bzGzbW0e+FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+GKl65dui3dXZR0sF4GRkrzThJSCAtC17IkCueEv85Or6ajJf07YF8y+zwMHqeb6
         YkQHV0aW5uzRFczrUdBinUfdOfmJB5NCzs7lIr+GD+ntULZKKj37BZ8DVc6V4xOVJu
         LnojNrua3KgpZt3gaZnOPWaqLV0fzHh6kH602Jmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 16/84] iio: magnetometer: ak8975: Fix the error handling in ak8975_power_on()
Date:   Wed,  4 May 2022 18:43:57 +0200
Message-Id: <20220504152928.939190636@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
@@ -391,6 +391,7 @@ static int ak8975_power_on(const struct
 	if (ret) {
 		dev_warn(&data->client->dev,
 			 "Failed to enable specified Vid supply\n");
+		regulator_disable(data->vdd);
 		return ret;
 	}
 	/*


