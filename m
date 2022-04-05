Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9371F4F38AE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354275AbiDEL1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349505AbiDEJt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F201C9;
        Tue,  5 Apr 2022 02:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FFABB81B76;
        Tue,  5 Apr 2022 09:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3A6C385A2;
        Tue,  5 Apr 2022 09:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152076;
        bh=oAyDcBuvjmsJalWEXosrvxoNCoCAuiWwe1NdEN4k2bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkVZdfOvdnBR3Vm4YqGwMNzdpudBFSUioPXPWheIWZs1R8UHosysHsqBtvquZJKHF
         XIE/HO0C+cL5OrhoDxxiwKt4rHSYlUaTmXJsXECW589/XhNgPV4hxS/ya5wq2fKfCC
         ABZQ10OPAXSW5lhDqNJNO265SAzNNCzWP/qBYr24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 619/913] clk: actions: Terminate clk_div_table with sentinel element
Date:   Tue,  5 Apr 2022 09:28:01 +0200
Message-Id: <20220405070358.395006809@linuxfoundation.org>
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



