Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FD94F2D54
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243246AbiDEJjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244623AbiDEJKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:10:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE54C2A733;
        Tue,  5 Apr 2022 01:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78D6AB81C6D;
        Tue,  5 Apr 2022 08:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9918C385A3;
        Tue,  5 Apr 2022 08:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149185;
        bh=33NZsSJJ8AnEe2K5FZo3oYEbB5J35KI4bIowTRDBqLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JreEPhACiWsa5wZJddk5PeFejCGxrkWK9Mkyj8BSaRVgFHhaFOkzX+3a9IGzGRZSJ
         U2ix47cZwdATVbN6SsUZoeJdt7aJZgxawO1N+ybyHgyBwY7tOYAvUHyJhw2N3tk07j
         8ZRPwM0tRnZfqMigIBnem8aRcskTckEHAZN270H4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Tanure <tanure@linux.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0624/1017] i2c: meson: Fix wrong speed use from probe
Date:   Tue,  5 Apr 2022 09:25:37 +0200
Message-Id: <20220405070412.804665775@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Lucas Tanure <tanure@linux.com>

[ Upstream commit cb13aa16f34f794a9cee2626862af8a95f0f0ee9 ]

Having meson_i2c_set_clk_div after i2c_add_adapter
causes issues for client drivers that try to use
the bus before the requested speed is applied.

The bus can be used just after i2c_add_adapter, so
move i2c_add_adapter to the final step as
meson_i2c_set_clk_div needs to be called before
the bus is used.

Fixes: 09af1c2fa490 ("i2c: meson: set clock divider in probe instead of setting it for each transfer")
Signed-off-by: Lucas Tanure <tanure@linux.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-meson.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-meson.c b/drivers/i2c/busses/i2c-meson.c
index ef73a42577cc..07eb819072c4 100644
--- a/drivers/i2c/busses/i2c-meson.c
+++ b/drivers/i2c/busses/i2c-meson.c
@@ -465,18 +465,18 @@ static int meson_i2c_probe(struct platform_device *pdev)
 	 */
 	meson_i2c_set_mask(i2c, REG_CTRL, REG_CTRL_START, 0);
 
-	ret = i2c_add_adapter(&i2c->adap);
-	if (ret < 0) {
-		clk_disable_unprepare(i2c->clk);
-		return ret;
-	}
-
 	/* Disable filtering */
 	meson_i2c_set_mask(i2c, REG_SLAVE_ADDR,
 			   REG_SLV_SDA_FILTER | REG_SLV_SCL_FILTER, 0);
 
 	meson_i2c_set_clk_div(i2c, timings.bus_freq_hz);
 
+	ret = i2c_add_adapter(&i2c->adap);
+	if (ret < 0) {
+		clk_disable_unprepare(i2c->clk);
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.34.1



