Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766C41BE6DD
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 21:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgD2TCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 15:02:03 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:44269 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgD2TCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 15:02:03 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MUY9w-1jcdPt3kW0-00QWZG; Wed, 29 Apr 2020 21:01:22 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Ard Biesheuvel <ardb@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Dave Young <dyoung@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>, Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Peter Jones <pjones@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Talbert <swt@techie.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] efi/tpm: fix section mismatch warning
Date:   Wed, 29 Apr 2020 21:01:08 +0200
Message-Id: <20200429190119.43595-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ZQnTjnUaD3Ot3Nx9eVP2/03GaU0JA4GRDpusvqc79KiO4fUHV7z
 xbCc99Kr8a1zJJE/r4bO0Q47fh+gOYXqvMEruI2hqCMZW/f96D/07cYwGJnjvGbRf0QYvGa
 AMxgwBy1kWiVvyyalES1BaAtiU6NPyGlrSvjv+GzdcJsq9wtDZIW17AmoNdVJMst0obhgPq
 ZtBIEXgn3++a0vuwB8Rrg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:eoASaEfANZA=:UKYNanq8Tate2hME67jf0h
 HFfVw5eEnAwV2ivqhWR10qdqEdCv1a/qH6+I1GUsQxdb5fSJg2p6lrkbKfR5fE+VkR1jStuAE
 vdlwseanNyzYnYPr/IK92xAXWRJsKbD8hzPQy+wW4OCnLKAu4mr7PZVANZ/2Vvyw9aAo+/kfv
 HOGPCihZSJ5NHcXqDB4sMDZnWEx4EFDNwPRN2zlmFMkWQpEt7qNQxV7Cko6eYgRTKPFKYw8ug
 luD8JtZccLzQ1F614k8UJnfxA/4Hm/lf2RrzFDzl6skwPh2C533wIsyYwh0kdjZb925DZIviL
 qkk+iKL0wG19l3fDIu8L5nKkjz4FqOV6qe3lbbV3PwZcZyF6EAdLuLHI+WtqQRHQaK42K36k+
 vfTQhNM6n1RRXh4GU4SDRXXr7rs1Q0+X2ygEeFZZ2zPdtMf1IbrvSIoI0b6eukMM7JuKCYGoR
 62odyLSl1Mh+mEkFX9rq7IILGbbNuIM8m0xGW5OXbdVwgccDWLRwFPS48XvKePoM6uvfFIrJe
 VWLVZP99LysMhyAwj6vAP8nM1xuHPt0oYb2Z38d6GUZIpbo0VrQyqElgoNlHkXWgHoBvdu7Sy
 ssYDxqMdy3rDwOas9hhs04+3fSHEDkxcdkLIQdI3TfBNoYO10BFb52q5HynGfHvlBS7HypmOp
 Xzy8IVQOlKP42yNGNIXWOOq745r7tsoZOtd4hlQlnBd4bZf3bCZRVi8uBfE7NefGf3vG145yF
 VH/3/ipt6Udrv4zPUIsxu7sC36zEbaKDVaR9OxAi+Kdh25JO5JtPuaitxehAnkJSWdPU9BHAg
 hEn5TMsMst+vMlNCOwANobfLlaTMcLgSm+Prswy1rgbevxfr9U=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Building with gcc-10 causes a harmless warning about a section mismatch:

WARNING: modpost: vmlinux.o(.text.unlikely+0x5e191): Section mismatch in reference from the function tpm2_calc_event_log_size() to the function .init.text:early_memunmap()
The function tpm2_calc_event_log_size() references
the function __init early_memunmap().
This is often because tpm2_calc_event_log_size lacks a __init
annotation or the annotation of early_memunmap is wrong.

Add the missing annotation.

Fixes: e658c82be556 ("efi/tpm: Only set 'efi_tpm_final_log_size' after successful event log parsing")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/firmware/efi/tpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index 31f9f0e369b9..55b031d2c989 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -16,7 +16,7 @@
 int efi_tpm_final_log_size;
 EXPORT_SYMBOL(efi_tpm_final_log_size);
 
-static int tpm2_calc_event_log_size(void *data, int count, void *size_info)
+static int __init tpm2_calc_event_log_size(void *data, int count, void *size_info)
 {
 	struct tcg_pcr_event2_head *header;
 	int event_size, size = 0;
-- 
2.26.0

