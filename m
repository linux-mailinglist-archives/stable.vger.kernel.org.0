Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645D0548CCA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354132AbiFMMQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354965AbiFMMNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:13:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6927A53C62;
        Mon, 13 Jun 2022 04:01:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 885E061435;
        Mon, 13 Jun 2022 11:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9794FC34114;
        Mon, 13 Jun 2022 11:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118080;
        bh=y7GlcwRD3danYGc5bP/xB3Bm0BKDs6VAvErmOMRmARM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b19G+pUTUXGd37/Pd9WmGd7Esbcz++9sZtXlm/+wvubRFTAMvTdwwK9/cnEILEGQw
         6evuS3NULB6FHt0yKLhvzHsoU8gUsQJ/NZTDxKZKoP6BfXphxYRzPbxjTsCGHv2wKh
         EqyCLX8UvZS2+NU71x+AdLZY6MAKsCq+FNTZFj7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 236/287] ata: pata_octeon_cf: Fix refcount leak in octeon_cf_probe
Date:   Mon, 13 Jun 2022 12:11:00 +0200
Message-Id: <20220613094931.172784455@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 10d6bdf532902be1d8aa5900b3c03c5671612aa2 ]

of_find_device_by_node() takes reference, we should use put_device()
to release it when not need anymore.
Add missing put_device() to avoid refcount leak.

Fixes: 43f01da0f279 ("MIPS/OCTEON/ata: Convert pata_octeon_cf.c to use device tree.")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_octeon_cf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index ac3b1fda820f..c240d8cbfd41 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -888,12 +888,14 @@ static int octeon_cf_probe(struct platform_device *pdev)
 				int i;
 				res_dma = platform_get_resource(dma_dev, IORESOURCE_MEM, 0);
 				if (!res_dma) {
+					put_device(&dma_dev->dev);
 					of_node_put(dma_node);
 					return -EINVAL;
 				}
 				cf_port->dma_base = (u64)devm_ioremap_nocache(&pdev->dev, res_dma->start,
 									 resource_size(res_dma));
 				if (!cf_port->dma_base) {
+					put_device(&dma_dev->dev);
 					of_node_put(dma_node);
 					return -EINVAL;
 				}
@@ -903,6 +905,7 @@ static int octeon_cf_probe(struct platform_device *pdev)
 					irq = i;
 					irq_handler = octeon_cf_interrupt;
 				}
+				put_device(&dma_dev->dev);
 			}
 			of_node_put(dma_node);
 		}
-- 
2.35.1



