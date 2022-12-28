Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A666579B0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbiL1PDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiL1PDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:03:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D4211C18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:03:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1D53B816E9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A4EC433D2;
        Wed, 28 Dec 2022 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239822;
        bh=FE9dy1DW0bEQcMS57LbslmTvcsyOn09tVaedG5uizkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQH/6GZpcEB3Mc1EGL6jPTFFjjZ6nkRIU3NntjTxemXRS2e3kCFUw9rsCjLhVFTnQ
         TLFNUNUbQKXu18DN/gCby7uoyN7ltprmt1FBLdEPmVvLnp7dc/BaxFIjMeWhBimCbl
         pDq1KNbT/OeNsQKeHWsYEugnI9gRTSR0QuXlmjs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0047/1146] soc: sifive: ccache: fix missing of_node_put() in sifive_ccache_init()
Date:   Wed, 28 Dec 2022 15:26:26 +0100
Message-Id: <20221228144331.443328398@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8fbf94fea0b4e187ca9100936c5429f96b8a4e44 ]

The device_node pointer returned by of_find_matching_node() with
refcount incremented, when finish using it, the refcount need be
decreased.

Fixes: a967a289f169 ("RISC-V: sifive_l2_cache: Add L2 cache controller driver for SiFive SoCs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/sifive/sifive_ccache.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/sifive/sifive_ccache.c b/drivers/soc/sifive/sifive_ccache.c
index 98269d056728..3684f5b40a80 100644
--- a/drivers/soc/sifive/sifive_ccache.c
+++ b/drivers/soc/sifive/sifive_ccache.c
@@ -215,12 +215,16 @@ static int __init sifive_ccache_init(void)
 	if (!np)
 		return -ENODEV;
 
-	if (of_address_to_resource(np, 0, &res))
-		return -ENODEV;
+	if (of_address_to_resource(np, 0, &res)) {
+		rc = -ENODEV;
+		goto err_node_put;
+	}
 
 	ccache_base = ioremap(res.start, resource_size(&res));
-	if (!ccache_base)
-		return -ENOMEM;
+	if (!ccache_base) {
+		rc = -ENOMEM;
+		goto err_node_put;
+	}
 
 	if (of_property_read_u32(np, "cache-level", &level)) {
 		rc = -ENOENT;
@@ -243,6 +247,7 @@ static int __init sifive_ccache_init(void)
 			goto err_free_irq;
 		}
 	}
+	of_node_put(np);
 
 	ccache_config_read();
 
@@ -259,6 +264,8 @@ static int __init sifive_ccache_init(void)
 		free_irq(g_irq[i], NULL);
 err_unmap:
 	iounmap(ccache_base);
+err_node_put:
+	of_node_put(np);
 	return rc;
 }
 
-- 
2.35.1



