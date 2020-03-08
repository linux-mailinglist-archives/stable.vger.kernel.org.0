Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 999CA17D4E4
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 17:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgCHQio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 12:38:44 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56802 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgCHQio (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Mar 2020 12:38:44 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jAywj-0007V2-NC; Sun, 08 Mar 2020 17:38:33 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 5E1351C221D;
        Sun,  8 Mar 2020 17:38:33 +0100 (CET)
Date:   Sun, 08 Mar 2020 16:38:33 -0000
From:   "tip-bot2 for Vladis Dronov" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi: Fix a race and a buffer overflow while reading
 efivars via sysfs
Cc:     Bob Sanders <bob.sanders@hpe.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, <stable@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200305084041.24053-2-vdronov@redhat.com>
References: <20200305084041.24053-2-vdronov@redhat.com>
MIME-Version: 1.0
Message-ID: <158368551309.28353.6521114137797916495.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     286d3250c9d6437340203fb64938bea344729a0e
Gitweb:        https://git.kernel.org/tip/286d3250c9d6437340203fb64938bea344729a0e
Author:        Vladis Dronov <vdronov@redhat.com>
AuthorDate:    Sun, 08 Mar 2020 09:08:54 +01:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Sun, 08 Mar 2020 09:56:34 +01:00

efi: Fix a race and a buffer overflow while reading efivars via sysfs

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
---
 drivers/firmware/efi/efivars.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 7576450..69f13bc 100644
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
@@ -250,14 +259,16 @@ efivar_show_raw(struct efivar_entry *entry, char *buf)
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
