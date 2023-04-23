Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053436EBE1F
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 10:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjDWI4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 04:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDWI4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 04:56:37 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF5B1BDF;
        Sun, 23 Apr 2023 01:56:36 -0700 (PDT)
Received: from dggpeml500012.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q428V6nbXzncN2;
        Sun, 23 Apr 2023 16:52:42 +0800 (CST)
Received: from localhost.localdomain (10.67.175.61) by
 dggpeml500012.china.huawei.com (7.185.36.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 16:56:31 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <harperchen1110@gmail.com>
CC:     <andi.shyti@kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <zhengyejian1@huawei.com>
Subject: re: [PATCH v4] i2c: xgene-slimpro: Fix out-of-bounds bug in xgene_slimpro_i2c_xfer()
Date:   Sun, 23 Apr 2023 17:00:08 +0800
Message-ID: <20230423090008.3189587-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230314165421.2823691-1-harperchen1110@gmail.com>
References: <20230314165421.2823691-1-harperchen1110@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.61]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> The data->block[0] variable comes from user and is a number between
> 0-255. Without proper check, the variable may be very large to cause
> an out-of-bounds when performing memcpy in slimpro_i2c_blkwr.
> 
> Fix this bug by checking the value of writelen.
> 
> Fixes: f6505fbabc42 ("i2c: add SLIMpro I2C device driver on APM X-Gene
> platform")
> Signed-off-by: Wei Chen <harperchen1110@gmail.com>
> Cc: stable@vger.kernel.org
> ---
> Changes in v2:
>  - Put length check inside slimpro_i2c_blkwr
> Changes in v3:
>  - Correct the format of patch
> Changes in v4:
>  - CC stable email address
> 
>  drivers/i2c/busses/i2c-xgene-slimpro.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/i2c/busses/i2c-xgene-slimpro.c
> b/drivers/i2c/busses/i2c-xgene-slimpro.c
> index bc9a3e7e0c96..0f7263e2276a 100644
> --- a/drivers/i2c/busses/i2c-xgene-slimpro.c
> +++ b/drivers/i2c/busses/i2c-xgene-slimpro.c
> @@ -308,6 +308,9 @@ static int slimpro_i2c_blkwr(struct slimpro_i2c_dev
> *ctx, u32 chip,
> 	u32 msg[3];
> 	int rc;
>  
> +	if (writelen > I2C_SMBUS_BLOCK_MAX)
> +		return -EINVAL;
> +
> 	memcpy(ctx->dma_buffer, data, writelen);

Hi, I'm not sure if following case is problematic since I'm not familiar
with i2c :)

See following code path, when data->block[0] == I2C_SMBUS_BLOCK_MAX,
writelen == I2C_SMBUS_BLOCK_MAX + 1, and there seems no out-of-bounds
problem when performing memcpy() since the size of 'ctx->dma_buffer' is
I2C_SMBUS_BLOCK_MAX + 1. However after this patch, this case would fail,
is this expected?

  xgene_slimpro_i2c_xfer() {
    case I2C_SMBUS_BLOCK_DATA:
      ret = slimpro_i2c_blkwr(ctx, ..., data->block[0] + 1, &data->block[0]);
  }

> 	paddr = dma_map_single(ctx->dev, ctx->dma_buffer, writelen,
> 			       DMA_TO_DEVICE);
> -- 
> 2.25.1

--

Best regards,
Zheng Yejian
