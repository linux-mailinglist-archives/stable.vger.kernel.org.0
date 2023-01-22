Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002DF676FD0
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjAVPZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjAVPZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:25:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D752222A01
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71C3C60C44
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86336C433EF;
        Sun, 22 Jan 2023 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401127;
        bh=fY/17CqjTJML3wkItHgrq410wJPwvLNGM3AJN+Cov1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGztNpdo1KVb5NvKBm71lgh61+/b8ccExjz1+9KlC1tR0U314KrNtSYzzbpiQ2OSe
         vd4knM9+dpO7Ef9ls6ynLm/ALs7GTpe3h9lOlT1U+/izXtbqrsGmNrWGFe+s+fZF7F
         7fPvUdWhuzmLXSgzjCiuSAT4X78BYPcYsWb+O5Tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Harliman Liem <pliem@maxlinear.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 120/193] dmaengine: lgm: Move DT parsing after initialization
Date:   Sun, 22 Jan 2023 16:04:09 +0100
Message-Id: <20230122150251.814257430@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Harliman Liem <pliem@maxlinear.com>

commit 96b3bb18f6cbe259ef4e0bed3135911b7e8d2af5 upstream.

ldma_cfg_init() will parse DT to retrieve certain configs.
However, that is called before ldma_dma_init_vXX(), which
will make some initialization to channel configs. It will
thus incorrectly overwrite certain configs that are declared
in DT.

To fix that, we move DT parsing after initialization.
Function name is renamed to better represent what it does.

Fixes: 32d31c79a1a4 ("dmaengine: Add Intel LGM SoC DMA support.")
Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/afef6fc1ed20098b684e0d53737d69faf63c125f.1672887183.git.pliem@maxlinear.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/lgm/lgm-dma.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/dma/lgm/lgm-dma.c
+++ b/drivers/dma/lgm/lgm-dma.c
@@ -914,7 +914,7 @@ static void ldma_dev_init(struct ldma_de
 	}
 }
 
-static int ldma_cfg_init(struct ldma_dev *d)
+static int ldma_parse_dt(struct ldma_dev *d)
 {
 	struct fwnode_handle *fwnode = dev_fwnode(d->dev);
 	struct ldma_port *p;
@@ -1661,10 +1661,6 @@ static int intel_ldma_probe(struct platf
 		p->ldev = d;
 	}
 
-	ret = ldma_cfg_init(d);
-	if (ret)
-		return ret;
-
 	dma_dev->dev = &pdev->dev;
 
 	ch_mask = (unsigned long)d->channels_mask;
@@ -1675,6 +1671,10 @@ static int intel_ldma_probe(struct platf
 			ldma_dma_init_v3X(j, d);
 	}
 
+	ret = ldma_parse_dt(d);
+	if (ret)
+		return ret;
+
 	dma_dev->device_alloc_chan_resources = ldma_alloc_chan_resources;
 	dma_dev->device_free_chan_resources = ldma_free_chan_resources;
 	dma_dev->device_terminate_all = ldma_terminate_all;


