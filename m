Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D26330CA3
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 12:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhCHLqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 06:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhCHLqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 06:46:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E094C06174A;
        Mon,  8 Mar 2021 03:46:40 -0800 (PST)
Date:   Mon, 08 Mar 2021 11:46:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615203998;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=D14/ASdzhgKw/JKB9L849uiutME+4sk5Ek3aW7Gm5ro=;
        b=RwaCjYHqvqd6x8g8/hbQcuAaj03s6omxRM+uNLHzJci3nCTwYFb57Nrm0UFFY2pe99HFhJ
        ihQ75zrqSBzBiim6rMTkLYLWe23MAfnOTfN9z6BsRIhy5cL1lHLVZ367zL9WLtDg89WK3K
        CHSVbe6t955pfc0aEhfbeCTaeetoCRALhZZi6WQNnKLaSGQwJZNo06kNX2irDjQbUnUfG2
        na8DQi57kGUCmZfyWevcPlC3XNMRoM+YOLYHu0P8+Y8gCgYtWSGCSPGdyDTXqHe0Bb5i4e
        rtUtHSTP0FCNIvetK8MqyTekIIdzs73/t2BBIG/nHsKA/hiyWrBjaKnGbyJFKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615203998;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=D14/ASdzhgKw/JKB9L849uiutME+4sk5Ek3aW7Gm5ro=;
        b=upkeEWjF5D+zpKrqRzx4R8nKQsBO6FJ5O73dUgBOqt5Pa7o5IMQkjiYcHJI7uatT1+x6Wi
        mALjzXed6eLHkyDA==
From:   "tip-bot2 for Ard Biesheuvel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi: stub: omit SetVirtualAddressMap() if marked
 unsupported in RT_PROP table
Cc:     <stable@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <161520399753.398.8886708450052233284.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     9e9888a0fe97b9501a40f717225d2bef7100a2c1
Gitweb:        https://git.kernel.org/tip/9e9888a0fe97b9501a40f717225d2bef7100a2c1
Author:        Ard Biesheuvel <ardb@kernel.org>
AuthorDate:    Fri, 05 Mar 2021 10:21:05 +01:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Sun, 07 Mar 2021 09:31:02 +01:00

efi: stub: omit SetVirtualAddressMap() if marked unsupported in RT_PROP table

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
---
 drivers/firmware/efi/libstub/efi-stub.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index ec2f398..26e6978 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -96,6 +96,18 @@ static void install_memreserve_table(void)
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
@@ -250,6 +262,10 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 			  (prop_tbl->memory_protection_attribute &
 			   EFI_PROPERTIES_RUNTIME_MEMORY_PROTECTION_NON_EXECUTABLE_PE_DATA);
 
+	/* force efi_novamap if SetVirtualAddressMap() is unsupported */
+	efi_novamap |= !(get_supported_rt_services() &
+			 EFI_RT_SUPPORTED_SET_VIRTUAL_ADDRESS_MAP);
+
 	/* hibernation expects the runtime regions to stay in the same place */
 	if (!IS_ENABLED(CONFIG_HIBERNATION) && !efi_nokaslr && !flat_va_mapping) {
 		/*
