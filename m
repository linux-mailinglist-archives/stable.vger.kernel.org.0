Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A23603EC2
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbiJSJUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbiJSJTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:19:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E76DCEAA;
        Wed, 19 Oct 2022 02:08:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2272561800;
        Wed, 19 Oct 2022 09:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373B9C433D7;
        Wed, 19 Oct 2022 09:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170080;
        bh=CSMZGEx1Zb4R7a0Kvi9BC+oRFdzrgkIBNh8I2cuuVlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGEKI7FKXcOFoniwMz3Xczn469v6uUwaZXk9D2hOcJGZLOcr+v9g7O/UHSQi8YNU8
         PbQuHud+kTf44y9N+EoOIxQHNkEcdgxAEw0jac8JCusXfHIZU9BdNib0PncfmhMPek
         OIxnXi49w79JEXISPkOeGnsYMCc7C+2sizd6tyss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dang Huynh <danct12@riseup.net>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 518/862] clk: qcom: sm6115: Select QCOM_GDSC
Date:   Wed, 19 Oct 2022 10:30:05 +0200
Message-Id: <20221019083312.883157055@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 1cf1ef70e347..d566fbdebdf9 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -645,6 +645,7 @@ config SM_DISPCC_6350
 
 config SM_GCC_6115
 	tristate "SM6115 and SM4250 Global Clock Controller"
+	select QCOM_GDSC
 	help
 	  Support for the global clock controller on SM6115 and SM4250 devices.
 	  Say Y if you want to use peripheral devices such as UART, SPI,
-- 
2.35.1



