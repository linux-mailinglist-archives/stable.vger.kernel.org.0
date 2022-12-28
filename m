Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B323F6578C9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiL1OyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbiL1OyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:54:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FECD94
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:54:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 930C061544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CF7C433EF;
        Wed, 28 Dec 2022 14:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239248;
        bh=izaY5eQ0gyghSemOf/D2C1+We3uv9ADQVnBBGBnCXOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLQToI+sYt2BJ3/Qy6whd+mwZjTZtfsd5k7Uxkj8QRj9J5JrlFBS68iO5PkNmG4gz
         cIAudfkiVy1ekMlHIP9vTlGvLGmJrQVuB14y94sDjIUL2gZFtqT4rrWmg7easV1e7A
         +Fs9G3eA0xyCULJaVPOlpDM4x6bWnepexxSJZ9KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/731] clk: qcom: gcc-sm8250: Use retention mode for USB GDSCs
Date:   Wed, 28 Dec 2022 15:34:52 +0100
Message-Id: <20221228144301.923774109@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit ac1c5a03d3772b1db25e8092f771aa33f6ae2f7e ]

USB controllers on SM8250 doesn't work after coming back from suspend.
This can be fixed by keeping the USB GDSCs in retention mode so that
hardware can keep them ON and put into rentention mode once the parent
domain goes to a low power state.

Fixes: 3e5770921a88 ("clk: qcom: gcc: Add global clock controller driver for SM8250")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221102091320.66007-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8250.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8250.c b/drivers/clk/qcom/gcc-sm8250.c
index 9755ef4888c1..a0ba37656b07 100644
--- a/drivers/clk/qcom/gcc-sm8250.c
+++ b/drivers/clk/qcom/gcc-sm8250.c
@@ -3267,7 +3267,7 @@ static struct gdsc usb30_prim_gdsc = {
 	.pd = {
 		.name = "usb30_prim_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 };
 
 static struct gdsc usb30_sec_gdsc = {
@@ -3275,7 +3275,7 @@ static struct gdsc usb30_sec_gdsc = {
 	.pd = {
 		.name = "usb30_sec_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 };
 
 static struct gdsc hlos1_vote_mmnoc_mmu_tbu_hf0_gdsc = {
-- 
2.35.1



