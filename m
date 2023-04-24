Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3E96ECD56
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjDXNWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbjDXNWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:22:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8139E55A7
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:22:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 629AD6221E
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78413C433EF;
        Mon, 24 Apr 2023 13:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342528;
        bh=95SiklVmTmkib2sdosXKqpaoQ18razzQO7Owv2fLv/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7hK7HYdylzOGOuC8F8/xpm0anO04n4hAlBvsyI8wqPAFhVXowNYh4VK4Krkk9SS3
         8ev5eKE9AC3hRPxk04xzEKzdmtp3HNL3aUjJ5tTu2HspMX3Ua2gClRrh7wZWAviBXW
         uXxR8GsBfx4XjywB6SW7Jw9a6UJAcp57Mgb1m8/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 5.15 73/73] soc: sifive: l2_cache: fix missing of_node_put() in sifive_l2_init()
Date:   Mon, 24 Apr 2023 15:17:27 +0200
Message-Id: <20230424131131.797887392@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 8fbf94fea0b4e187ca9100936c5429f96b8a4e44 upstream.

The device_node pointer returned by of_find_matching_node() with
refcount incremented, when finish using it, the refcount need be
decreased.

Fixes: a967a289f169 ("RISC-V: sifive_l2_cache: Add L2 cache controller driver for SiFive SoCs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
[conor: cache -> l2_cache]
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/sifive/sifive_l2_cache.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/soc/sifive/sifive_l2_cache.c
+++ b/drivers/soc/sifive/sifive_l2_cache.c
@@ -202,12 +202,16 @@ static int __init sifive_l2_init(void)
 	if (!np)
 		return -ENODEV;
 
-	if (of_address_to_resource(np, 0, &res))
-		return -ENODEV;
+	if (of_address_to_resource(np, 0, &res)) {
+		rc = -ENODEV;
+		goto err_node_put;
+	}
 
 	l2_base = ioremap(res.start, resource_size(&res));
-	if (!l2_base)
-		return -ENOMEM;
+	if (!l2_base) {
+		rc = -ENOMEM;
+		goto err_node_put;
+	}
 
 	intr_num = of_property_count_u32_elems(np, "interrupts");
 	if (!intr_num) {
@@ -224,6 +228,7 @@ static int __init sifive_l2_init(void)
 			goto err_free_irq;
 		}
 	}
+	of_node_put(np);
 
 	l2_config_read();
 
@@ -240,6 +245,8 @@ err_free_irq:
 		free_irq(g_irq[i], NULL);
 err_unmap:
 	iounmap(l2_base);
+err_node_put:
+	of_node_put(np);
 	return rc;
 }
 device_initcall(sifive_l2_init);


