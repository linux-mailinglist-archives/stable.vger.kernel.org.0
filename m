Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA836501067
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245319AbiDNOIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347722AbiDNN7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50C6BC870;
        Thu, 14 Apr 2022 06:52:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 413DE61D9B;
        Thu, 14 Apr 2022 13:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525D9C385A5;
        Thu, 14 Apr 2022 13:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944329;
        bh=9/0C55r8YNdUzGbc1aYxkVwEdQ/kCd0iEFzHki92Jlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THpUf102egGYWc8KhcK0lx66Z9K57ZA0CJiw3pStRIrTVOxenf1pQLE3P0OvlN/cT
         xfIDW4joz/g3Mz7HKZ7Tqv6NhHkzPIzZ003XlaAD81O8LaXqp9/FBZYQBeaEz86loK
         WuYhUw8vewfxdyK44BZ/MzQdglr3ea6Xom6VT1WU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 474/475] cpuidle: PSCI: Move the `has_lpi` check to the beginning of the function
Date:   Thu, 14 Apr 2022 15:14:19 +0200
Message-Id: <20220414110908.322131387@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -53,6 +53,9 @@ static int psci_acpi_cpu_init_idle(unsig
 	struct acpi_lpi_state *lpi;
 	struct acpi_processor *pr = per_cpu(processors, cpu);
 
+	if (unlikely(!pr || !pr->flags.has_lpi))
+		return -EINVAL;
+
 	/*
 	 * If the PSCI cpu_suspend function hook has not been initialized
 	 * idle states must not be enabled, so bail out
@@ -60,9 +63,6 @@ static int psci_acpi_cpu_init_idle(unsig
 	if (!psci_ops.cpu_suspend)
 		return -EOPNOTSUPP;
 
-	if (unlikely(!pr || !pr->flags.has_lpi))
-		return -EINVAL;
-
 	count = pr->power.count - 1;
 	if (count <= 0)
 		return -ENODEV;


