Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 685D1186BEA
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 14:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731219AbgCPNUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 09:20:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41741 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731103AbgCPNUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 09:20:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584364812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DFa8XYNcWCBbwDwtTRIskKgPzP+VYNz/BxcH7Jp2y9g=;
        b=J9k+V8eghWQcghSJ/7HzVtjcQrBGoIIpt1emrl8itq0+fdy0/dLKrpOPcxPw9xR+4eSuBQ
        hf+jkdATMAI4tX2pViapY7i5+Ui1Mwsh1zEJDNDujfBNKNXook+U+kK8pwXzckk7d1TFgs
        +rmSx6VMD0efDc8H8dNDUjEgc10f2yE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-hsRrjO-HMCiYxC03HRUnlA-1; Mon, 16 Mar 2020 09:20:07 -0400
X-MC-Unique: hsRrjO-HMCiYxC03HRUnlA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3B0B8010FE;
        Mon, 16 Mar 2020 13:20:06 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-205-4.brq.redhat.com [10.40.205.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0D465DA81;
        Mon, 16 Mar 2020 13:20:03 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19, 4.14, 4.9, 4.4 1/2] efi: Fix a race and a buffer overflow while reading efivars via sysfs
Date:   Mon, 16 Mar 2020 14:19:37 +0100
Message-Id: <20200316131938.31453-2-vdronov@redhat.com>
In-Reply-To: <20200316131938.31453-1-vdronov@redhat.com>
References: <20200316131938.31453-1-vdronov@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 286d3250c9d6437340203fb64938bea344729a0e upstream.

There is a race and a buffer overflow corrupting a kernel memory while
reading an EFI variable with a size more than 1024 bytes via the older
sysfs method. This happens because accessing struct efi_variable in
efivar_{attr,size,data}_read() and friends is not protected from
a concurrent access leading to a kernel memory corruption and, at best,
to a crash. The race scenario is the following:

CPU0:                                CPU1:
efivar_attr_read()
  var->DataSize =3D 1024;
  efivar_entry_get(... &var->DataSize)
    down_interruptible(&efivars_lock)
                                     efivar_attr_read() // same EFI var
                                       var->DataSize =3D 1024;
                                       efivar_entry_get(... &var->DataSiz=
e)
                                         down_interruptible(&efivars_lock=
)
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

This can be reproduced by concurrent reading of an EFI variable which siz=
e
is more than 1024 bytes:

  ts# for cpu in $(seq 0 $(nproc --ignore=3D1)); do ( taskset -c $cpu \
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

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivar=
s.c
index 3e626fd9bd4e..c8688490f148 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -139,13 +139,16 @@ static ssize_t
 efivar_attr_read(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var =3D &entry->var;
+	unsigned long size =3D sizeof(var->Data);
 	char *str =3D buf;
+	int ret;
=20
 	if (!entry || !buf)
 		return -EINVAL;
=20
-	var->DataSize =3D 1024;
-	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data=
))
+	ret =3D efivar_entry_get(entry, &var->Attributes, &size, var->Data);
+	var->DataSize =3D size;
+	if (ret)
 		return -EIO;
=20
 	if (var->Attributes & EFI_VARIABLE_NON_VOLATILE)
@@ -172,13 +175,16 @@ static ssize_t
 efivar_size_read(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var =3D &entry->var;
+	unsigned long size =3D sizeof(var->Data);
 	char *str =3D buf;
+	int ret;
=20
 	if (!entry || !buf)
 		return -EINVAL;
=20
-	var->DataSize =3D 1024;
-	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data=
))
+	ret =3D efivar_entry_get(entry, &var->Attributes, &size, var->Data);
+	var->DataSize =3D size;
+	if (ret)
 		return -EIO;
=20
 	str +=3D sprintf(str, "0x%lx\n", var->DataSize);
@@ -189,12 +195,15 @@ static ssize_t
 efivar_data_read(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var =3D &entry->var;
+	unsigned long size =3D sizeof(var->Data);
+	int ret;
=20
 	if (!entry || !buf)
 		return -EINVAL;
=20
-	var->DataSize =3D 1024;
-	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data=
))
+	ret =3D efivar_entry_get(entry, &var->Attributes, &size, var->Data);
+	var->DataSize =3D size;
+	if (ret)
 		return -EIO;
=20
 	memcpy(buf, var->Data, var->DataSize);
@@ -314,14 +323,16 @@ efivar_show_raw(struct efivar_entry *entry, char *b=
uf)
 {
 	struct efi_variable *var =3D &entry->var;
 	struct compat_efi_variable *compat;
+	unsigned long datasize =3D sizeof(var->Data);
 	size_t size;
+	int ret;
=20
 	if (!entry || !buf)
 		return 0;
=20
-	var->DataSize =3D 1024;
-	if (efivar_entry_get(entry, &entry->var.Attributes,
-			     &entry->var.DataSize, entry->var.Data))
+	ret =3D efivar_entry_get(entry, &var->Attributes, &datasize, var->Data)=
;
+	var->DataSize =3D datasize;
+	if (ret)
 		return -EIO;
=20
 	if (is_compat()) {
--=20
2.20.1

