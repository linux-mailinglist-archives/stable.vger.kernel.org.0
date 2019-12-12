Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFAF111CACF
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 11:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfLLKcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 05:32:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33099 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728575AbfLLKcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 05:32:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576146728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P9Dh2S27/TULqQS9Vj4g94fO/JhD3/K1HM2qzjZTtcQ=;
        b=HX9e1VGyirxJhOr09nS765e6eJZ3lN3nJDInHF5mGRHe7ueKf0QBBzYrJ2aMwHGVYYGUi0
        sokECCVOrbBGMyeAMyuk9+s4ym1yTNmRh4PLcPdbpoYx/aWya4sx4UBQJFNYgvA3w08rDn
        aVMsHpZswptS3SLwPceyTTG1K0T6osw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-SYkBUYFRM5ey7kpHtb5voA-1; Thu, 12 Dec 2019 05:32:07 -0500
X-MC-Unique: SYkBUYFRM5ey7kpHtb5voA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D59651005502;
        Thu, 12 Dec 2019 10:32:05 +0000 (UTC)
Received: from shalem.localdomain.com (unknown [10.36.118.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E5A918779;
        Thu, 12 Dec 2019 10:32:04 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 5.5 regression fix 2/2] efi/libstub/helper: Initialize pointer variables to zero for mixed mode
Date:   Thu, 12 Dec 2019 11:31:58 +0100
Message-Id: <20191212103158.4958-3-hdegoede@redhat.com>
In-Reply-To: <20191212103158.4958-1-hdegoede@redhat.com>
References: <20191212103158.4958-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When running in EFI mixed mode (running a 64 bit kernel on 32 bit EFI
firmware), we _must_ initialize any pointers which are returned by
reference by an EFI call to NULL before making the EFI call.

In mixed mode pointers are 64 bit, but when running on a 32 bit firmware,
EFI calls which return a pointer value by reference only fill the lower
32 bits of the passed pointer, leaving the upper 32 bits uninitialized
unless we explicitly set them to 0 before the call.

We have had this bug in the efi-stub-helper.c file reading code for
a while now, but this has likely not been noticed sofar because
this code only gets triggered when LILO style file=3D... arguments are
present on the kernel cmdline.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/fir=
mware/efi/libstub/efi-stub-helper.c
index e02579907f2e..6ca7d86743af 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -365,7 +365,7 @@ static efi_status_t efi_file_size(efi_system_table_t =
*sys_table_arg, void *__fh,
 				  u64 *file_sz)
 {
 	efi_file_handle_t *h, *fh =3D __fh;
-	efi_file_info_t *info;
+	efi_file_info_t *info =3D NULL;
 	efi_status_t status;
 	efi_guid_t info_guid =3D EFI_FILE_INFO_ID;
 	unsigned long info_sz;
@@ -527,7 +527,7 @@ efi_status_t handle_cmdline_files(efi_system_table_t =
*sys_table_arg,
 				  unsigned long *load_addr,
 				  unsigned long *load_size)
 {
-	struct file_info *files;
+	struct file_info *files =3D NULL;
 	unsigned long file_addr;
 	u64 file_size_total;
 	efi_file_handle_t *fh =3D NULL;
--=20
2.23.0

