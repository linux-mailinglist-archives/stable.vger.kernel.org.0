Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A7B566D1A
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbiGEMVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237580AbiGEMTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9A41D320;
        Tue,  5 Jul 2022 05:15:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79336619E2;
        Tue,  5 Jul 2022 12:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4B0C341C8;
        Tue,  5 Jul 2022 12:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023321;
        bh=6vtMtvnMKcOp3rLFFzFcjg0nyVIUE85PXXLARnqvPeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCMeA8+fTj7Dl86BKaNvvKWA6cZhpiqtX5OF0x0E3hp1nzbNYQPnXEh0aI+boNQur
         ENgE/ipUnYshHfjug1PGpvuah72L39uuQICTm+R5P0xqWVD+dTcPWfsW4a5fdBmPWB
         ELY55UblcPmQmHkAm2opH0gv+Yq7AcKRsOEc0pFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jinzhou Su <Jinzhou.Su@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.18 019/102] cpufreq: amd-pstate: Add resume and suspend callbacks
Date:   Tue,  5 Jul 2022 13:57:45 +0200
Message-Id: <20220705115618.964128291@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinzhou Su <Jinzhou.Su@amd.com>

commit b376471fb47d4905e72fe73e9eeed228f8f2f230 upstream.

When system resumes from S3, the CPPC enable register will be
cleared and reset to 0.

So enable the CPPC interface by writing 1 to this register on
system resume and disable it during system suspend.

Signed-off-by: Jinzhou Su <Jinzhou.Su@amd.com>
Signed-off-by: Jinzhou Su <Jinzhou.Su@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
[ rjw: Subject and changelog edits ]
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -566,6 +566,28 @@ static int amd_pstate_cpu_exit(struct cp
 	return 0;
 }
 
+static int amd_pstate_cpu_resume(struct cpufreq_policy *policy)
+{
+	int ret;
+
+	ret = amd_pstate_enable(true);
+	if (ret)
+		pr_err("failed to enable amd-pstate during resume, return %d\n", ret);
+
+	return ret;
+}
+
+static int amd_pstate_cpu_suspend(struct cpufreq_policy *policy)
+{
+	int ret;
+
+	ret = amd_pstate_enable(false);
+	if (ret)
+		pr_err("failed to disable amd-pstate during suspend, return %d\n", ret);
+
+	return ret;
+}
+
 /* Sysfs attributes */
 
 /*
@@ -636,6 +658,8 @@ static struct cpufreq_driver amd_pstate_
 	.target		= amd_pstate_target,
 	.init		= amd_pstate_cpu_init,
 	.exit		= amd_pstate_cpu_exit,
+	.suspend	= amd_pstate_cpu_suspend,
+	.resume		= amd_pstate_cpu_resume,
 	.set_boost	= amd_pstate_set_boost,
 	.name		= "amd-pstate",
 	.attr           = amd_pstate_attr,


