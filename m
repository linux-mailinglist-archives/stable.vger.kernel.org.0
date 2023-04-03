Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7856D4A46
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbjDCOps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbjDCOps (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:45:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF159280DB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:45:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E07061EFC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2AFC433D2;
        Mon,  3 Apr 2023 14:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533119;
        bh=11A643II97k5BJwesN/mhwYq8mIX6gHm7xWFgzm2iaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WS4MX1Gxa5AfSA/wsL65itR6bkErxGzsS8qHmkfUQ8DBVXKGYhhv36NIVBmAZKO3r
         7rB9QP4MprKIs2zYY3YH0LUTt/yckZH08VpO3z3eJxHWwNMmxtytdAsgArBZ34vou3
         9BlW6Xqcm4MQnl8BZJfO2SGV1cWRHpTTziBbzXaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 062/187] mtd: rawnand: meson: initialize struct with zeroes
Date:   Mon,  3 Apr 2023 16:08:27 +0200
Message-Id: <20230403140417.996989389@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arseniy Krasnov <AVKrasnov@sberdevices.ru>

[ Upstream commit 4ce341de6c02d02aba7c78a6447ccfcaa9eeb328 ]

This structure must be zeroed, because it's field 'hw->core' is used as
'parent' in 'clk_core_fill_parent_index()', but it will be uninitialized.
This happens, because when this struct is not zeroed, pointer 'hw' is
"initialized" by garbage, which is valid pointer, but points to some
garbage. So 'hw' will be dereferenced, but 'core' contains some random
data which will be interpreted as a pointer. The following backtrace is
result of dereference of such pointer:

[    1.081319]  __clk_register+0x414/0x820
[    1.085113]  devm_clk_register+0x64/0xd0
[    1.088995]  meson_nfc_probe+0x258/0x6ec
[    1.092875]  platform_probe+0x70/0xf0
[    1.096498]  really_probe+0xc8/0x3e0
[    1.100034]  __driver_probe_device+0x84/0x190
[    1.104346]  driver_probe_device+0x44/0x120
[    1.108487]  __driver_attach+0xb4/0x220
[    1.112282]  bus_for_each_dev+0x78/0xd0
[    1.116077]  driver_attach+0x2c/0x40
[    1.119613]  bus_add_driver+0x184/0x240
[    1.123408]  driver_register+0x80/0x140
[    1.127203]  __platform_driver_register+0x30/0x40
[    1.131860]  meson_nfc_driver_init+0x24/0x30

Fixes: 1e4d3ba66888 ("mtd: rawnand: meson: fix the clock")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230227102425.793841-1-AVKrasnov@sberdevices.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/meson_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index 5ee01231ac4cd..30e326adabfc1 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -991,7 +991,7 @@ static const struct mtd_ooblayout_ops meson_ooblayout_ops = {
 
 static int meson_nfc_clk_init(struct meson_nfc *nfc)
 {
-	struct clk_parent_data nfc_divider_parent_data[1];
+	struct clk_parent_data nfc_divider_parent_data[1] = {0};
 	struct clk_init_data init = {0};
 	int ret;
 
-- 
2.39.2



