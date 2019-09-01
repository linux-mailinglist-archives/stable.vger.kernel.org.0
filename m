Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37737A4C6A
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 00:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbfIAWA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Sep 2019 18:00:56 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42481 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729031AbfIAWA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Sep 2019 18:00:56 -0400
Received: by mail-qt1-f194.google.com with SMTP id t12so13728992qtp.9;
        Sun, 01 Sep 2019 15:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:in-reply-to:references:date:message-id:subject:to
         :cc;
        bh=UKA15vT+m8YRLmhhsX9/oISzmEZatdOOezmmaqeFIF4=;
        b=jLmisM7gCTaVd7a5Qdlh1z+0evpGnTKGGczuFGB8/eJcpF9oDVzGzMTeQdGyyB/Jhk
         kIoVPu0HQ0X9sKS54vwy3/jGqFmbOaU7ji2cTVsngQoRy1lhoyY+SZJiGxIlOIi/eoxU
         42xp+GP2urIGwezXlVh1zdCp54A9RkrSZ56gCVmhcU2w4JWQrL5bRso7gdpDTlUTR1sb
         Qay+A5L2A3aQdZLnMPVBYCMk+6dyxlUsMKaASuFHz4/ks272LKlSSmmrhdI5mAbrAjJr
         Bz/Fv2izpWKzKjn01+j+Ar/oOMqG0l/qnOFETbZmVKQ5ZuyV08sJSVaCqbVm4r5AY0Nu
         oAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:in-reply-to:references:date
         :message-id:subject:to:cc;
        bh=UKA15vT+m8YRLmhhsX9/oISzmEZatdOOezmmaqeFIF4=;
        b=n1ROAro7OLhZmisDRDs3Z3uVMXDXVK/TiLEr9qRoSF4UvQ+Z1/iN60ik8pFWinmbMH
         pNEjb2wPV8aUh3hMW48ox8p9bsua0PL7cfJdAJzHVqIku3Yc53/ZIMhwzNZLJvoGHgw3
         XJ+woUW5ObHvGQfoiGQmfWwNp2cHDkuaLfNbH5L++DUiK8Ttqz62b+2ig7mHZniOc29r
         FPvESIow4S3CnoVkN9lcgAnsjzaURhABuR7JXrz8hCkFbrMA7k9TeVFSM8Y3NexVB48y
         OlkIEtvJybtagiS1rFnEFfOcMx0XQxwJTmjkIrQdFT94Uo42ENHJlFtQI2zs8Kg+M6Qa
         X1SQ==
X-Gm-Message-State: APjAAAX/frkwNzvNi9gaPyVkgqYphFzl/4ieBbf6h7H8reKmWptM98As
        lejoVpomgFPE8ZyrQ89t7LiiV8jiJmC3LWi2uoY=
X-Google-Smtp-Source: APXvYqw3MR9vAHMqYcjYt/cd5sx035C6fZj0PxGqHfZS7tijA7/1A7jT3dyJjczK8LzjZLrGkbkXoIloLeWmUxdx8Pk=
MIME-Version: 1.0
X-Received: by 2002:ac8:ec9:: with SMTP id w9mr24676918qti.95.1567375254859;
 Sun, 01 Sep 2019 15:00:54 -0700 (PDT)
Received: from 329980741037 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 2 Sep 2019 00:00:54 +0200
From:   John S Gruber <JohnSGruber@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20190731054627.5627-2-jhubbard@nvidia.com>
References: <20190731054627.5627-2-jhubbard@nvidia.com>
Date:   Mon, 2 Sep 2019 00:00:54 +0200
Message-ID: <CAPotdmSPExAuQcy9iAHqX3js_fc4mMLQOTr5RBGvizyCOPcTQQ@mail.gmail.com>
Subject: [PATCH V2] x86/boot: Fix regression--secure boot info loss from
 bootparam sanitizing
To:     john.hubbard@gmail.com
Cc:     "John S. Gruber" <JohnSGruber@gmail.com>, bp@alien8.de,
        hpa@zytor.com, jhubbard@nvidia.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "John S. Gruber" <JohnSGruber@gmail.com>

commit a90118c445cc ("x86/boot: Save fields explicitly, zero out everything
else") now zeros the secure boot information passed by the boot loader or
by the kernel's efi handover mechanism.  Include boot-params.secure_boot
in the preserve field list.

I noted a change in my computers between running signed 5.3-rc4 and 5.3-rc6
with signed kernels using the efi handoff protocol with grub. The kernel
log message "Secure boot enabled" becomes "Secure boot could not be
determined". The efi_main function in arch/x86/boot/compressed/eboot.c sets
this field early but it is subsequently zeroed by the above referenced
commit in the file arch/x86/include/asm/bootparam_utils.h

Fixes: commit a90118c445cc ("x86/boot: Save fields explicitly, zero
out everything else")
Signed-off-by: John S. Gruber <JohnSGruber@gmail.com>
---

Adjusted the patch for John Hubbard's comments.

 arch/x86/include/asm/bootparam_utils.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/bootparam_utils.h
b/arch/x86/include/asm/bootparam_utils.h
index 9e5f3c7..981fe92 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -70,6 +70,7 @@ static void sanitize_boot_params(struct boot_params
*boot_params)
 			BOOT_PARAM_PRESERVE(eddbuf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
+			BOOT_PARAM_PRESERVE(secure_boot),
 			BOOT_PARAM_PRESERVE(hdr),
 			BOOT_PARAM_PRESERVE(e820_table),
 			BOOT_PARAM_PRESERVE(eddbuf),
-- 
2.7.4
