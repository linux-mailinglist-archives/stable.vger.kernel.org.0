Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7DEF176C86
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgCCCs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:48:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbgCCCsZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D020424697;
        Tue,  3 Mar 2020 02:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203704;
        bh=NkRFNdz3XKrMZQz4RVrE5BBAyFyLOqfqLt6eXCZ7G5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icVM2Gf0zqcilKhxcwW0HNEBMyRnB9RFQUbrKtjpRZ055Yst2UyvoFWKjVDGc2dem
         9RrOA7NwAB0sm+ovMeUX1E3WdiqXM1mGFhoX+3OdjITuU2Y0v0iCJYmSnPxiOTdMsM
         u2Sb7WGvXaV/X6+au327e3fTK+vzKmY4owLJUaaY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javier Martinez Canillas <javierm@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 36/58] efi: Only print errors about failing to get certs if EFI vars are found
Date:   Mon,  2 Mar 2020 21:47:18 -0500
Message-Id: <20200303024740.9511-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

