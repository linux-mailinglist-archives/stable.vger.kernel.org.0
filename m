Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7FC5EA429
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbiIZLlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238349AbiIZLk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:40:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151CF550B5;
        Mon, 26 Sep 2022 03:45:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98B47B802C5;
        Mon, 26 Sep 2022 10:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA36C433C1;
        Mon, 26 Sep 2022 10:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189023;
        bh=Qts+mTwxPMEZO9kijhoy/64pFEzmYfB6q0q5Kwgo2VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abSjpDQBtPheaP6QS0JwlvVbgpPuEe65ie2X8wXnvD2ODds83cdf0818jfjbMZvQp
         44/MkyptpR5/nsMUcBhvRAaEO8Rth3nsbFhVpip0a4Qi0di9LGWyhXrKZ5Kz3tqq/s
         kD2n0vV8FnQU+g2mDA9EVarhuZxL4JrFvUusnNBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Peter Jones <pjones@redhat.com>
Subject: [PATCH 5.19 049/207] efi: libstub: check Shim mode using MokSBStateRT
Date:   Mon, 26 Sep 2022 12:10:38 +0200
Message-Id: <20220926100808.810093249@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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
@@ -14,7 +14,7 @@
 
 /* SHIM variables */
 static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
-static const efi_char16_t shim_MokSBState_name[] = L"MokSBState";
+static const efi_char16_t shim_MokSBState_name[] = L"MokSBStateRT";
 
 static efi_status_t get_var(efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
 			    unsigned long *data_size, void *data)
@@ -43,8 +43,8 @@ enum efi_secureboot_mode efi_get_secureb
 
 	/*
 	 * See if a user has put the shim into insecure mode. If so, and if the
-	 * variable doesn't have the runtime attribute set, we might as well
-	 * honor that.
+	 * variable doesn't have the non-volatile attribute set, we might as
+	 * well honor that.
 	 */
 	size = sizeof(moksbstate);
 	status = get_efi_var(shim_MokSBState_name, &shim_guid,
@@ -53,7 +53,7 @@ enum efi_secureboot_mode efi_get_secureb
 	/* If it fails, we don't care why. Default to secure */
 	if (status != EFI_SUCCESS)
 		goto secure_boot_enabled;
-	if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS) && moksbstate == 1)
+	if (!(attr & EFI_VARIABLE_NON_VOLATILE) && moksbstate == 1)
 		return efi_secureboot_mode_disabled;
 
 secure_boot_enabled:


