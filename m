Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127015EA0F8
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbiIZKnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbiIZKmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:42:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496274D4E1;
        Mon, 26 Sep 2022 03:24:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBD6AB80926;
        Mon, 26 Sep 2022 10:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D28C43149;
        Mon, 26 Sep 2022 10:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187804;
        bh=hHUaDJrxc6E0aVhxiuBcXlPxNUtmBzy1sqbl3JBWaKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kiXMl7ihjiKplaf9jiCV38tym7DSwdAdbbZecDsIeGvfi7XDGFw69/dHlgDs4mNUp
         eSC3PzYNN+alTJsI0bVk3VSWnZ6QmXivPudtriS6FO5FES9e6VLDmidqC7SVCloT8N
         QIFp8FQIjzpo7KinGtzQ4vQD5C0DW5Pv0IZJnPZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Peter Jones <pjones@redhat.com>
Subject: [PATCH 5.4 064/120] efi: libstub: check Shim mode using MokSBStateRT
Date:   Mon, 26 Sep 2022 12:11:37 +0200
Message-Id: <20220926100753.312509950@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 5f56a74cc0a6d9b9f8ba89cea29cd7c4774cb2b1 upstream.

We currently check the MokSBState variable to decide whether we should
treat UEFI secure boot as being disabled, even if the firmware thinks
otherwise. This is used by shim to indicate that it is not checking
signatures on boot images. In the kernel, we use this to relax lockdown
policies.

However, in cases where shim is not even being used, we don't want this
variable to interfere with lockdown, given that the variable may be
non-volatile and therefore persist across a reboot. This means setting
it once will persistently disable lockdown checks on a given system.

So switch to the mirrored version of this variable, called MokSBStateRT,
which is supposed to be volatile, and this is something we can check.

Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/secureboot.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -19,7 +19,7 @@ static const efi_char16_t efi_SetupMode_
 
 /* SHIM variables */
 static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
-static const efi_char16_t shim_MokSBState_name[] = L"MokSBState";
+static const efi_char16_t shim_MokSBState_name[] = L"MokSBStateRT";
 
 #define get_efi_var(name, vendor, ...) \
 	efi_call_runtime(get_variable, \
@@ -58,8 +58,8 @@ enum efi_secureboot_mode efi_get_secureb
 
 	/*
 	 * See if a user has put the shim into insecure mode. If so, and if the
-	 * variable doesn't have the runtime attribute set, we might as well
-	 * honor that.
+	 * variable doesn't have the non-volatile attribute set, we might as
+	 * well honor that.
 	 */
 	size = sizeof(moksbstate);
 	status = get_efi_var(shim_MokSBState_name, &shim_guid,
@@ -68,7 +68,7 @@ enum efi_secureboot_mode efi_get_secureb
 	/* If it fails, we don't care why. Default to secure */
 	if (status != EFI_SUCCESS)
 		goto secure_boot_enabled;
-	if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS) && moksbstate == 1)
+	if (!(attr & EFI_VARIABLE_NON_VOLATILE) && moksbstate == 1)
 		return efi_secureboot_mode_disabled;
 
 secure_boot_enabled:


