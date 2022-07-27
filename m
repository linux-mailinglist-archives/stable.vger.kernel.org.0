Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E71D583068
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242278AbiG0Rhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241666AbiG0RhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:37:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338E92714;
        Wed, 27 Jul 2022 09:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA91D61479;
        Wed, 27 Jul 2022 16:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED02C433D7;
        Wed, 27 Jul 2022 16:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940598;
        bh=0H1NXs+/dIxIZ/a66/1Fny6x8s5AZbE/YcAANoqu4/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNKP9BEuFP0Y0zplXOvDiUjR9MAdPfkoZndJuZ4yEs2PNVt86ZAkkdcqDzrfw13kG
         o48L3hwKJtstp8dMzMG7v1dijS1ZIRc5SexoV/fYd/vre+fs66V/AA91247dATjW/u
         RrEz+5eT+P4oDoNqktTcU7zlifnSnMejxywsEpvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Gondois <pierre.gondois@arm.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        =?UTF-8?q?Arek=20Ru=C5=9Bniak?= <arek.rusi@gmail.com>
Subject: [PATCH 5.18 081/158] ACPI: CPPC: Dont require flexible address space if X86_FEATURE_CPPC is supported
Date:   Wed, 27 Jul 2022 18:12:25 +0200
Message-Id: <20220727161024.750164524@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 09073396ea62d0a10b03f5661dcabfd8eca3f098 ]

Commit 0651ab90e4ad ("ACPI: CPPC: Check _OSC for flexible address space")
changed _CPC probing to require flexible address space to be negotiated
for CPPC to work.

However it was observed that this caused a regression for Arek's ROG
Zephyrus G15 GA503QM which previously CPPC worked, but now it stopped
working.

To avoid causing a regression waive this failure when the CPU is known
to support CPPC.

Cc: Pierre Gondois <pierre.gondois@arm.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216248
Fixes: 0651ab90e4ad ("ACPI: CPPC: Check _OSC for flexible address space")
Reported-and-tested-by: Arek Ruśniak <arek.rusi@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 57ca7aa0e169..b8e26b6b5523 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -764,7 +764,8 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 
 					if (!osc_cpc_flexible_adr_space_confirmed) {
 						pr_debug("Flexible address space capability not supported\n");
-						goto out_free;
+						if (!cpc_supported_by_cpu())
+							goto out_free;
 					}
 
 					addr = ioremap(gas_t->address, gas_t->bit_width/8);
@@ -791,7 +792,8 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 				}
 				if (!osc_cpc_flexible_adr_space_confirmed) {
 					pr_debug("Flexible address space capability not supported\n");
-					goto out_free;
+					if (!cpc_supported_by_cpu())
+						goto out_free;
 				}
 			} else {
 				if (gas_t->space_id != ACPI_ADR_SPACE_FIXED_HARDWARE || !cpc_ffh_supported()) {
-- 
2.35.1



