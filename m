Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEB1676F1D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjAVPSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjAVPRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:17:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EE5524D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:17:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D94F60C5C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308D8C433D2;
        Sun, 22 Jan 2023 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400668;
        bh=pwlfrExc1ZGFcmpgEfHh/BxZ7h3fcqCAgX1468Hklsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRN+8lp/I8wEsQ13zIeEAHZVU2Nq1mBVDfojWhZ1uTrSLYWZr+bkQOPFYS8ywYTQy
         uSi8RwoFcUkYGE6bKLp9QpHf3wOlisPa0HdnE8x31OhFjZvrWZkYZXJnEIHCZiRI3n
         +RRetQdvOPYbZuuBNQHY8ds0E+YL96UID5cmHfC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 062/117] ACPI: PRM: Check whether EFI runtime is available
Date:   Sun, 22 Jan 2023 16:04:12 +0100
Message-Id: <20230122150235.365664658@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 182da6f2b81a78709c58021542fb694f8ed80774 upstream.

The ACPI PRM address space handler calls efi_call_virt_pointer() to
execute PRM firmware code, but doing so is only permitted when the EFI
runtime environment is available. Otherwise, such calls are guaranteed
to result in a crash, and must therefore be avoided.

Given that the EFI runtime services may become unavailable after a crash
occurring in the firmware, we need to check this each time the PRM
address space handler is invoked. If the EFI runtime services were not
available at registration time to being with, don't install the address
space handler at all.

Fixes: cefc7ca46235 ("ACPI: PRM: implement OperationRegion handler for the PlatformRtMechanism subtype")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/prmt.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -219,6 +219,11 @@ static acpi_status acpi_platformrt_space
 	efi_status_t status;
 	struct prm_context_buffer context;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_err_ratelimited("PRM: EFI runtime services no longer available\n");
+		return AE_NO_HANDLER;
+	}
+
 	/*
 	 * The returned acpi_status will always be AE_OK. Error values will be
 	 * saved in the first byte of the PRM message buffer to be used by ASL.
@@ -308,6 +313,11 @@ void __init init_prmt(void)
 
 	pr_info("PRM: found %u modules\n", mc);
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_err("PRM: EFI runtime services unavailable\n");
+		return;
+	}
+
 	status = acpi_install_address_space_handler(ACPI_ROOT_OBJECT,
 						    ACPI_ADR_SPACE_PLATFORM_RT,
 						    &acpi_platformrt_space_handler,


