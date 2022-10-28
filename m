Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F582611079
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJ1MF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiJ1MF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:05:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CF2951E4
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83AF0B829B8
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9342C433C1;
        Fri, 28 Oct 2022 12:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958752;
        bh=QuuSza65jqo4t82p5OwJsQaS4BBVh8/TeEiRr7ZKkqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lj7jq7IWecZ6NPWe0FOjDY55Au7m9djB/NGoTH3UGLT6jifu1G43XhArQr7QtMo0O
         yvSkeVH7cKPE0X+XAuD1EktagF2vZOacuepXZeaiR3pmhXA+b0hpcXrvCTg7/es4vm
         jnxRusozPtOs2k8swoqhBSTYFvr66lqHCXV0JWdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabien Parent <fabien.parent@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.10 04/73] cpufreq: qcom: fix writes in read-only memory region
Date:   Fri, 28 Oct 2022 14:03:01 +0200
Message-Id: <20221028120232.567484208@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
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

From: Fabien Parent <fabien.parent@linaro.org>

commit 01039fb8e90c9cb684430414bff70cea9eb168c5 upstream.

This commit fixes a kernel oops because of a write in some read-only memory:

	[    9.068287] Unable to handle kernel write to read-only memory at virtual address ffff800009240ad8
	..snip..
	[    9.138790] Internal error: Oops: 9600004f [#1] PREEMPT SMP
	..snip..
	[    9.269161] Call trace:
	[    9.276271]  __memcpy+0x5c/0x230
	[    9.278531]  snprintf+0x58/0x80
	[    9.282002]  qcom_cpufreq_msm8939_name_version+0xb4/0x190
	[    9.284869]  qcom_cpufreq_probe+0xc8/0x39c
	..snip..

The following line defines a pointer that point to a char buffer stored
in read-only memory:

	char *pvs_name = "speedXX-pvsXX-vXX";

This pointer is meant to hold a template "speedXX-pvsXX-vXX" where the
XX values get overridden by the qcom_cpufreq_krait_name_version function. Since
the template is actually stored in read-only memory, when the function
executes the following call we get an oops:

	snprintf(*pvs_name, sizeof("speedXX-pvsXX-vXX"), "speed%d-pvs%d-v%d",
		 speed, pvs, pvs_ver);

To fix this issue, we instead store the template name onto the stack by
using the following syntax:

	char pvs_name_buffer[] = "speedXX-pvsXX-vXX";

Because the `pvs_name` needs to be able to be assigned to NULL, the
template buffer is stored in the pvs_name_buffer and not under the
pvs_name variable.

Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
Fixes: a8811ec764f9 ("cpufreq: qcom: Add support for krait based socs")
Signed-off-by: Fabien Parent <fabien.parent@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/qcom-cpufreq-nvmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -264,7 +264,8 @@ static int qcom_cpufreq_probe(struct pla
 	struct nvmem_cell *speedbin_nvmem;
 	struct device_node *np;
 	struct device *cpu_dev;
-	char *pvs_name = "speedXX-pvsXX-vXX";
+	char pvs_name_buffer[] = "speedXX-pvsXX-vXX";
+	char *pvs_name = pvs_name_buffer;
 	unsigned cpu;
 	const struct of_device_id *match;
 	int ret;


