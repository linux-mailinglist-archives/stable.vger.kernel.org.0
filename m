Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B3833BA90
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhCOOJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234536AbhCOOEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BBF264F17;
        Mon, 15 Mar 2021 14:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817053;
        bh=WpyuGGg4fLXOdll3DlmkFdMT8Yj29Ez8TxbVjZ3qKs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvfuZzg8k+RfkG22cq+7KWj8DgpnnvNc2/x7rCnBC5Rqk0+F7Nn4spBpom2ccuvXn
         c493GMtSbx+Dnt3tYbEvkbipJ0Grl32sXnW2ujHA5Wm/zFvi7VLpezApPHdErfQx/Y
         Jc9ZjFKnZnLp5kHJQtLdoh9OCHDnq2qOOu4qz9CY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 264/290] efi: stub: omit SetVirtualAddressMap() if marked unsupported in RT_PROP table
Date:   Mon, 15 Mar 2021 14:55:57 +0100
Message-Id: <20210315135550.939002740@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ard Biesheuvel <ardb@kernel.org>

commit 9e9888a0fe97b9501a40f717225d2bef7100a2c1 upstream.

The EFI_RT_PROPERTIES_TABLE contains a mask of runtime services that are
available after ExitBootServices(). This mostly does not concern the EFI
stub at all, given that it runs before that. However, there is one call
that is made at runtime, which is the call to SetVirtualAddressMap()
(which is not even callable at boot time to begin with)

So add the missing handling of the RT_PROP table to ensure that we only
call SetVirtualAddressMap() if it is not being advertised as unsupported
by the firmware.

Cc: <stable@vger.kernel.org> # v5.10+
Tested-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/efi-stub.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -96,6 +96,18 @@ static void install_memreserve_table(voi
 		efi_err("Failed to install memreserve config table!\n");
 }
 
+static u32 get_supported_rt_services(void)
+{
+	const efi_rt_properties_table_t *rt_prop_table;
+	u32 supported = EFI_RT_SUPPORTED_ALL;
+
+	rt_prop_table = get_efi_config_table(EFI_RT_PROPERTIES_TABLE_GUID);
+	if (rt_prop_table)
+		supported &= rt_prop_table->runtime_services_supported;
+
+	return supported;
+}
+
 /*
  * EFI entry point for the arm/arm64 EFI stubs.  This is the entrypoint
  * that is described in the PE/COFF header.  Most of the code is the same
@@ -250,6 +262,10 @@ efi_status_t __efiapi efi_pe_entry(efi_h
 			  (prop_tbl->memory_protection_attribute &
 			   EFI_PROPERTIES_RUNTIME_MEMORY_PROTECTION_NON_EXECUTABLE_PE_DATA);
 
+	/* force efi_novamap if SetVirtualAddressMap() is unsupported */
+	efi_novamap |= !(get_supported_rt_services() &
+			 EFI_RT_SUPPORTED_SET_VIRTUAL_ADDRESS_MAP);
+
 	/* hibernation expects the runtime regions to stay in the same place */
 	if (!IS_ENABLED(CONFIG_HIBERNATION) && !efi_nokaslr && !flat_va_mapping) {
 		/*


