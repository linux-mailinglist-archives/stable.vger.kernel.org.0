Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC0B60FDA6
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbiJ0Q5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236153AbiJ0Q5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:57:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF5417536F
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:57:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DAF90CE2750
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD305C433D6;
        Thu, 27 Oct 2022 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889851;
        bh=jG79j4f3LnQpXfbWBsh1Yi9JAt+1WZGh5W+g58hE9CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m87oziLT60UOiR+lLBq0PiUgEY/ToJggDWREH+sE2h98lk4Jvx5C9QiFIgtD2IpoH
         XDEokPKVKcx/Bm9yoaqnPgeze03rTkvsQvGrDD3I+FzfF7zM2S9DiKSOjQe+9aHFRM
         jrEgtFgqZOoqBa5kB27o9ier+xpnw5ZrfYis/yNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jon Hunter <jonathanh@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.0 08/94] cpufreq: tegra194: Fix module loading
Date:   Thu, 27 Oct 2022 18:54:10 +0200
Message-Id: <20221027165057.481527787@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
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

From: Jon Hunter <jonathanh@nvidia.com>

commit 1dcaf30725c32b26daa70d22083999972ab99c29 upstream.

When the Tegra194 CPUFREQ driver is built as a module it is not
automatically loaded as expected on Tegra194 devices. Populate the
MODULE_DEVICE_TABLE to fix this.

Cc: v5.9+ <stable@vger.kernel.org> # v5.9+
Fixes: df320f89359c ("cpufreq: Add Tegra194 cpufreq driver")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/tegra194-cpufreq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/tegra194-cpufreq.c
+++ b/drivers/cpufreq/tegra194-cpufreq.c
@@ -592,6 +592,7 @@ static const struct of_device_id tegra19
 	{ .compatible = "nvidia,tegra234-ccplex-cluster", .data = &tegra234_cpufreq_soc },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
 
 static struct platform_driver tegra194_ccplex_driver = {
 	.driver = {


