Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD6663DFEB
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiK3Svs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiK3Svj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:51:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4215163D5B
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:51:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABE4D61D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0CCC433C1;
        Wed, 30 Nov 2022 18:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834297;
        bh=Ntv+QrQhxvM2sihsRpq7Evvd5odVbtJd1ujvzk2p3t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUCThYxSIMDpH4cluRaUOl/Mlku0mZTgnHeXASUzD+JmuXRsUjo5n7wrLwn1EJCbv
         S4W3Pbk/5mJASZp16ABv99mns014xBkfSA8r7TsRNL7wWjVFP9SL9vIMBQ+LhGxLuf
         KA6y77aH7Cn9eLyLulRUlfHp0zFRXmSlk8B1f0ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dong Chenchen <dongchenchen2@huawei.com>,
        Jagath Jog J <jagathjog1996@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.0 174/289] iio: accel: bma400: Fix memory leak in bma400_get_steps_reg()
Date:   Wed, 30 Nov 2022 19:22:39 +0100
Message-Id: <20221130180548.074482290@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Dong Chenchen <dongchenchen2@huawei.com>

commit 20690cd50e68c0313472c7539460168b8ea6444d upstream.

When regmap_bulk_read() fails, it does not free steps_raw,
which will cause a memory leak issue, this patch fixes it.

Fixes: d221de60eee3 ("iio: accel: bma400: Add separate channel for step counter")
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
Reviewed-by: Jagath Jog J <jagathjog1996@gmail.com>
Link: https://lore.kernel.org/r/20221110010726.235601-1-dongchenchen2@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/bma400_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/accel/bma400_core.c
+++ b/drivers/iio/accel/bma400_core.c
@@ -673,8 +673,10 @@ static int bma400_get_steps_reg(struct b
 
 	ret = regmap_bulk_read(data->regmap, BMA400_STEP_CNT0_REG,
 			       steps_raw, BMA400_STEP_RAW_LEN);
-	if (ret)
+	if (ret) {
+		kfree(steps_raw);
 		return ret;
+	}
 	*val = get_unaligned_le24(steps_raw);
 	kfree(steps_raw);
 	return IIO_VAL_INT;


