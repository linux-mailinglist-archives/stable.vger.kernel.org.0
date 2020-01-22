Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEA314504C
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgAVJp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:45:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387932AbgAVJo4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:44:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 507122467B;
        Wed, 22 Jan 2020 09:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686295;
        bh=4mPE/gzMo7xTmp0JuJIxY5d1q1UzA0qYxFBlXRGY944=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6EBXgl4qjZ0Y8EbH7k70+IgL26hTtmVqTqWvrj995voGor6HtmkeZ56EG4xnyD28
         ypztZUk1w5ICTYaGS787Z/Iwp9VJwemm7dpt1/euUUdtLTdv04MOIrKniV6xdoK2hA
         wMqHlPjMfdS2nUx6Da/c+AcMN+fJKHdKrumVJPvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.4 002/222] clk: qcom: gcc-sdm845: Add missing flag to votable GDSCs
Date:   Wed, 22 Jan 2020 10:26:28 +0100
Message-Id: <20200122092833.515642549@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Georgi Djakov <georgi.djakov@linaro.org>

commit 5e82548e26ef62e257dc2ff37c11acb5eb72728e upstream.

On sdm845 devices, during boot we see the following warnings (unless we
have added 'pd_ignore_unused' to the kernel command line):
	hlos1_vote_mmnoc_mmu_tbu_sf_gdsc status stuck at 'on'
	hlos1_vote_mmnoc_mmu_tbu_hf1_gdsc status stuck at 'on'
	hlos1_vote_mmnoc_mmu_tbu_hf0_gdsc status stuck at 'on'
	hlos1_vote_aggre_noc_mmu_tbu2_gdsc status stuck at 'on'
	hlos1_vote_aggre_noc_mmu_tbu1_gdsc status stuck at 'on'
	hlos1_vote_aggre_noc_mmu_pcie_tbu_gdsc status stuck at 'on'
	hlos1_vote_aggre_noc_mmu_audio_tbu_gdsc status stuck at 'on'

As the name of these GDSCs suggests, they are "votable" and in downstream
DT, they all have the property "qcom,no-status-check-on-disable", which
means that we should not poll the status bit when we disable them.

Luckily the VOTABLE flag already exists and it does exactly what we need,
so let's make use of it to make the warnings disappear.

Fixes: 06391eddb60a ("clk: qcom: Add Global Clock controller (GCC) driver for SDM845")
Reported-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Link: https://lkml.kernel.org/r/20191126153437.11808-1-georgi.djakov@linaro.org
Tested-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/qcom/gcc-sdm845.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/clk/qcom/gcc-sdm845.c
+++ b/drivers/clk/qcom/gcc-sdm845.c
@@ -3255,6 +3255,7 @@ static struct gdsc hlos1_vote_aggre_noc_
 		.name = "hlos1_vote_aggre_noc_mmu_audio_tbu_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct gdsc hlos1_vote_aggre_noc_mmu_pcie_tbu_gdsc = {
@@ -3263,6 +3264,7 @@ static struct gdsc hlos1_vote_aggre_noc_
 		.name = "hlos1_vote_aggre_noc_mmu_pcie_tbu_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct gdsc hlos1_vote_aggre_noc_mmu_tbu1_gdsc = {
@@ -3271,6 +3273,7 @@ static struct gdsc hlos1_vote_aggre_noc_
 		.name = "hlos1_vote_aggre_noc_mmu_tbu1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct gdsc hlos1_vote_aggre_noc_mmu_tbu2_gdsc = {
@@ -3279,6 +3282,7 @@ static struct gdsc hlos1_vote_aggre_noc_
 		.name = "hlos1_vote_aggre_noc_mmu_tbu2_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct gdsc hlos1_vote_mmnoc_mmu_tbu_hf0_gdsc = {
@@ -3287,6 +3291,7 @@ static struct gdsc hlos1_vote_mmnoc_mmu_
 		.name = "hlos1_vote_mmnoc_mmu_tbu_hf0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct gdsc hlos1_vote_mmnoc_mmu_tbu_hf1_gdsc = {
@@ -3295,6 +3300,7 @@ static struct gdsc hlos1_vote_mmnoc_mmu_
 		.name = "hlos1_vote_mmnoc_mmu_tbu_hf1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct gdsc hlos1_vote_mmnoc_mmu_tbu_sf_gdsc = {
@@ -3303,6 +3309,7 @@ static struct gdsc hlos1_vote_mmnoc_mmu_
 		.name = "hlos1_vote_mmnoc_mmu_tbu_sf_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct clk_regmap *gcc_sdm845_clocks[] = {


