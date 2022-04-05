Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D454F2AF9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350456AbiDEJ6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344001AbiDEJQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3DDDF61;
        Tue,  5 Apr 2022 02:02:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0B43B80DA1;
        Tue,  5 Apr 2022 09:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65137C385A1;
        Tue,  5 Apr 2022 09:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149346;
        bh=oAyDcBuvjmsJalWEXosrvxoNCoCAuiWwe1NdEN4k2bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzxDeXAD7/y1HF+zIImc3SayceNoUJwCuld6xHkllXH96w7jRtkg4xHWB4RUQhdBG
         BxQssGr3zL3LDm0Qd79y46LXOhlO1GzAzB8c5aG9qHXkGR05dYCMwgtB0mDBQ94a27
         ahYGVrJL/45kGnWfVwClWBGUB3y81mCwUgdj28Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0684/1017] clk: actions: Terminate clk_div_table with sentinel element
Date:   Tue,  5 Apr 2022 09:26:37 +0200
Message-Id: <20220405070414.580442518@linuxfoundation.org>
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

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit d8a441e53e2434b1401e52dfd66b05263e442edc ]

In order that the end of a clk_div_table can be detected, it must be
terminated with a sentinel element (.div = 0).

In owl-s900.s, the { 0, 8 } element was probably meant to be just that,
so this patch changes { 0, 8 } to { 0, 0 }.

Fixes: d47317ca4ade1 ("clk: actions: Add S700 SoC clock support")
Fixes: d85d20053e195 ("clk: actions: Add S900 SoC clock support")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20220218000922.134857-2-j.neuschaefer@gmx.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/actions/owl-s700.c | 1 +
 drivers/clk/actions/owl-s900.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/actions/owl-s700.c b/drivers/clk/actions/owl-s700.c
index a2f34d13fb54..6ea7da1d6d75 100644
--- a/drivers/clk/actions/owl-s700.c
+++ b/drivers/clk/actions/owl-s700.c
@@ -162,6 +162,7 @@ static struct clk_div_table hdmia_div_table[] = {
 
 static struct clk_div_table rmii_div_table[] = {
 	{0, 4},   {1, 10},
+	{0, 0}
 };
 
 /* divider clocks */
diff --git a/drivers/clk/actions/owl-s900.c b/drivers/clk/actions/owl-s900.c
index 790890978424..5144ada2c7e1 100644
--- a/drivers/clk/actions/owl-s900.c
+++ b/drivers/clk/actions/owl-s900.c
@@ -140,7 +140,7 @@ static struct clk_div_table rmii_ref_div_table[] = {
 
 static struct clk_div_table usb3_mac_div_table[] = {
 	{ 1, 2 }, { 2, 3 }, { 3, 4 },
-	{ 0, 8 },
+	{ 0, 0 }
 };
 
 static struct clk_div_table i2s_div_table[] = {
-- 
2.34.1



