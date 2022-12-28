Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4877E657B19
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiL1PSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbiL1PSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:18:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E2213F77
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:18:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5ED361555
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3086C433EF;
        Wed, 28 Dec 2022 15:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240684;
        bh=0W5PciXOOC4YYnnlUwPHAcov1CTEah3PwDTi+Nvw6/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vg76RTdi/9LF0nhz8NSSBkRhQrRyBF2zv6wMm4zuRIelcW59lZ9QKxTV/E7TpXzmu
         3Ho1E3uz4MdIIAmAknx7ygGbccrDiFK+iZC3MeaF3oLulzT3HbMjbJQNI3okBTohAQ
         Xjo5C+Ue5qG+drZPj/ZKyJKlcHc1vtVy8tqxsOEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0155/1146] cpufreq: amd_freq_sensitivity: Add missing pci_dev_put()
Date:   Wed, 28 Dec 2022 15:28:14 +0100
Message-Id: <20221228144334.368667327@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 91fda1f88c0968f1491ab150bb01690525af150a ]

pci_get_device() will increase the reference count for the returned
pci_dev. We need to use pci_dev_put() to decrease the reference count
after using pci_get_device(). Let's add it.

Fixes: 59a3b3a8db16 ("cpufreq: AMD: Ignore the check for ProcFeedback in ST/CZ")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd_freq_sensitivity.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/amd_freq_sensitivity.c b/drivers/cpufreq/amd_freq_sensitivity.c
index 6448e03bcf48..59b19b9975e8 100644
--- a/drivers/cpufreq/amd_freq_sensitivity.c
+++ b/drivers/cpufreq/amd_freq_sensitivity.c
@@ -125,6 +125,8 @@ static int __init amd_freq_sensitivity_init(void)
 	if (!pcidev) {
 		if (!boot_cpu_has(X86_FEATURE_PROC_FEEDBACK))
 			return -ENODEV;
+	} else {
+		pci_dev_put(pcidev);
 	}
 
 	if (rdmsrl_safe(MSR_AMD64_FREQ_SENSITIVITY_ACTUAL, &val))
-- 
2.35.1



