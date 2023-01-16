Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5AF66CA06
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbjAPQ64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbjAPQ6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:58:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3706F193E8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:41:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E269AB81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D0EC433EF;
        Mon, 16 Jan 2023 16:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887263;
        bh=1J/XzWinAdl6Zn5+s82YJhHTvRQBKWSQgukSfem8UXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhmL5jP7/8QJopf4yLe/r8bt1FzJbLd8q//xS3k7K20CnEK33Yi9jd81/bThvrWyV
         Ma6Gcf+IFadxUXtb5h3zXfFuZhfVYZhignckMz2A4ulWVUT0RToFHhfQuIkJxSdgJM
         uhiiLeZe3EtJFhVJsbvLxqdPSpIQJGhQksaQIv48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Junlin Yang <yangjunlin@yulong.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/521] pata_ipx4xx_cf: Fix unsigned comparison with less than zero
Date:   Mon, 16 Jan 2023 16:45:45 +0100
Message-Id: <20230116154850.945954798@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Junlin Yang <yangjunlin@yulong.com>

[ Upstream commit c38ae56ee034623c59e39c0130ca0dec086c1a39 ]

The return from the call to platform_get_irq() is int, it can be
a negative error code, however this is being assigned to an unsigned
int variable 'irq', so making 'irq' an int, and change the position to
keep the code format.

./drivers/ata/pata_ixp4xx_cf.c:168:5-8:
WARNING: Unsigned expression compared with zero: irq > 0

Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
Link: https://lore.kernel.org/r/20210409135426.1773-1-angkery@163.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_ixp4xx_cf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 867621f8c387..8c34c64e4d51 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -139,12 +139,12 @@ static void ixp4xx_setup_port(struct ata_port *ap,
 
 static int ixp4xx_pata_probe(struct platform_device *pdev)
 {
-	unsigned int irq;
 	struct resource *cs0, *cs1;
 	struct ata_host *host;
 	struct ata_port *ap;
 	struct ixp4xx_pata_data *data = dev_get_platdata(&pdev->dev);
 	int ret;
+	int irq;
 
 	cs0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	cs1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-- 
2.35.1



