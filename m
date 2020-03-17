Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B78B1881BC
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgCQLTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:19:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727225AbgCQLEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:04:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33A3220752;
        Tue, 17 Mar 2020 11:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443072;
        bh=5QJOn0BGZeqjo1WWc33zP/NAQjl4vPPkzkv1rjbDqwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GzjeoH99e4V9h/3ZNhmE+INlH8+qLH9iyXze0x0kSPTz6XuShBNsoti7RWnCrq3/
         o2xsI08N77poC9CSr6UrQubLWG1UHe02zTXfX+AvewCmW3T8a/5psTsrny5L5YPy8t
         cu6f1/IPs9cbKT/BdLD9t8oG5z6TCLaszXJ+80u8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Bob Sanders <bob.sanders@hpe.com>
Subject: [PATCH 5.4 087/123] efi: Fix a race and a buffer overflow while reading efivars via sysfs
Date:   Tue, 17 Mar 2020 11:55:14 +0100
Message-Id: <20200317103316.676814868@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladis Dronov <vdronov@redhat.com>

commit 286d3250c9d6437340203fb64938bea344729a0e upstream.

There is a race and a buffer overflow corrupting a kernel memory while
reading an EFI variable with a size more than 1024 bytes via the older
sysfs method. This happens because accessing struct efi_variable in
efivar_{attr,size,data}_read() and friends is not protected from
a concurrent access leading to a kernel memory corruption and, at best,
to a crash. The race scenario is the following:

CPU0:                                CPU1:
efivar_attr_read()
  var->DataSize = 1024;
  efivar_entry_get(... &var->DataSize)
    down_interruptible(&efivars_lock)
                                     efivar_attr_read() // same EFI var
                                       var->DataSize = 1024;
                                       efivar_entry_get(... &var->DataSize)
                                         down_interruptible(&efivars_lock)
    virt_efi_get_variable()
    // returns EFI_BUFFER_TOO_SMALL but
    // var->DataSize is set to a real
    // var size more than 1024 bytes
    up(&efivars_lock)
                                         virt_efi_get_variable()
                                         // called with var->DataSize set
                                         // to a real var size, returns
                                         // successfully and overwrites
                                         // a 1024-bytes kernel buffer
                                         up(&efivars_lock)

This can be reproduced by concurrent reading of an EFI variable which size
is more than 1024 bytes:

  ts# for cpu in $(seq 0 $(nproc --ignore=1)); do ( taskset -c $cpu \
  cat /sys/firmware/efi/vars/KEKDefault*/size & ) ; done

Fix this by using a local variable for a var's data buffer size so it
does not get overwritten.

Fixes: e14ab23dde12b80d ("efivars: efivar_entry API")
Reported-by: Bob Sanders <bob.sanders@hpe.com> and the LTP testsuite
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200305084041.24053-2-vdronov@redhat.com
Link: https://lore.kernel.org/r/20200308080859.21568-24-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/efivars.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -83,13 +83,16 @@ static ssize_t
 efivar_attr_read(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
+	unsigned long size = sizeof(var->Data);
 	char *str = buf;
+	int ret;
 
 	if (!entry || !buf)
 		return -EINVAL;
 
-	var->DataSize = 1024;
-	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
+	ret = efivar_entry_get(entry, &var->Attributes, &size, var->Data);
+	var->DataSize = size;
+	if (ret)
 		return -EIO;
 
 	if (var->Attributes & EFI_VARIABLE_NON_VOLATILE)
@@ -116,13 +119,16 @@ static ssize_t
 efivar_size_read(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
+	unsigned long size = sizeof(var->Data);
 	char *str = buf;
+	int ret;
 
 	if (!entry || !buf)
 		return -EINVAL;
 
-	var->DataSize = 1024;
-	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
+	ret = efivar_entry_get(entry, &var->Attributes, &size, var->Data);
+	var->DataSize = size;
+	if (ret)
 		return -EIO;
 
 	str += sprintf(str, "0x%lx\n", var->DataSize);
@@ -133,12 +139,15 @@ static ssize_t
 efivar_data_read(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
+	unsigned long size = sizeof(var->Data);
+	int ret;
 
 	if (!entry || !buf)
 		return -EINVAL;
 
-	var->DataSize = 1024;
-	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
+	ret = efivar_entry_get(entry, &var->Attributes, &size, var->Data);
+	var->DataSize = size;
+	if (ret)
 		return -EIO;
 
 	memcpy(buf, var->Data, var->DataSize);
@@ -250,14 +259,16 @@ efivar_show_raw(struct efivar_entry *ent
 {
 	struct efi_variable *var = &entry->var;
 	struct compat_efi_variable *compat;
+	unsigned long datasize = sizeof(var->Data);
 	size_t size;
+	int ret;
 
 	if (!entry || !buf)
 		return 0;
 
-	var->DataSize = 1024;
-	if (efivar_entry_get(entry, &entry->var.Attributes,
-			     &entry->var.DataSize, entry->var.Data))
+	ret = efivar_entry_get(entry, &var->Attributes, &datasize, var->Data);
+	var->DataSize = datasize;
+	if (ret)
 		return -EIO;
 
 	if (in_compat_syscall()) {


