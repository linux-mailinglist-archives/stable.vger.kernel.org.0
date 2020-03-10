Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7618317FDF5
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgCJMt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:49:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbgCJMt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:49:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C0A52468D;
        Tue, 10 Mar 2020 12:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844565;
        bh=NkRFNdz3XKrMZQz4RVrE5BBAyFyLOqfqLt6eXCZ7G5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iif+OUp6PlezszacqxcoTN/CX4SEARG+aMhs804YAsUxcDVyZR2FOQ2pezX2qM46a
         ygthkHNNJ3YcIROaxZZ2vyZWcL+54uV04g0rq3Yw2Rcqu9t3FzvgOR6txLD4eJzEnf
         grwNSpw5pU6+ZErNm8U+Zw7Rc3MgmeaWqN/nSi5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/168] efi: Only print errors about failing to get certs if EFI vars are found
Date:   Tue, 10 Mar 2020 13:38:05 +0100
Message-Id: <20200310123639.394289234@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 3be54d558c75562e42bc83d665df024bd79d399b ]

If CONFIG_LOAD_UEFI_KEYS is enabled, the kernel attempts to load the certs
from the db, dbx and MokListRT EFI variables into the appropriate keyrings.

But it just assumes that the variables will be present and prints an error
if the certs can't be loaded, even when is possible that the variables may
not exist. For example the MokListRT variable will only be present if shim
is used.

So only print an error message about failing to get the certs list from an
EFI variable if this is found. Otherwise these printed errors just pollute
the kernel log ring buffer with confusing messages like the following:

[    5.427251] Couldn't get size: 0x800000000000000e
[    5.427261] MODSIGN: Couldn't get UEFI db list
[    5.428012] Couldn't get size: 0x800000000000000e
[    5.428023] Couldn't get UEFI MokListRT

Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/platform_certs/load_uefi.c | 40 ++++++++++++-------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integrity/platform_certs/load_uefi.c
index 81b19c52832ba..020fc7a11ef0e 100644
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -39,16 +39,18 @@ static __init bool uefi_check_ignore_db(void)
  * Get a certificate list blob from the named EFI variable.
  */
 static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
-				  unsigned long *size)
+				  unsigned long *size, efi_status_t *status)
 {
-	efi_status_t status;
 	unsigned long lsize = 4;
 	unsigned long tmpdb[4];
 	void *db;
 
-	status = efi.get_variable(name, guid, NULL, &lsize, &tmpdb);
-	if (status != EFI_BUFFER_TOO_SMALL) {
-		pr_err("Couldn't get size: 0x%lx\n", status);
+	*status = efi.get_variable(name, guid, NULL, &lsize, &tmpdb);
+	if (*status == EFI_NOT_FOUND)
+		return NULL;
+
+	if (*status != EFI_BUFFER_TOO_SMALL) {
+		pr_err("Couldn't get size: 0x%lx\n", *status);
 		return NULL;
 	}
 
@@ -56,10 +58,10 @@ static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
 	if (!db)
 		return NULL;
 
-	status = efi.get_variable(name, guid, NULL, &lsize, db);
-	if (status != EFI_SUCCESS) {
+	*status = efi.get_variable(name, guid, NULL, &lsize, db);
+	if (*status != EFI_SUCCESS) {
 		kfree(db);
-		pr_err("Error reading db var: 0x%lx\n", status);
+		pr_err("Error reading db var: 0x%lx\n", *status);
 		return NULL;
 	}
 
@@ -144,6 +146,7 @@ static int __init load_uefi_certs(void)
 	efi_guid_t mok_var = EFI_SHIM_LOCK_GUID;
 	void *db = NULL, *dbx = NULL, *mok = NULL;
 	unsigned long dbsize = 0, dbxsize = 0, moksize = 0;
+	efi_status_t status;
 	int rc = 0;
 
 	if (!efi.get_variable)
@@ -153,9 +156,12 @@ static int __init load_uefi_certs(void)
 	 * an error if we can't get them.
 	 */
 	if (!uefi_check_ignore_db()) {
-		db = get_cert_list(L"db", &secure_var, &dbsize);
+		db = get_cert_list(L"db", &secure_var, &dbsize, &status);
 		if (!db) {
-			pr_err("MODSIGN: Couldn't get UEFI db list\n");
+			if (status == EFI_NOT_FOUND)
+				pr_debug("MODSIGN: db variable wasn't found\n");
+			else
+				pr_err("MODSIGN: Couldn't get UEFI db list\n");
 		} else {
 			rc = parse_efi_signature_list("UEFI:db",
 					db, dbsize, get_handler_for_db);
@@ -166,9 +172,12 @@ static int __init load_uefi_certs(void)
 		}
 	}
 
-	mok = get_cert_list(L"MokListRT", &mok_var, &moksize);
+	mok = get_cert_list(L"MokListRT", &mok_var, &moksize, &status);
 	if (!mok) {
-		pr_info("Couldn't get UEFI MokListRT\n");
+		if (status == EFI_NOT_FOUND)
+			pr_debug("MokListRT variable wasn't found\n");
+		else
+			pr_info("Couldn't get UEFI MokListRT\n");
 	} else {
 		rc = parse_efi_signature_list("UEFI:MokListRT",
 					      mok, moksize, get_handler_for_db);
@@ -177,9 +186,12 @@ static int __init load_uefi_certs(void)
 		kfree(mok);
 	}
 
-	dbx = get_cert_list(L"dbx", &secure_var, &dbxsize);
+	dbx = get_cert_list(L"dbx", &secure_var, &dbxsize, &status);
 	if (!dbx) {
-		pr_info("Couldn't get UEFI dbx list\n");
+		if (status == EFI_NOT_FOUND)
+			pr_debug("dbx variable wasn't found\n");
+		else
+			pr_info("Couldn't get UEFI dbx list\n");
 	} else {
 		rc = parse_efi_signature_list("UEFI:dbx",
 					      dbx, dbxsize,
-- 
2.20.1



