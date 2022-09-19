Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08F55BD1E5
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 18:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiISQJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 12:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiISQJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 12:09:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252D41183A;
        Mon, 19 Sep 2022 09:09:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B642160C62;
        Mon, 19 Sep 2022 16:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9711AC43470;
        Mon, 19 Sep 2022 16:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663603786;
        bh=ECHaI5zocDylFw60A6Q3tgn4qFote5nVt4SpK7yOsfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fr9PLTPXSR6TRPPag4Jbqi84GJzRsCdVCB3nBMlGVRVrWbxROwltSKdsYL3S+pHrE
         GnTf6POjubUjB/m4T915KJFfCWdevWp1ZcOP0eJi0ysFvc609TSJmQwuGXY9l1QQ/p
         tigwl2WkJ+6oA7jwjM4n2q36Q/EnUc/QCtnDq5TEBoW6B7LE0hML+cEtlNZ7s0SQuB
         J9xsXIWPEHvG27M6JuAIMB9fD1a+YuHLvGwMLk/epdGGxPew5nmTaqdny94RHoExWy
         zwrL32OPBbLqtsjmoyWTMuGMpUN9KsDgeCEd2RA2iz90Wcn26iTMTcLgnwg8vCteX5
         kZSnPYu4Af+ug==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Lennart Poettering <lennart@poettering.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] efi: random: Use 'ACPI reclaim' memory for random seed
Date:   Mon, 19 Sep 2022 18:09:30 +0200
Message-Id: <20220919160931.2945427-3-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220919160931.2945427-1-ardb@kernel.org>
References: <20220919160931.2945427-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2101; i=ardb@kernel.org; h=from:subject; bh=ECHaI5zocDylFw60A6Q3tgn4qFote5nVt4SpK7yOsfU=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjKJQ4dvptBKznc0r0FPMjTAGWvDsaxzEcM/YaWFbQ h11CwUaJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYyiUOAAKCRDDTyI5ktmPJLZoDA Cx6cgSNKu9vVq9XBm1uBYScpTsevUH/DWib6Gkx0SfNdx7/JEsyVYgcV7YgMyvvC+eFUjkClFiHIut QUxWiW9DCZerN9qpOs9V3G9QAv28yztiQJu4jzzbuNk6kDPLcYxOKT2zYePx/14m+A0snTxA+zBiBX oVuLxo5EohjatrDZkCbaTehkYpK5sFXKBO4T+V+LAaK6FdR4Awo0vPI3HYlur13el/TG5WGSt4R8ps 93U0FkSfdfK69xNErNPToGNScLAiRChHEhk3am6TOtCRioXmARFTD+39l073AvavKIVVIZAf/iQ0Po oFweBuEXvQsM7wuhRipFIwpwVpWNpnqabEELbn6Zz0mx6AE2SCf+6UY+82y01w7jkH+qTiDKIAsx7r aJoXdD/rndN6eOw+ZMRZAmmcHbPwls+aMEajqDa8+DPxQRWWVN6GBXHyofrZOjLNWmxX7V3kkx82dr uPOc7QhssTZVi2R9RqnN9QLt4f2gfofLP7/LH/grzGk7s=
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

