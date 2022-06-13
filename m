Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD13B5491CA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355692AbiFMM4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358004AbiFMMyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:54:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7B735859;
        Mon, 13 Jun 2022 04:13:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F373B80E93;
        Mon, 13 Jun 2022 11:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32E2C3411C;
        Mon, 13 Jun 2022 11:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118832;
        bh=/lWHFpte0nQhGTo7XI8GUdlZRuC2Mn0hannG7wMM4LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYUk5qYzjtoPek5DLwfLFNqfkTBuBBjjJwm6RDmylSCS9ysbeISUQIQ+hkwNhurBW
         Gm4xto+hVfo0RORZv9sNkBT4QMz7LpHYqr0EkbzTW64FhoWRe1gWsrMVZvJjRF11iH
         gWbqClMcjehNiuuOUfYcUVBscB6n97ND/KCM69e4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/247] soc: rockchip: Fix refcount leak in rockchip_grf_init
Date:   Mon, 13 Jun 2022 12:09:05 +0200
Message-Id: <20220613094924.254243303@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

[ Upstream commit 9b59588d8be91c96bfb0371e912ceb4f16315dbf ]

of_find_matching_node_and_match returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 4c58063d4258 ("soc: rockchip: add driver handling grf setup")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220516072013.19731-1-linmq006@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/grf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/rockchip/grf.c b/drivers/soc/rockchip/grf.c
index 494cf2b5bf7b..343ff61ccccb 100644
--- a/drivers/soc/rockchip/grf.c
+++ b/drivers/soc/rockchip/grf.c
@@ -148,12 +148,14 @@ static int __init rockchip_grf_init(void)
 		return -ENODEV;
 	if (!match || !match->data) {
 		pr_err("%s: missing grf data\n", __func__);
+		of_node_put(np);
 		return -EINVAL;
 	}
 
 	grf_info = match->data;
 
 	grf = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(grf)) {
 		pr_err("%s: could not get grf syscon\n", __func__);
 		return PTR_ERR(grf);
-- 
2.35.1



