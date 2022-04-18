Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE3B50534D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240379AbiDRM4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240377AbiDRMzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB392BCA;
        Mon, 18 Apr 2022 05:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4794AB80EDC;
        Mon, 18 Apr 2022 12:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA05CC385A1;
        Mon, 18 Apr 2022 12:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285449;
        bh=cjgxeclnMlt0Wf4GDnGqD7fbo9ohrM+9rOQvJXfpy14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFeSgsz7ZCmRbBMqJk2WFDyF3nCVXqmv7yrpWwK9ebDBLL3P71flimB/EM7Vt9Rod
         YFc1YI4YvBkVUxG2BmSUncEjh0Bf8ntxfOtLnJe9SfMJV8WxCb7dnZ1eDq07Qa1NvJ
         mZjyjELcbXD145LuRB+XUW4G3v81W+q9sFQpQug4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 004/105] cpuidle: PSCI: Move the `has_lpi` check to the beginning of the function
Date:   Mon, 18 Apr 2022 14:12:06 +0200
Message-Id: <20220418121145.434691010@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 01f6c7338ce267959975da65d86ba34f44d54220 upstream.

Currently the first thing checked is whether the PCSI cpu_suspend function
has been initialized.

Another change will be overloading `acpi_processor_ffh_lpi_probe` and
calling it sooner.  So make the `has_lpi` check the first thing checked
to prepare for that change.

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpuidle.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/cpuidle.c
+++ b/arch/arm64/kernel/cpuidle.c
@@ -54,6 +54,9 @@ static int psci_acpi_cpu_init_idle(unsig
 	struct acpi_lpi_state *lpi;
 	struct acpi_processor *pr = per_cpu(processors, cpu);
 
+	if (unlikely(!pr || !pr->flags.has_lpi))
+		return -EINVAL;
+
 	/*
 	 * If the PSCI cpu_suspend function hook has not been initialized
 	 * idle states must not be enabled, so bail out
@@ -61,9 +64,6 @@ static int psci_acpi_cpu_init_idle(unsig
 	if (!psci_ops.cpu_suspend)
 		return -EOPNOTSUPP;
 
-	if (unlikely(!pr || !pr->flags.has_lpi))
-		return -EINVAL;
-
 	count = pr->power.count - 1;
 	if (count <= 0)
 		return -ENODEV;


