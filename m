Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD3E60A1AF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiJXLcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiJXLcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:32:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B605E55C;
        Mon, 24 Oct 2022 04:31:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD2A061251;
        Mon, 24 Oct 2022 11:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD99EC433C1;
        Mon, 24 Oct 2022 11:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611116;
        bh=eLrnmTlnmMdpbACYZc3GPWxthCIJh0Mjw7MbfVQmRL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQKeGs3LVhowZ+EgQ5dagqKnxJ8B7g7N0yrgZUFG6xXAKr9TPWkmlxpf5gpwXxO+j
         ZM0f3ZU4nYoCE2gsbGKHzBI+EEOGfZZrFLzkQf/7M9rVMXlnXJsNno2bQ42oHM81QL
         wJFaKE/tvg+wq81hWzER1kmGzy7lG/+0i1mXi+L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.0 15/20] efi: efivars: Fix variable writes without query_variable_store()
Date:   Mon, 24 Oct 2022 13:31:17 +0200
Message-Id: <20221024112935.030619098@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
References: <20221024112934.415391158@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 8a254d90a77580244ec57e82bca7eb65656cc167 upstream.

Commit bbc6d2c6ef22 ("efi: vars: Switch to new wrapper layer")
refactored the efivars layer so that the 'business logic' related to
which UEFI variables affect the boot flow in which way could be moved
out of it, and into the efivarfs driver.

This inadvertently broke setting variables on firmware implementations
that lack the QueryVariableInfo() boot service, because we no longer
tolerate a EFI_UNSUPPORTED result from check_var_size() when calling
efivar_entry_set_get_size(), which now ends up calling check_var_size()
a second time inadvertently.

If QueryVariableInfo() is missing, we support writes of up to 64k -
let's move that logic into check_var_size(), and drop the redundant
call.

Cc: <stable@vger.kernel.org> # v6.0
Fixes: bbc6d2c6ef22 ("efi: vars: Switch to new wrapper layer")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/vars.c |   10 +++++-----
 fs/efivarfs/vars.c          |   16 ----------------
 include/linux/efi.h         |    3 ---
 3 files changed, 5 insertions(+), 24 deletions(-)

--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/sizes.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -20,19 +21,19 @@ static struct efivars *__efivars;
 
 static DEFINE_SEMAPHORE(efivars_lock);
 
-efi_status_t check_var_size(u32 attributes, unsigned long size)
+static efi_status_t check_var_size(u32 attributes, unsigned long size)
 {
 	const struct efivar_operations *fops;
 
 	fops = __efivars->ops;
 
 	if (!fops->query_variable_store)
-		return EFI_UNSUPPORTED;
+		return (size <= SZ_64K) ? EFI_SUCCESS : EFI_OUT_OF_RESOURCES;
 
 	return fops->query_variable_store(attributes, size, false);
 }
-EXPORT_SYMBOL_NS_GPL(check_var_size, EFIVAR);
 
+static
 efi_status_t check_var_size_nonblocking(u32 attributes, unsigned long size)
 {
 	const struct efivar_operations *fops;
@@ -40,11 +41,10 @@ efi_status_t check_var_size_nonblocking(
 	fops = __efivars->ops;
 
 	if (!fops->query_variable_store)
-		return EFI_UNSUPPORTED;
+		return (size <= SZ_64K) ? EFI_SUCCESS : EFI_OUT_OF_RESOURCES;
 
 	return fops->query_variable_store(attributes, size, true);
 }
-EXPORT_SYMBOL_NS_GPL(check_var_size_nonblocking, EFIVAR);
 
 /**
  * efivars_kobject - get the kobject for the registered efivars
--- a/fs/efivarfs/vars.c
+++ b/fs/efivarfs/vars.c
@@ -651,22 +651,6 @@ int efivar_entry_set_get_size(struct efi
 	if (err)
 		return err;
 
-	/*
-	 * Ensure that the available space hasn't shrunk below the safe level
-	 */
-	status = check_var_size(attributes, *size + ucs2_strsize(name, 1024));
-	if (status != EFI_SUCCESS) {
-		if (status != EFI_UNSUPPORTED) {
-			err = efi_status_to_err(status);
-			goto out;
-		}
-
-		if (*size > 65536) {
-			err = -ENOSPC;
-			goto out;
-		}
-	}
-
 	status = efivar_set_variable_locked(name, vendor, attributes, *size,
 					    data, false);
 	if (status != EFI_SUCCESS) {
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1055,9 +1055,6 @@ efi_status_t efivar_set_variable_locked(
 efi_status_t efivar_set_variable(efi_char16_t *name, efi_guid_t *vendor,
 				 u32 attr, unsigned long data_size, void *data);
 
-efi_status_t check_var_size(u32 attributes, unsigned long size);
-efi_status_t check_var_size_nonblocking(u32 attributes, unsigned long size);
-
 #if IS_ENABLED(CONFIG_EFI_CAPSULE_LOADER)
 extern bool efi_capsule_pending(int *reset_type);
 


