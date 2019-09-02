Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6A20A4FAD
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 09:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbfIBHXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 03:23:18 -0400
Received: from mail.skyhub.de ([5.9.137.197]:59826 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729529AbfIBHXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 03:23:18 -0400
Received: from zn.tnic (p200300EC2F064300254E15554D301ABC.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:4300:254e:1555:4d30:1abc])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2D6AC1EC0B67;
        Mon,  2 Sep 2019 09:23:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1567408997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=vbtmjNkECAAB4ShWXp7lmKBQ4kBd5L/urPWDlTCKZcg=;
        b=Lrlp9G1rKo0o3iGeLwxWbhOFLXkf1Aj7hxnjT73vIIJpRr9ZiFeeX7u/bBhiBLNAd7fNf+
        9xsP77wURf7byYUvBYGWI49eKcZR53jRPys5t3tEpjeczZ/hVt1E2SGGZuEgFjA2ukiNtB
        v6cf8iAhaWE1KXKBSyCCeRSTqcXgcbc=
Date:   Mon, 2 Sep 2019 09:23:10 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     John S Gruber <JohnSGruber@gmail.com>
Cc:     john.hubbard@gmail.com, hpa@zytor.com, jhubbard@nvidia.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2] x86/boot: Fix regression--secure boot info loss from
 bootparam sanitizing
Message-ID: <20190902072310.GA9605@zn.tnic>
References: <20190731054627.5627-2-jhubbard@nvidia.com>
 <CAPotdmSPExAuQcy9iAHqX3js_fc4mMLQOTr5RBGvizyCOPcTQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPotdmSPExAuQcy9iAHqX3js_fc4mMLQOTr5RBGvizyCOPcTQQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 02, 2019 at 12:00:54AM +0200, John S Gruber wrote:
> From: "John S. Gruber" <JohnSGruber@gmail.com>
> 
> commit a90118c445cc ("x86/boot: Save fields explicitly, zero out everything
> else") now zeros the secure boot information passed by the boot loader or
> by the kernel's efi handover mechanism.  Include boot-params.secure_boot
> in the preserve field list.
> 
> I noted a change in my computers between running signed 5.3-rc4 and 5.3-rc6
> with signed kernels using the efi handoff protocol with grub. The kernel
> log message "Secure boot enabled" becomes "Secure boot could not be
> determined". The efi_main function in arch/x86/boot/compressed/eboot.c sets
> this field early but it is subsequently zeroed by the above referenced
> commit in the file arch/x86/include/asm/bootparam_utils.h
> 
> Fixes: commit a90118c445cc ("x86/boot: Save fields explicitly, zero
> out everything else")
> Signed-off-by: John S. Gruber <JohnSGruber@gmail.com>
> ---
> 
> Adjusted the patch for John Hubbard's comments.
> 
>  arch/x86/include/asm/bootparam_utils.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/bootparam_utils.h
> b/arch/x86/include/asm/bootparam_utils.h
> index 9e5f3c7..981fe92 100644
> --- a/arch/x86/include/asm/bootparam_utils.h
> +++ b/arch/x86/include/asm/bootparam_utils.h
> @@ -70,6 +70,7 @@ static void sanitize_boot_params(struct boot_params
> *boot_params)

gmail has managed to chew this patch:

checking file arch/x86/include/asm/bootparam_utils.h
patch: **** malformed patch at line 48: *boot_params)

See: https://www.kernel.org/doc/html/latest/process/email-clients.html#gmail-web-gui

You might find a better client in there if you wanna send more patches
in the future.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
