Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5979B4F38BD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377149AbiDEL1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349620AbiDEJui (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:50:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72734DCF;
        Tue,  5 Apr 2022 02:48:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E789615E3;
        Tue,  5 Apr 2022 09:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E430C385A2;
        Tue,  5 Apr 2022 09:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152117;
        bh=3A6/wr4Ruqir6XPiFN7OjrQqY55f8efY1tUO+dql6NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+HKeB8+DJ4Afqy7UN0ygX/EUcE8h6l58o/aEkFCoGn5R1gmqjdS6ubXVsvwpcBmV
         SnXVlrGXjdEglDXP6z/6bueWIxCqUAb3owCMzFzd7E6xoqXQCU1ohMvoGzfW1mGOZ8
         LWNTmXq0u+fZSHNssWTaQz/EBL282UHVg7/PLFYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 622/913] clk: clps711x: Terminate clk_div_table with sentinel element
Date:   Tue,  5 Apr 2022 09:28:04 +0200
Message-Id: <20220405070358.484596010@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit 8bed4ed5aa3431085d9d27afc35d684856460eda ]

In order that the end of a clk_div_table can be detected, it must be
terminated with a sentinel element (.div = 0).

Fixes: 631c53478973d ("clk: Add CLPS711X clk driver")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Link: https://lore.kernel.org/r/20220218000922.134857-5-j.neuschaefer@gmx.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-clps711x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk-clps711x.c b/drivers/clk/clk-clps711x.c
index a2c6486ef170..f8417ee2961a 100644
--- a/drivers/clk/clk-clps711x.c
+++ b/drivers/clk/clk-clps711x.c
@@ -28,11 +28,13 @@ static const struct clk_div_table spi_div_table[] = {
 	{ .val = 1, .div = 8, },
 	{ .val = 2, .div = 2, },
 	{ .val = 3, .div = 1, },
+	{ /* sentinel */ }
 };
 
 static const struct clk_div_table timer_div_table[] = {
 	{ .val = 0, .div = 256, },
 	{ .val = 1, .div = 1, },
+	{ /* sentinel */ }
 };
 
 struct clps711x_clk {
-- 
2.34.1



