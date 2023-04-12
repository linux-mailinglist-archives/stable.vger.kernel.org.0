Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B946DEEAD
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjDLIoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjDLIoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13825106
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7013763081
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8492CC433EF;
        Wed, 12 Apr 2023 08:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288979;
        bh=fEOFi/Fl8HVNL7NhrdGFNEhg55LDFI/anV72b7N0fM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1/311BERD3cT5nQW41oK5xS4qsPkVuGOBRvS2Fhot9pbrk98GumKSBiGXoMspla+
         sp08bspoHrct5nKgSh+Z6utNYWpQq09o/KXzt1FiMH6jSkGw0OOADPILvY4OTeCw7J
         t4Fwaoh7Osx1ZsL5OYfDO0LzNzGCDjq6g5Soca94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric DeVolder <eric.devolder@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Mario Limonciello <mario.limonciello@amd.com>,
        stable@kernel.org
Subject: [PATCH 6.1 091/164] x86/ACPI/boot: Use FADT version to check support for online capable
Date:   Wed, 12 Apr 2023 10:33:33 +0200
Message-Id: <20230412082840.569839950@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit a74fabfbd1b7013045afc8cc541e6cab3360ccb5 upstream.

ACPI 6.3 introduced the online capable bit, and also introduced MADT
version 5.

Latter was used to distinguish whether the offset storing online capable
could be used. However ACPI 6.2b has MADT version "45" which is for
an errata version of the ACPI 6.2 spec.  This means that the Linux code
for detecting availability of MADT will mistakenly flag ACPI 6.2b as
supporting online capable which is inaccurate as it's an ACPI 6.3 feature.

Instead use the FADT major and minor revision fields to distinguish this.

  [ bp: Massage. ]

Fixes: aa06e20f1be6 ("x86/ACPI: Don't add CPUs that are not online capable")
Reported-by: Eric DeVolder <eric.devolder@oracle.com>
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/943d2445-84df-d939-f578-5d8240d342cc@unsolicited.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/acpi/boot.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -146,7 +146,11 @@ static int __init acpi_parse_madt(struct
 
 		pr_debug("Local APIC address 0x%08x\n", madt->address);
 	}
-	if (madt->header.revision >= 5)
+
+	/* ACPI 6.3 and newer support the online capable bit. */
+	if (acpi_gbl_FADT.header.revision > 6 ||
+	    (acpi_gbl_FADT.header.revision == 6 &&
+	     acpi_gbl_FADT.minor_revision >= 3))
 		acpi_support_online_capable = true;
 
 	default_acpi_madt_oem_check(madt->header.oem_id,


