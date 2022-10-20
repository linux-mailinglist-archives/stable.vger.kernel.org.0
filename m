Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0190605A11
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 10:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiJTIkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 04:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiJTIkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 04:40:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D50FE92D;
        Thu, 20 Oct 2022 01:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4198BB826A6;
        Thu, 20 Oct 2022 08:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97391C4347C;
        Thu, 20 Oct 2022 08:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666255230;
        bh=ECHaI5zocDylFw60A6Q3tgn4qFote5nVt4SpK7yOsfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0SHYPCp8gTNsk1cTUAI2nGCRjiXax+LgHQ6owjjDZiyZRKa0LkdqKHJYEIwlJBmo
         Wn6xsBL3VUhkguPPGjNpa+xZtDqQUBpYKve4gGUMpd5H9Lhf3PQ/9gPGGYsLPbLIiT
         qBhZ7Fo1KMA3zK024Mu3R2JGcTX9988YJ2dJz7O6FYpwAs9mRFvkk4tpPll0+7spKe
         9mMCmE46ExF0qZgWcD2FczOeByOKlIVa4/+ii0My9Fx4pNBv6QXlV6RVAr9Lp8kCGL
         w7dzoXS76j5NALuuoc33YQRXtdtWtseKiQQ5IFz5OfVC2yQ/F1aHczmYyZ0Zm5deKF
         j9if+lVyO4mZA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Lennart Poettering <lennart@poettering.net>,
        stable@vger.kernel.org
Subject: [PATCH v3 2/3] efi: random: Use 'ACPI reclaim' memory for random seed
Date:   Thu, 20 Oct 2022 10:39:09 +0200
Message-Id: <20221020083910.1902009-3-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221020083910.1902009-1-ardb@kernel.org>
References: <20221020083910.1902009-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2101; i=ardb@kernel.org; h=from:subject; bh=ECHaI5zocDylFw60A6Q3tgn4qFote5nVt4SpK7yOsfU=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjUQkrdvptBKznc0r0FPMjTAGWvDsaxzEcM/YaWFbQ h11CwUaJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY1EJKwAKCRDDTyI5ktmPJJuTDA CjOGNUO9xGgMTRLDrkq9BJaOgtspt70o08B0jMmIMnpF4aVdzPphKS7zdmk4NEyXd1WrFm7Yf4RC0r Bk3u5SUyiYwYRmxAsn5Hx2mXLFUkNwHu4Yx55VExb7flFxfuBnuJRJ30weXQybppv9RguuQvt7wbU+ 8qsaIGDtJLp/nn5x2XTAjfoIfG0jwmA+hbG+EdF7pwvOUIJ/Wd4MmF3rKfDGNpIAfRH8vpUkdZtEbn 8im8UJ9VsjXERaSsyzJ5NmlHKT+oDmDjh/CTFp1952E26OArsxvB+Gjs/5OymSP583vlwuuQJM8eRx 9XOEGIVpf8d9ggI160/0I9RYQS97aN0SgUR6yo1/nDGWu2VsVPgjtFsLVmCvd/bs68W9PgBaGAdOIq Z2vSKRhLn20zJBTwPfFg6GQYdUtA4miXljC+TgVtSVvYikVuxBg0KFGJYnqVf4zO/W8P2WBSYIE/qW h2PMxuzjbP2neTA0xi1OyaK2owhpt00pdLesiIr28040o=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

EFI runtime services data is guaranteed to be preserved by the OS,
making it a suitable candidate for the EFI random seed table, which may
be passed to kexec kernels as well (after refreshing the seed), and so
we need to ensure that the memory is preserved without support from the
OS itself.

However, runtime services data is intended for allocations that are
relevant to the implementations of the runtime services themselves, and
so they are unmapped from the kernel linear map, and mapped into the EFI
page tables that are active while runtime service invocations are in
progress. None of this is needed for the RNG seed.

So let's switch to EFI 'ACPI reclaim' memory: in spite of the name,
there is nothing exclusively ACPI about it, it is simply a type of
allocation that carries firmware provided data which may or may not be
relevant to the OS, and it is left up to the OS to decide whether to
reclaim it after having consumed its contents.

Given that in Linux, we never reclaim these allocations, it is a good
choice for the EFI RNG seed, as the allocation is guaranteed to survive
kexec reboots.

One additional reason for changing this now is to align it with the
upcoming recommendation for EFI bootloader provided RNG seeds, which
must not use EFI runtime services code/data allocations.

Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 24aa37535372..183dc5cdb8ed 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -75,7 +75,7 @@ efi_status_t efi_random_get_seed(void)
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = efi_bs_call(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
+	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
 			     sizeof(*seed) + EFI_RANDOM_SEED_SIZE,
 			     (void **)&seed);
 	if (status != EFI_SUCCESS)
-- 
2.35.1

