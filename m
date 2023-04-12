Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68FE06DEDF8
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjDLIjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjDLIio (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:38:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061B683CC
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:37:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 651F562FF0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D7BC433D2;
        Wed, 12 Apr 2023 08:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288555;
        bh=Rq08TbII99Z6iYT+clEcAC1SLfJ6CcTvOB6Ok4dvmWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YagwZLdDXavonW8ciSRZRIR1T7VFIH/2qyKN3rfIX+uNeYW/61kmkhGvAj5yS2huH
         QKojm2F8MoxAGHs4TE/pAuyRz3f2x4UQZgNMInPxvMJwyL4hv8kvCP8fR2shPgNxi/
         UTcjUz4nYb01/OGcGjie3lOrE+H3fg39W2OzGgS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/93] soc: sifive: ccache: fix missing of_node_put() in sifive_ccache_init()
Date:   Wed, 12 Apr 2023 10:33:08 +0200
Message-Id: <20230412082823.346117157@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 4b9d0a656a979..09914cb4f0284 100644
--- a/drivers/soc/sifive/sifive_ccache.c
+++ b/drivers/soc/sifive/sifive_ccache.c
@@ -209,12 +209,16 @@ static int __init sifive_ccache_init(void)
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
@@ -237,6 +241,7 @@ static int __init sifive_ccache_init(void)
 			goto err_free_irq;
 		}
 	}
+	of_node_put(np);
 
 	ccache_config_read();
 
@@ -253,6 +258,8 @@ static int __init sifive_ccache_init(void)
 		free_irq(g_irq[i], NULL);
 err_unmap:
 	iounmap(ccache_base);
+err_node_put:
+	of_node_put(np);
 	return rc;
 }
 
-- 
2.39.2



