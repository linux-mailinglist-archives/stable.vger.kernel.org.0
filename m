Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF44316761B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731664AbgBUIIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:08:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732202AbgBUIIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:08:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A1A420722;
        Fri, 21 Feb 2020 08:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272511;
        bh=L39ewZIAQLtVWClce3+6QIzm4nk1mjYhAteFKAvrzdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hV2HmgfMLPhNqtpwCiIXsA1FzunjOQL2ETbuFYs0lKuc11fvc+Ab85Jq6Yktv1ISm
         CQMIfyMylgs1Dx2GpLKBDGh/wkVjNKYhI6cv5OFRK72DPFFCgyI3sTigavXd8RI0vJ
         yRO+k0hwhRXRLvJRhKSX/CuoyQXV7iWMHHvrhNOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/344] clk: qcom: smd: Add missing bimc clock
Date:   Fri, 21 Feb 2020 08:39:02 +0100
Message-Id: <20200221072401.799866342@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

[ Upstream commit 87ec9adcca71801a44ddb311185b17df09839ab5 ]

It turns out booting the modem is dependent on a bimc vote from Linux on
msm8998.  To make the modem happy, add the bimc clock to rely on the
default vote from rpmcc.  Once we have interconnect support, bimc should
be controlled properly.

Fixes: 6131dc81211c ("clk: qcom: smd: Add support for MSM8998 rpm clocks")
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Link: https://lkml.kernel.org/r/20191217165409.4919-1-jeffrey.l.hugo@gmail.com
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-smd-rpm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/qcom/clk-smd-rpm.c b/drivers/clk/qcom/clk-smd-rpm.c
index 930fa4a4c52a8..e5c3db11bf26c 100644
--- a/drivers/clk/qcom/clk-smd-rpm.c
+++ b/drivers/clk/qcom/clk-smd-rpm.c
@@ -648,6 +648,7 @@ static const struct rpm_smd_clk_desc rpm_clk_qcs404 = {
 };
 
 /* msm8998 */
+DEFINE_CLK_SMD_RPM(msm8998, bimc_clk, bimc_a_clk, QCOM_SMD_RPM_MEM_CLK, 0);
 DEFINE_CLK_SMD_RPM(msm8998, pcnoc_clk, pcnoc_a_clk, QCOM_SMD_RPM_BUS_CLK, 0);
 DEFINE_CLK_SMD_RPM(msm8998, snoc_clk, snoc_a_clk, QCOM_SMD_RPM_BUS_CLK, 1);
 DEFINE_CLK_SMD_RPM(msm8998, cnoc_clk, cnoc_a_clk, QCOM_SMD_RPM_BUS_CLK, 2);
@@ -671,6 +672,8 @@ DEFINE_CLK_SMD_RPM_XO_BUFFER_PINCTRL(msm8998, rf_clk2_pin, rf_clk2_a_pin, 5);
 DEFINE_CLK_SMD_RPM_XO_BUFFER(msm8998, rf_clk3, rf_clk3_a, 6);
 DEFINE_CLK_SMD_RPM_XO_BUFFER_PINCTRL(msm8998, rf_clk3_pin, rf_clk3_a_pin, 6);
 static struct clk_smd_rpm *msm8998_clks[] = {
+	[RPM_SMD_BIMC_CLK] = &msm8998_bimc_clk,
+	[RPM_SMD_BIMC_A_CLK] = &msm8998_bimc_a_clk,
 	[RPM_SMD_PCNOC_CLK] = &msm8998_pcnoc_clk,
 	[RPM_SMD_PCNOC_A_CLK] = &msm8998_pcnoc_a_clk,
 	[RPM_SMD_SNOC_CLK] = &msm8998_snoc_clk,
-- 
2.20.1



