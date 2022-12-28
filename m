Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A197657F76
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbiL1QFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbiL1QFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:05:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396771903B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:05:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9EBB6155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE7CC433D2;
        Wed, 28 Dec 2022 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243504;
        bh=CrhYTI12EfCuNJIiCDZ0o4WMBOwdSivhCuvyUCKXg8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xh9x6FlXBzaNsqsj1W0BUBPUe/vtRDrP+XPpSz8FpLqh4kNCaUZHblAXbNc6POJ0m
         SGn04Mf0LZ9mdaXb/Wot+V54kD3iQAx6aLnNj8Caw2qTFPBVnAwRV8UY34kJLHdwK5
         4ZTQzMmIyg+afJshFZkz1104uxVJI9Top1HM9voo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 728/731] net: stmmac: fix errno when create_singlethread_workqueue() fails
Date:   Wed, 28 Dec 2022 15:43:55 +0100
Message-Id: <20221228144317.543382738@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit 2cb815cfc78b137ee38bcd65e7c955d6cc2cc250 upstream.

We should set the return value to -ENOMEM explicitly when
create_singlethread_workqueue() fails in stmmac_dvr_probe(),
otherwise we'll lose the error value.

Fixes: a137f3f27f92 ("net: stmmac: fix possible memory leak in stmmac_dvr_probe()")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221214080117.3514615-1-cuigaosheng1@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7046,6 +7046,7 @@ int stmmac_dvr_probe(struct device *devi
 	priv->wq = create_singlethread_workqueue("stmmac_wq");
 	if (!priv->wq) {
 		dev_err(priv->device, "failed to create workqueue\n");
+		ret = -ENOMEM;
 		goto error_wq_init;
 	}
 


