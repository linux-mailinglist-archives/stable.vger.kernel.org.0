Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2121C1BE71B
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 21:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgD2TPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 15:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbgD2TPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Apr 2020 15:15:33 -0400
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09F18221EA;
        Wed, 29 Apr 2020 19:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588187733;
        bh=8zGF7J5vU1aHCP5NVrkZGLyiOLpTgil37hVC6FyH4+g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CjXDKQe50JwPGFFd2wqJPBv40jTi+sCUJ4DaP44BJ0ffo0qDgF4CCT/up//grV+1X
         H5XHXUf7VrgTddw49+fLsdqZbguhhBESE0/5YGZddRYiqx0Jo97WEX7mbcnqbaWpIj
         irEoW5bcty8tZMIKiOKqEusZ2LpinmUtT10U5WJk=
Received: by mail-il1-f173.google.com with SMTP id e8so3553189ilm.7;
        Wed, 29 Apr 2020 12:15:33 -0700 (PDT)
X-Gm-Message-State: AGi0PuZ+ljW/oxfpWo3Ry1qNXMbP9fExAPCpODxbdV1xTPROcNRtUrjN
        ziOtRoYc71d5kEzDvg2Wgph/EW9B0BM7lyV2qT4=
X-Google-Smtp-Source: APiQypJsnlAvQfc7irLT1YgR+mCRIPtINI2GxAyyU6DQsDAhz6atG1lWYITEEV+JOjR4au3GhCYE9ARuvXzpnDuZRd8=
X-Received: by 2002:a92:39dd:: with SMTP id h90mr4677889ilf.80.1588187732438;
 Wed, 29 Apr 2020 12:15:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200429190119.43595-1-arnd@arndb.de>
In-Reply-To: <20200429190119.43595-1-arnd@arndb.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 29 Apr 2020 21:15:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE4DSOhN7+ydGytHwOCn+L=0VoxW4T76ERL8+_fjyNj7A@mail.gmail.com>
Message-ID: <CAMj1kXE4DSOhN7+ydGytHwOCn+L=0VoxW4T76ERL8+_fjyNj7A@mail.gmail.com>
Subject: Re: [PATCH] efi/tpm: fix section mismatch warning
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
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
        linux-efi <linux-efi@vger.kernel.org>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 29 Apr 2020 at 21:02, Arnd Bergmann <arnd@arndb.de> wrote:
>
> Building with gcc-10 causes a harmless warning about a section mismatch:
>
> WARNING: modpost: vmlinux.o(.text.unlikely+0x5e191): Section mismatch in reference from the function tpm2_calc_event_log_size() to the function .init.text:early_memunmap()
> The function tpm2_calc_event_log_size() references
> the function __init early_memunmap().
> This is often because tpm2_calc_event_log_size lacks a __init
> annotation or the annotation of early_memunmap is wrong.
>
> Add the missing annotation.
>
> Fixes: e658c82be556 ("efi/tpm: Only set 'efi_tpm_final_log_size' after successful event log parsing")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, I'll take it as a fix.

> ---
>  drivers/firmware/efi/tpm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
> index 31f9f0e369b9..55b031d2c989 100644
> --- a/drivers/firmware/efi/tpm.c
> +++ b/drivers/firmware/efi/tpm.c
> @@ -16,7 +16,7 @@
>  int efi_tpm_final_log_size;
>  EXPORT_SYMBOL(efi_tpm_final_log_size);
>
> -static int tpm2_calc_event_log_size(void *data, int count, void *size_info)
> +static int __init tpm2_calc_event_log_size(void *data, int count, void *size_info)
>  {
>         struct tcg_pcr_event2_head *header;
>         int event_size, size = 0;
> --
> 2.26.0
>
