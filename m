Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C505E9FCD
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbiIZK3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbiIZK2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:28:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602E24E84C;
        Mon, 26 Sep 2022 03:19:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78A0160AD6;
        Mon, 26 Sep 2022 10:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B07C433C1;
        Mon, 26 Sep 2022 10:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187509;
        bh=GLloAbWf1ibfp4C7gKCcO5fNiAAMTzZrSFe2GtoRA7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yy2aX7GN00JMifX93pO/y0heXKP7D7Nhm3baPZQjN3TOgTQwSCMDxa8OLQxd8lz1v
         5MgPYj6oU6uITW0yc1/eOx84dRHeSNGFfZtrYWKUjufnlDHe62wHM4IiHmkVqLi370
         6WWrnD1o0xAnzDC9lKa45L6R+q5lZkgE0OnI7xvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Peter Jones <pjones@redhat.com>
Subject: [PATCH 4.19 31/58] efi: libstub: check Shim mode using MokSBStateRT
Date:   Mon, 26 Sep 2022 12:11:50 +0200
Message-Id: <20220926100742.617625457@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
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
@@ -21,7 +21,7 @@ static const efi_char16_t efi_SetupMode_
 
 /* SHIM variables */
 static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
-static const efi_char16_t shim_MokSBState_name[] = L"MokSBState";
+static const efi_char16_t shim_MokSBState_name[] = L"MokSBStateRT";
 
 #define get_efi_var(name, vendor, ...) \
 	efi_call_runtime(get_variable, \
@@ -60,8 +60,8 @@ enum efi_secureboot_mode efi_get_secureb
 
 	/*
 	 * See if a user has put the shim into insecure mode. If so, and if the
-	 * variable doesn't have the runtime attribute set, we might as well
-	 * honor that.
+	 * variable doesn't have the non-volatile attribute set, we might as
+	 * well honor that.
 	 */
 	size = sizeof(moksbstate);
 	status = get_efi_var(shim_MokSBState_name, &shim_guid,
@@ -70,7 +70,7 @@ enum efi_secureboot_mode efi_get_secureb
 	/* If it fails, we don't care why. Default to secure */
 	if (status != EFI_SUCCESS)
 		goto secure_boot_enabled;
-	if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS) && moksbstate == 1)
+	if (!(attr & EFI_VARIABLE_NON_VOLATILE) && moksbstate == 1)
 		return efi_secureboot_mode_disabled;
 
 secure_boot_enabled:


