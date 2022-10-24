Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397BF60AC55
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbiJXOGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237194AbiJXOE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:04:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452D526557;
        Mon, 24 Oct 2022 05:49:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91FF26134F;
        Mon, 24 Oct 2022 12:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F24AC433D6;
        Mon, 24 Oct 2022 12:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615650;
        bh=noZZ1O4AUN/GoUCUlp5faCIkzHdbEB4RYju7DPJu9xA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdJcQwMdAXusKf1DhJ2f0TmoSjP5PF33IrVE3RZmVu22KajRz2FVeMn7uHg8i+uGV
         1PnrmLq+b+eLj6jvxeNp+BqsL0EvF2ins7n1JWavixZ3fTDdCIAmBt8eLzbDdGoe48
         +8dguKdDdJSz4+TAYGYPTRvvwzKsIczI98vOxNAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dang Huynh <danct12@riseup.net>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/530] clk: qcom: sm6115: Select QCOM_GDSC
Date:   Mon, 24 Oct 2022 13:30:45 +0200
Message-Id: <20221024113058.691899778@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dang Huynh <danct12@riseup.net>

[ Upstream commit 50ee65dc512b9b5c4de354cf3b4dded34f46c571 ]

While working on the Fxtec Pro1X device, this error shows up with
my own minimal configuration:

gcc-sm6115: probe of 1400000.clock-controller failed with error -38

The clock driver depends on CONFIG_QCOM_GDSC and after enabling
that, the driver probes successfully.

Signed-off-by: Dang Huynh <danct12@riseup.net>
Fixes: cbe63bfdc54f ("clk: qcom: Add Global Clock controller (GCC)
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220910170207.1592220-1-danct12@riseup.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 9ef007b3cf9b..6ba86cffc413 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -550,6 +550,7 @@ config SM_DISPCC_8250
 
 config SM_GCC_6115
 	tristate "SM6115 and SM4250 Global Clock Controller"
+	select QCOM_GDSC
 	help
 	  Support for the global clock controller on SM6115 and SM4250 devices.
 	  Say Y if you want to use peripheral devices such as UART, SPI,
-- 
2.35.1



