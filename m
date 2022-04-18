Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD67D50504E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbiDRMXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238743AbiDRMWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:22:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EB41EEC3;
        Mon, 18 Apr 2022 05:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50AEEB80ED6;
        Mon, 18 Apr 2022 12:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94616C385A1;
        Mon, 18 Apr 2022 12:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284288;
        bh=DC7RGW7TlXPwWdtO/BTt0iavJEYKJ2Rg0B/NHcdSQzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+PLHkA+YlUb2G+P1BOSa+1/IqZcEtCZjXvnGFEo21pTgmeolkxGcnVdUpKol9DCo
         fMcZ4uE9YBVVZq+6nEBkD/qhskNfX9ixZB080mflk/PNkrJhHpDeB1vbnIOw4GS9FK
         0TkJuipba90+u3YMzTc+Xz5BNFytEmnsu0jJxjjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dragan Simic <dragan.simic@gmail.com>,
        Kyle Copperfield <kmcopper@danwin1210.me>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 064/219] media: rockchip/rga: do proper error checking in probe
Date:   Mon, 18 Apr 2022 14:10:33 +0200
Message-Id: <20220418121207.390409830@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Kyle Copperfield <kmcopper@danwin1210.me>

[ Upstream commit 6150f276073a1480030242a7e006a89e161d6cd6 ]

The latest fix for probe error handling contained a typo that causes
probing to fail with the following message:

  rockchip-rga: probe of ff680000.rga failed with error -12

This patch fixes the typo.

Fixes: e58430e1d4fd (media: rockchip/rga: fix error handling in probe)
Reviewed-by: Dragan Simic <dragan.simic@gmail.com>
Signed-off-by: Kyle Copperfield <kmcopper@danwin1210.me>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 4de5e8d2b261..3d3d1062e212 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -892,7 +892,7 @@ static int rga_probe(struct platform_device *pdev)
 	}
 	rga->dst_mmu_pages =
 		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
-	if (rga->dst_mmu_pages) {
+	if (!rga->dst_mmu_pages) {
 		ret = -ENOMEM;
 		goto free_src_pages;
 	}
-- 
2.35.1



