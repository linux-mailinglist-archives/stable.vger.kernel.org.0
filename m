Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9544A4137
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241474AbiAaLDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34528 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358809AbiAaLBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:01:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A454A60B2C;
        Mon, 31 Jan 2022 11:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79602C340E8;
        Mon, 31 Jan 2022 11:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626899;
        bh=RlAyw1yro2XvdUgx7Zcqs3E/pvyLS4SrAYRZUEphfIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/1Y/TocN0gRZ7ZmNoPJ0tzJvajHC7UFfuUQkAiS3uMcew3N88PN45xBTLC/uGOFS
         olbD8l8pO3rFiVV05aRVxgHl2f+0itQEnN21284Ds+DA6yv+JbI/20Iol6ICF5sJyh
         /f5QeTymU3qG0nhBH8mDCmzlH7xnct5U4rJ5m6eY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Aditya Garg <gargaditya08@live.com>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 011/100] efi: runtime: avoid EFIv2 runtime services on Apple x86 machines
Date:   Mon, 31 Jan 2022 11:55:32 +0100
Message-Id: <20220131105220.835281614@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit f5390cd0b43c2e54c7cf5506c7da4a37c5cef746 upstream.

Aditya reports [0] that his recent MacbookPro crashes in the firmware
when using the variable services at runtime. The culprit appears to be a
call to QueryVariableInfo(), which we did not use to call on Apple x86
machines in the past as they only upgraded from EFI v1.10 to EFI v2.40
firmware fairly recently, and QueryVariableInfo() (along with
UpdateCapsule() et al) was added in EFI v2.00.

The only runtime service introduced in EFI v2.00 that we actually use in
Linux is QueryVariableInfo(), as the capsule based ones are optional,
generally not used at runtime (all the LVFS/fwupd firmware update
infrastructure uses helper EFI programs that invoke capsule update at
boot time, not runtime), and not implemented by Apple machines in the
first place. QueryVariableInfo() is used to 'safely' set variables,
i.e., only when there is enough space. This prevents machines with buggy
firmwares from corrupting their NVRAMs when they run out of space.

Given that Apple machines have been using EFI v1.10 services only for
the longest time (the EFI v2.0 spec was released in 2006, and Linux
support for the newly introduced runtime services was added in 2011, but
the MacbookPro12,1 released in 2015 still claims to be EFI v1.10 only),
let's avoid the EFI v2.0 ones on all Apple x86 machines.

[0] https://lore.kernel.org/all/6D757C75-65B1-468B-842D-10410081A8E4@live.com/

Cc: <stable@vger.kernel.org>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Reported-by: Aditya Garg <gargaditya08@live.com>
Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Aditya Garg <gargaditya08@live.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215277
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -719,6 +719,13 @@ void __init efi_systab_report_header(con
 		systab_hdr->revision >> 16,
 		systab_hdr->revision & 0xffff,
 		vendor);
+
+	if (IS_ENABLED(CONFIG_X86_64) &&
+	    systab_hdr->revision > EFI_1_10_SYSTEM_TABLE_REVISION &&
+	    !strcmp(vendor, "Apple")) {
+		pr_info("Apple Mac detected, using EFI v1.10 runtime services only\n");
+		efi.runtime_version = EFI_1_10_SYSTEM_TABLE_REVISION;
+	}
 }
 
 static __initdata char memory_type_name[][13] = {


