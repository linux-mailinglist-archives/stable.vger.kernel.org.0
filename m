Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4987B67CC3A
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 14:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbjAZNch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 08:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236930AbjAZNcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 08:32:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117E16E84;
        Thu, 26 Jan 2023 05:32:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D34C617EE;
        Thu, 26 Jan 2023 13:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AFCC4339C;
        Thu, 26 Jan 2023 13:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674739953;
        bh=enToiuVABhYJILMxyVw7rFjKmf1TrVq1GFiY2ZMkd6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYu3+Y4XIEErQXOh0EUi/03Fp6rirwhyn9NmKELQh+bLBssgwwSE9Mc1QIbkwkY94
         NPVkMG121PccSZIbd7IHlMYY+n2nMabgI+uBdDf2Pn/PAUm5uskxta9IVtm6SdL75Z
         Pp2ZNeHMUD2KD8NRrirQdL7EmMv4Gte9twXH7XcExO65K7pU52OwuMQWMBQz8JfejI
         4Dt9CpulCHuhRbRBh4GJXZKhG+ZpOyyp7DVfeOB4WQnDUU6okiVhuyP/4yn0zwDYCG
         t9FGWd08Q7l87n+FlATApKVJFyEa7esoE3Whb0n+agSsuA6+4JQc0ZlCL6joJTs0E7
         7lLKyMcXL4SHw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pL2Mq-0007Ak-GU; Thu, 26 Jan 2023 14:32:40 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] nvmem: qcom-spmi-sdam: fix module autoloading
Date:   Thu, 26 Jan 2023 14:30:33 +0100
Message-Id: <20230126133034.27491-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126133034.27491-1-johan+linaro@kernel.org>
References: <20230126133034.27491-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add the missing module device table so that the driver can be autoloaded
when built as a module.

Fixes: 40ce9798794f ("nvmem: add QTI SDAM driver")
Cc: stable@vger.kernel.org	# 5.6
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/nvmem/qcom-spmi-sdam.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/qcom-spmi-sdam.c b/drivers/nvmem/qcom-spmi-sdam.c
index 4fcb63507ecd..8499892044b7 100644
--- a/drivers/nvmem/qcom-spmi-sdam.c
+++ b/drivers/nvmem/qcom-spmi-sdam.c
@@ -166,6 +166,7 @@ static const struct of_device_id sdam_match_table[] = {
 	{ .compatible = "qcom,spmi-sdam" },
 	{},
 };
+MODULE_DEVICE_TABLE(of, sdam_match_table);
 
 static struct platform_driver sdam_driver = {
 	.driver = {
-- 
2.39.1

