Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DE966733B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjALNdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbjALNdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:33:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979A848CD7;
        Thu, 12 Jan 2023 05:33:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A88C61F1C;
        Thu, 12 Jan 2023 13:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306EAC433D2;
        Thu, 12 Jan 2023 13:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673530406;
        bh=n0NRV/gQw0nEZmS2n3APRi2+VgzBWVgwAhTfyRlzfsU=;
        h=From:To:Cc:Subject:Date:From;
        b=nDfCd2GNtAMorYb4yjLeRIab11aZO+4bAEKjATUWJbegZsGZPOSNIa6ne9pp0gOcG
         SpoF0sW5WqStu0DQNkPIWJmGEyqj8JnVCTr/rJ5HF1KRwo/xB2O9s6frAeVB24UNyi
         5XMcM2Rkf7Suldg7nLfna/i4DfnTDDEyIbj77npIuBaN590vv9xjkV8woz7vrtUhV+
         DubgVaYQfR/d/aR19yewLTnxyE01yK6kyl57ErST1bo7RnKHvBmgfPpenS78ROlOKY
         k26ubVk5AuUcNoBa3PvqYsHgyoPrOBAcQesyLseStqYDXC5y+PfIncqBEIBcwfeM+C
         kQQMmk+9t4Xpw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2] ACPI: PRM: Check whether EFI runtime is available
Date:   Thu, 12 Jan 2023 14:33:19 +0100
Message-Id: <20230112133319.3615177-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1906; i=ardb@kernel.org; h=from:subject; bh=n0NRV/gQw0nEZmS2n3APRi2+VgzBWVgwAhTfyRlzfsU=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjwAweHXz+wZutlvT8AmkNpNhME+0PhkT2sZDOYnh0 QYOTvuuJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY8AMHgAKCRDDTyI5ktmPJCvLC/ 40+93VWNq6Cf7jk//UbE3TFBu4YHvsgYoFFiIk3V56RyUokjt5IVcQy1A65vs9d/icuED26lSI5udC bvzCqJ1iW4y4E6gs/rVoC35feJSOIHerSw0RyJRGU4jnbDWYWRkFnmqkiLlqsCbtStLLTElFKiJGxT qz28nZZo2HYVXlk0FnFB/kNn58rRkH9VPtpeFW1B1SsOZc0nIOXVF1AYi+mLecYC+8DlWD0LcOb9Wc /nzkdfY2+0+FHWmP16FRK37tXHuSjWZgF5bgstroSD8ZqGlML44zw29tZ/pfbc/fFOkWHIUAh2x/gN lRgjzIkVBgqATq75ZdTal9jDU3c1iErULyFPSA2+nc8bIPV4ZKilOrpiEgAuDuGuM2saozbWaMtCA1 OkrPISBRZbE2EKBGQpL24fsiDc3i9XvG9zFFsrewYhVO/4vGFUUakP1TSJlTqaBg6zySFgH/d4YZql 4+Hjvyk1ScSPF1lN5REVSgxF1vo+xGS6Yn6QNEd7NAcZw=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ACPI PRM address space handler calls efi_call_virt_pointer() to
execute PRM firmware code, but doing so is only permitted when the EFI
runtime environment is available. Otherwise, such calls are guaranteed
to result in a crash, and must therefore be avoided.

Given that the EFI runtime services may become unavailable after a crash
occurring in the firmware, we need to check this each time the PRM
address space handler is invoked. If the EFI runtime services were not
available at registration time to being with, don't install the address
space handler at all.

Cc: <stable@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v2: check both at registration and at invocation time

 drivers/acpi/prmt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
index 998101cf16e47145..3d4c4620f9f95309 100644
--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -236,6 +236,11 @@ static acpi_status acpi_platformrt_space_handler(u32 function,
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
-- 
2.39.0

