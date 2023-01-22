Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C931676F9D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjAVPXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjAVPXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61935E394
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F045660C44
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3D4C433EF;
        Sun, 22 Jan 2023 15:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401002;
        bh=MMLQJfFS906vnkmV6Gkv21a7ciy0a+UNYJfIlroL2Ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSy88qIJ65bCImXXX8s6oy1zDk7YpuofpBBmz8VLvwHJ5Cp0qgdWnPLdUlCa4RCrI
         LITn/QwEfIzNfXzV8J9be9l+tUT8qGK00pq2u5jb1tiCcXqNGmXHWEYZXFVXNkUpR8
         CY9us5JOI/Ow8c4qgelkWynkpYODG/OsKivCCvsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 073/193] ACPI: PRM: Check whether EFI runtime is available
Date:   Sun, 22 Jan 2023 16:03:22 +0100
Message-Id: <20230122150249.678795320@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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
@@ -236,6 +236,11 @@ static acpi_status acpi_platformrt_space
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
@@ -325,6 +330,11 @@ void __init init_prmt(void)
 
 	pr_info("PRM: found %u modules\n", mc);
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_err("PRM: EFI runtime services unavailable\n");
+		return;
+	}
+
 	status = acpi_install_address_space_handler(ACPI_ROOT_OBJECT,
 						    ACPI_ADR_SPACE_PLATFORM_RT,
 						    &acpi_platformrt_space_handler,


