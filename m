Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDFE4F30D7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236132AbiDEI12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239499AbiDEIUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9270B2A;
        Tue,  5 Apr 2022 01:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65AE760AFB;
        Tue,  5 Apr 2022 08:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705FDC385A0;
        Tue,  5 Apr 2022 08:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146477;
        bh=MyfrGR6SN78HoHqE1W243AQAx11Y7mJpaWheVxSLE9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ae8keG81N9kj3ma+IWlHmhdaItk1Mh3yGe4k/8m8cm/TWXP3+2iXJ2UVp2pswdb/h
         Y6mwfGUDunbosdSAW+LiD6CF1114lfN1xVOoisHD9qMnina0LGm73LBcZr4almzpds
         TOcSDFcmrWzNG/Nnpgg4NiKXnjCUZ8kG0YwoI2K4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0778/1126] clk: visconti: prevent array overflow in visconti_clk_register_gates()
Date:   Tue,  5 Apr 2022 09:25:25 +0200
Message-Id: <20220405070430.413899080@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c5601e0720ce1a3ad895f94a5838530edde01ed3 ]

This code was using -1 to represent that there was no reset function.
Unfortunately, the -1 was stored in u8 so the if (clks[i].rs_id >= 0)
condition was always true.  This lead to an out of bounds access in
visconti_clk_register_gates().

Fixes: b4cbe606dc36 ("clk: visconti: Add support common clock driver and reset driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220316083533.GA30941@kili
Acked-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/visconti/clkc-tmpv770x.c | 2 +-
 drivers/clk/visconti/clkc.c          | 2 +-
 drivers/clk/visconti/clkc.h          | 3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/visconti/clkc-tmpv770x.c b/drivers/clk/visconti/clkc-tmpv770x.c
index c2b2f41a85a4..6c753b2cb558 100644
--- a/drivers/clk/visconti/clkc-tmpv770x.c
+++ b/drivers/clk/visconti/clkc-tmpv770x.c
@@ -176,7 +176,7 @@ static const struct visconti_clk_gate_table clk_gate_tables[] = {
 	{ TMPV770X_CLK_WRCK, "wrck",
 		clks_parent_data, ARRAY_SIZE(clks_parent_data),
 		0, 0x68, 0x168, 9, 32,
-		-1, }, /* No reset */
+		NO_RESET, },
 	{ TMPV770X_CLK_PICKMON, "pickmon",
 		clks_parent_data, ARRAY_SIZE(clks_parent_data),
 		0, 0x10, 0x110, 8, 4,
diff --git a/drivers/clk/visconti/clkc.c b/drivers/clk/visconti/clkc.c
index 56a8a4ffebca..d0b193b5d0b3 100644
--- a/drivers/clk/visconti/clkc.c
+++ b/drivers/clk/visconti/clkc.c
@@ -147,7 +147,7 @@ int visconti_clk_register_gates(struct visconti_clk_provider *ctx,
 		if (!dev_name)
 			return -ENOMEM;
 
-		if (clks[i].rs_id >= 0) {
+		if (clks[i].rs_id != NO_RESET) {
 			rson_offset = reset[clks[i].rs_id].rson_offset;
 			rsoff_offset = reset[clks[i].rs_id].rsoff_offset;
 			rs_idx = reset[clks[i].rs_id].rs_idx;
diff --git a/drivers/clk/visconti/clkc.h b/drivers/clk/visconti/clkc.h
index 09ed82ff64e4..8756a1ec42ef 100644
--- a/drivers/clk/visconti/clkc.h
+++ b/drivers/clk/visconti/clkc.h
@@ -73,4 +73,7 @@ int visconti_clk_register_gates(struct visconti_clk_provider *data,
 				 int num_gate,
 				 const struct visconti_reset_data *reset,
 				 spinlock_t *lock);
+
+#define NO_RESET 0xFF
+
 #endif /* _VISCONTI_CLKC_H_ */
-- 
2.34.1



