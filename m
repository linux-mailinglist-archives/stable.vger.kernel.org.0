Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06FC5BECDA
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 20:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiITSgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 14:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiITSgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 14:36:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAD95E31F;
        Tue, 20 Sep 2022 11:36:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D2B0B81665;
        Tue, 20 Sep 2022 18:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C369C433D7;
        Tue, 20 Sep 2022 18:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663698965;
        bh=TJjBRuCFTW+TJ1tt9NdDPb5mim7RRsT5BJz/uob9soA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=laYdq+TGmx+vSPPemLSoDGDOXD9nrqAi86aEbqfSRwGW8L6xr7EumHGREJgqXpUbS
         ZXoNZplMXJ+c60i0BC2T80TUt0lZpADP3emU2cNipFlNIUfL9ULPG0cPrcv9Try9di
         1VoCOC2vQOoYD+hCYWCrYqwoqjjpQ3yV7SvHQmdUYrMmsSP49oR4BLKcYV4dNPkvLR
         ItJkQ8BtzO8LIgl0AWqtns8pmrhq2kIv2Dot9c6DxhJ3CShuhi6ocRHr0g45Ac8Z23
         nx8XBakZuzkpL6RCojs2yac8wzq3LElQIz9R5BpznDjLt1EcUlX3yWmvWUb6su2ikq
         FgBCw5WBQdjlA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     loongarch@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Xi Ruoyao <xry111@xry111.site>, stable@vger.kernel.org
Subject: [PATCH v2 1/8] efi: libstub: drop pointless get_memory_map() call
Date:   Tue, 20 Sep 2022 20:35:47 +0200
Message-Id: <20220920183554.3870247-2-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920183554.3870247-1-ardb@kernel.org>
References: <20220920183554.3870247-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1124; i=ardb@kernel.org; h=from:subject; bh=TJjBRuCFTW+TJ1tt9NdDPb5mim7RRsT5BJz/uob9soA=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjKgf9KlM+G5MYutM2WkSBF4HCuh+vKaoUimCOFi8b OqVzWv6JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYyoH/QAKCRDDTyI5ktmPJHMWDA C+8E6HThM1auFgXloRCoGjtyYoFyaGcHeX6VIoxk1dddKLl1uW/4gKJocwNfvHuvR4JybPwquSJqaf EwZx/uLxGZSBDN3OXMOFei+5pTmD+3I/rIk1/nvKy8CLg67nwX7YkF7YXGUgTzr3hpCeiUguzVuybM Kv0S3N5KwvidqHVPpJ2PoNWppSMc5ycAsJNrndiwcy9jPBe0s6j+FguuLC8zLrTyMKXpWMdVtJNHpd EbQ5FPI1gexBhRKA1XIEhBLLT7mea86QFhj26UUwCs0YqM7g5K5J+mo768tBxIJZ7jqvxKheKHrgNp h8PtpCWESdAVNgeruode6i42KCnY+/9pih+qZ1DU3FMvOlnXqTmhDKYBBOZHo4sSCHOa+7AU0EyBfb VNEfH4R33J+cJBqaLSTCkoQN1ktVA5XVsszmI+CSz7iKNEiSrlGGrk0MVb/rbcYUTf7KAGXdMmkdoJ Q4Q5Ert8gWY7Y28igHQldB6zXif6LGas55XtJcFSH05aU=
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

Currently, the non-x86 stub code calls get_memory_map() redundantly,
given that the data it returns is never used anywhere. So drop the call.

Cc: <stable@vger.kernel.org> # v4.14+
Fixes: 24d7c494ce46 ("efi/arm-stub: Round up FDT allocation to mapping size")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/fdt.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index fe567be0f118..804f542be3f2 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -280,14 +280,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 		goto fail;
 	}
 
-	/*
-	 * Now that we have done our final memory allocation (and free)
-	 * we can get the memory map key needed for exit_boot_services().
-	 */
-	status = efi_get_memory_map(&map);
-	if (status != EFI_SUCCESS)
-		goto fail_free_new_fdt;
-
 	status = update_fdt((void *)fdt_addr, fdt_size,
 			    (void *)*new_fdt_addr, MAX_FDT_SIZE, cmdline_ptr,
 			    initrd_addr, initrd_size);
-- 
2.35.1

