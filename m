Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E8162140E
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbiKHN47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbiKHN4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:56:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0167BF4F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:56:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 924AD6157B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65717C433D6;
        Tue,  8 Nov 2022 13:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915811;
        bh=8qMJrL8jM4NOzuN0P8gzaWT2Ees7y+uYk191o5DiUvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJ2Np9ZGo0BeUudUj1XmYRoNHG7UPMM67kKKUgqeszx+Kp8aZGJLMCiVpGYS+gNaL
         yW/hD6vVUC7kuSTj5UFPzTzJSr81zT4Rg+kf81JFS5qEuvjQ0i22gP3OOe1LFPTHfI
         NRHHtPFRyEB0ZMVDnxQv/tgJjFl8v4ibY1pDeWqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 5.10 098/118] efi: random: Use ACPI reclaim memory for random seed
Date:   Tue,  8 Nov 2022 14:39:36 +0100
Message-Id: <20221108133345.004547414@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 7d866e38c7e9ece8a096d0d098fa9d92b9d4f97e upstream.

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
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/random.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -75,7 +75,12 @@ efi_status_t efi_random_get_seed(void)
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = efi_bs_call(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
+	/*
+	 * Use EFI_ACPI_RECLAIM_MEMORY here so that it is guaranteed that the
+	 * allocation will survive a kexec reboot (although we refresh the seed
+	 * beforehand)
+	 */
+	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
 			     sizeof(*seed) + EFI_RANDOM_SEED_SIZE,
 			     (void **)&seed);
 	if (status != EFI_SUCCESS)


