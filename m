Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7525F603262
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 20:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJRS0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 14:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiJRSZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 14:25:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C252497A;
        Tue, 18 Oct 2022 11:25:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA66FB820F0;
        Tue, 18 Oct 2022 18:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD99C433D6;
        Tue, 18 Oct 2022 18:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666117554;
        bh=om6zFfaFETCR1xyfskk4mBkA8kFqHujPVwRgrXfGQF4=;
        h=From:To:Cc:Subject:Date:From;
        b=JwJ24DFjc91Q9L6ZYZF72y3vHs6Ub/oxpUupIxWSrAmAVT3/jMXG0s7Bvu33bNnWp
         WrLv4L84Q+J6kJZC4kCMXdmSpqY544gPXceo8BXLidY+bNfgJ5GA+DF/2TEP5SX56d
         qnOzzswej9NFDh08t+/AEIcJsTFzv9LOW9vKK4dzGjAW5INN1OL7lSiHy/8b788Uuc
         PsRtTHY9xgGfGpcbe6ntJrb7X3z5vyuplqu913G3GS306tIko2tY2dljspJN2DD1mX
         QjvBfTqX+coBrB9CQw3sXTPEw0/wh8u5JVDHxvw20ZzckgYDFV+S1ImmfliBpZODfB
         RS2IEajKEdAFw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: [PATCH for-stable] efi: libstub: drop pointless get_memory_map() call
Date:   Tue, 18 Oct 2022 20:25:45 +0200
Message-Id: <20221018182545.143757-1-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1352; i=ardb@kernel.org; h=from:subject; bh=om6zFfaFETCR1xyfskk4mBkA8kFqHujPVwRgrXfGQF4=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjTu+oHBZDBr4+fRb+DrsI1FLVPtSHb9P/si31vhNZ MtHylwKJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY07vqAAKCRDDTyI5ktmPJHj6C/ 0ZHMwDnors24aETAKYxdXQ/RTprUyLX33FHBYA0Gd0Hfa1TYcw5HiqieQsP8wPvG3Q4Hz3Dwl3HRoU ggn4FpN5HoIsxLclTN2oE6VutcvC2hUIUJZWHbfeaxO1LcElR/dcxM0yhmIWzUmQZYtGdirKyDD4S2 9Y+I4SmZbc8c/W5pwtFoHcQDg5s5XpD22V1sJu6GnIbCRQY4IcDRnRZnH0UVpzQha/NIi6UAb/swHf qsUaH40yWBlK/2JdTj1z85WSOioIE+Y3fj+W0AX9TzdgXrxPMHr7ynhD0SZ6ngld+1arCmoYyqCPvX Uh42Q7gVIuPqCkiqdSfFNhJKuUeMYdDhXqZOwvTPI/MLyPEGcMqSeqtimXu9Wxdqox++t6g+3O3IFp b8CXKMBb43f1P1fEKSDT/wlEIkz770pC0jSBDpEojA6IuvGt67TSuwUjnrTbYly/u+MVNZKvbyP8xy R+mu/OnGemlP+2xIY1ULimGT7w+lry7mSnjI6vWA7lf8s=
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

commit d80ca810f096ff66f451e7a3ed2f0cd9ef1ff519 upstream

Currently, the non-x86 stub code calls get_memory_map() redundantly,
given that the data it returns is never used anywhere. So drop the call.

Cc: <stable@vger.kernel.org> # v4.14+
Fixes: 24d7c494ce46 ("efi/arm-stub: Round up FDT allocation to mapping size")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/fdt.c | 8 --------
 1 file changed, 8 deletions(-)

This is a backport for v5.4 and older, where the patch in question did
not apply cleanly on the first attempt. Please apply.

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index dba296a44f4e..2a1a587edef9 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -301,14 +301,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 		goto fail;
 	}
 
-	/*
-	 * Now that we have done our final memory allocation (and free)
-	 * we can get the memory map key needed for exit_boot_services().
-	 */
-	status = efi_get_memory_map(sys_table, &map);
-	if (status != EFI_SUCCESS)
-		goto fail_free_new_fdt;
-
 	status = update_fdt(sys_table, (void *)fdt_addr, fdt_size,
 			    (void *)*new_fdt_addr, MAX_FDT_SIZE, cmdline_ptr,
 			    initrd_addr, initrd_size);
-- 
2.35.1

