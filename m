Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981A169CC83
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbjBTNlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbjBTNlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:41:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6691D923
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:40:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDD48B80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D54EC433D2;
        Mon, 20 Feb 2023 13:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900453;
        bh=WFgLCuryaOcR9O+fGLnRQ083XnmusI91EmrDq6UbRgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALOMW7Fzf26eougAZA3JVmzw8yEtoBUDX+ujYHX3ErI5jqBcXktS9qOaaMVnHlTOD
         fQMMKwjzkt5cyXaXTAl+tF8HHkEj59eAIoLCn3ikpMOOQXjnrnBQK/OjNY/CV3aR3r
         dGCM8vLUs9BYLPFfEyk1m1DYRv2/wpM/h/DQPXls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 31/89] iio: adc: berlin2-adc: Add missing of_node_put() in error path
Date:   Mon, 20 Feb 2023 14:35:30 +0100
Message-Id: <20230220133554.255012068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

commit cbd3a0153cd18a2cbef6bf3cf31bb406c3fc9f55 upstream.

of_get_parent() will return a device_node pointer with refcount
incremented. We need to use of_node_put() on it when done. Add the
missing of_node_put() in the error path of berlin2_adc_probe();

Fixes: 70f1937911ca ("iio: adc: add support for Berlin")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20221129020316.191731-1-wangxiongfeng2@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/berlin2-adc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/berlin2-adc.c
+++ b/drivers/iio/adc/berlin2-adc.c
@@ -289,8 +289,10 @@ static int berlin2_adc_probe(struct plat
 	int ret;
 
 	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*priv));
-	if (!indio_dev)
+	if (!indio_dev) {
+		of_node_put(parent_np);
 		return -ENOMEM;
+	}
 
 	priv = iio_priv(indio_dev);
 	platform_set_drvdata(pdev, indio_dev);


