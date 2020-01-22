Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30683144FBD
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733173AbgAVJkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:40:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387467AbgAVJkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:40:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78F0924680;
        Wed, 22 Jan 2020 09:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686038;
        bh=2FiJmJV1CwjvnJ0/pRolslGpEn1q5t5nYmX/eEeBovE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aff7nWQWYNHgRMrNAylpzTWO8nGECwQxnQ+6NdAavnZ+1PgzYjkiBXXtm4z8pvdFv
         OPm5njQmA+rG4PQFANGIK1tegi6CGPRFTDyw5x+5ehHPA917St5lW7Ud5589nlU6xf
         4600+YE6yYgsEQHNWtwGPsgkkHM9Aa+mQpCc1TbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.19 002/103] clk: qcom: gcc-sdm845: Add missing flag to votable GDSCs
Date:   Wed, 22 Jan 2020 10:28:18 +0100
Message-Id: <20200122092803.972037395@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
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
@@ -3150,6 +3150,7 @@ static struct gdsc hlos1_vote_aggre_noc_
 		.name = "hlos1_vote_aggre_noc_mmu_audio_tbu_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct gdsc hlos1_vote_aggre_noc_mmu_pcie_tbu_gdsc = {
@@ -3158,6 +3159,7 @@ static struct gdsc hlos1_vote_aggre_noc_
 		.name = "hlos1_vote_aggre_noc_mmu_pcie_tbu_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct gdsc hlos1_vote_aggre_noc_mmu_tbu1_gdsc = {
@@ -3166,6 +3168,7 @@ static struct gdsc hlos1_vote_aggre_noc_
 		.name = "hlos1_vote_aggre_noc_mmu_tbu1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct gdsc hlos1_vote_aggre_noc_mmu_tbu2_gdsc = {
@@ -3174,6 +3177,7 @@ static struct gdsc hlos1_vote_aggre_noc_
 		.name = "hlos1_vote_aggre_noc_mmu_tbu2_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct gdsc hlos1_vote_mmnoc_mmu_tbu_hf0_gdsc = {
@@ -3182,6 +3186,7 @@ static struct gdsc hlos1_vote_mmnoc_mmu_
 		.name = "hlos1_vote_mmnoc_mmu_tbu_hf0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct gdsc hlos1_vote_mmnoc_mmu_tbu_hf1_gdsc = {
@@ -3190,6 +3195,7 @@ static struct gdsc hlos1_vote_mmnoc_mmu_
 		.name = "hlos1_vote_mmnoc_mmu_tbu_hf1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct gdsc hlos1_vote_mmnoc_mmu_tbu_sf_gdsc = {
@@ -3198,6 +3204,7 @@ static struct gdsc hlos1_vote_mmnoc_mmu_
 		.name = "hlos1_vote_mmnoc_mmu_tbu_sf_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
 };
 
 static struct clk_regmap *gcc_sdm845_clocks[] = {


