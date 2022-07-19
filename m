Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9805579F28
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243249AbiGSNLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243256AbiGSNKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:10:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589CB66AE6;
        Tue, 19 Jul 2022 05:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D45AEB81B29;
        Tue, 19 Jul 2022 12:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A65C341CF;
        Tue, 19 Jul 2022 12:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233737;
        bh=R9Q4XuOpLZEJ+9h3KSB3O61IiWX3lDtzEd0A+CAwXhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ctSLlvWQKp1tLb+KRhPV5FwUJzPlhuc6ot1Z7ijPztW54DEcrqfOczcbbZj4BmEP
         u7dmxBhysMza5YzC09/79wHNdKV1PzRX8Hxy45uPoNGJnRvIqRoIX3mx8gTC23F4kz
         pV6l836CQBgDVfZ7kp5sNYffRbBhQ4SIWgIf+FUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: [PATCH 5.18 224/231] ACPI: CPPC: Fix enabling CPPC on AMD systems with shared memory
Date:   Tue, 19 Jul 2022 13:55:09 +0200
Message-Id: <20220719114732.537637737@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit fbd74d16890b9f5d08ea69b5282b123c894f8860 upstream.

When commit 72f2ecb7ece7 ("ACPI: bus: Set CPPC _OSC bits for all
and when CPPC_LIB is supported") was introduced, we found collateral
damage that a number of AMD systems that supported CPPC but
didn't advertise support in _OSC stopped having a functional
amd-pstate driver. The _OSC was only enforced on Intel systems at that
time.

This was fixed for the MSR based designs by commit 8b356e536e69f
("ACPI: CPPC: Don't require _OSC if X86_FEATURE_CPPC is supported")
but some shared memory based designs also support CPPC but haven't
advertised support in the _OSC.  Add support for those designs as well by
hardcoding the list of systems.

Fixes: 72f2ecb7ece7 ("ACPI: bus: Set CPPC _OSC bits for all and when CPPC_LIB is supported")
Fixes: 8b356e536e69f ("ACPI: CPPC: Don't require _OSC if X86_FEATURE_CPPC is supported")
Link: https://lore.kernel.org/all/3559249.JlDtxWtqDm@natalenko.name/
Cc: 5.18+ <stable@vger.kernel.org> # 5.18+
Reported-and-tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/acpi/cppc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kernel/acpi/cppc.c
+++ b/arch/x86/kernel/acpi/cppc.c
@@ -16,6 +16,12 @@ bool cpc_supported_by_cpu(void)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 	case X86_VENDOR_HYGON:
+		if (boot_cpu_data.x86 == 0x19 && ((boot_cpu_data.x86_model <= 0x0f) ||
+		    (boot_cpu_data.x86_model >= 0x20 && boot_cpu_data.x86_model <= 0x2f)))
+			return true;
+		else if (boot_cpu_data.x86 == 0x17 &&
+			 boot_cpu_data.x86_model >= 0x70 && boot_cpu_data.x86_model <= 0x7f)
+			return true;
 		return boot_cpu_has(X86_FEATURE_CPPC);
 	}
 	return false;


