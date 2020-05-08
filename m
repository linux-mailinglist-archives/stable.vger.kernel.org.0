Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F211CA7E5
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 12:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgEHKGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 06:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgEHKGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 06:06:10 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A71C05BD43;
        Fri,  8 May 2020 03:06:08 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e26so9612811wmk.5;
        Fri, 08 May 2020 03:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T5xlC7qPnScxdD8HfkPXyyRLvRSedibj7CnwraNl2wo=;
        b=ligq+n587Hx4n2gUCiSweXFiBtq9wqtVWw1i94hYEQuOFEwLOzUK2AqmeVJrfk8Xwm
         OkUUqBsbITm5nSRLWTuoYJH8LK++ZXDlh/mMFJru9ZlE4aSDvc4n/1XUyX6E/laKqPHM
         HF6FlZcKWLpjuxB+hrneX4v5zBJJTYl9dcEWqejyAp66TdRRd/tn/4Ki17LF+GkNnyWr
         QrmgmoCAiKaCdpI7Y5kKIKzCk2S6uszGqOo5IKQ0EL/s+xrvUBxzDHH+gtBqmXBVybMv
         KiO4s4CMfm3YBwMRgD+keUeWzHZTHQDS6H+2uuqgURebT7cE1ugO4fEZs2SM46p2ZLvm
         YxQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T5xlC7qPnScxdD8HfkPXyyRLvRSedibj7CnwraNl2wo=;
        b=SC5SXJ37rl7xBBYGDziRHtuBijcfT/L0CXGdQK4emYw6ekVBbKMdPV+XxeOEkYv1rT
         ZZuokyTFrwQrQkVtGUIfAEB+b5zUnN8ocoiXHPmhpHODt9fjGVSBYmnHsffPwnAlYK4M
         fz6FKCqFScn4/gY54CFYNKSdHClmJst0YmByTHfyxY9SbTxRvkXoonlVnWv/p+pJV6wA
         whMhJapyMau9+NPMXnLY9qFIasKePtBjng+dm5aXLd/ehFi1//WQlmXb41ZXyzbC+eTQ
         Ps1kjahN+1Zz5ZpQllB0uDDBihIxixdWbzHYiMwjiQbK9s0y+SUZ1M0ftgXJjMiQL29z
         y2IQ==
X-Gm-Message-State: AGi0PubJsf44Intj6Ja2NvzRMf+011Vuc+40Lq7rMMVVihrjkcnP6ssi
        0j2mTbYmzMhl2Cvnuix7qYfgVF3qXgqZzN47+TQ=
X-Google-Smtp-Source: APiQypITeNK+k5wXCOBAFXPWVcF9IAiL/o64wDX9ljR63w3WxyhEA1CStyUedfLaHR+RNHQCtwr8y258jLkSDvBRBPA=
X-Received: by 2002:a7b:c74d:: with SMTP id w13mr14758749wmk.36.1588932366832;
 Fri, 08 May 2020 03:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com> <1588500367-1056-2-git-send-email-chenhc@lemote.com>
In-Reply-To: <1588500367-1056-2-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Fri, 8 May 2020 12:05:33 +0200
Message-ID: <CAHiYmc41JQ+H+D6rsot34gDoKG1dsyFWCcs_FbuA2neAgReaOw@mail.gmail.com>
Subject: Re: [PATCH V3 01/14] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        linux-mips@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Xing Li <lixing@loongson.cn>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=D0=BD=D0=B5=D0=B4, 3. =D0=BC=D0=B0=D1=98 2020. =D1=83 12:06 Huacai Chen <c=
henhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> From: Xing Li <lixing@loongson.cn>
>
> The code in decode_config4() of arch/mips/kernel/cpu-probe.c
>
>         asid_mask =3D MIPS_ENTRYHI_ASID;
>         if (config4 & MIPS_CONF4_AE)
>                 asid_mask |=3D MIPS_ENTRYHI_ASIDX;
>         set_cpu_asid_mask(c, asid_mask);
>
> set asid_mask to cpuinfo->asid_mask.
>
> So in order to support variable ASID_MASK, KVM_ENTRYHI_ASID should also
> be changed to cpu_asid_mask(&boot_cpu_data).
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Xing Li <lixing@loongson.cn>
> [Huacai: Change current_cpu_data to boot_cpu_data for optimization]
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/include/asm/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

For what is worth:

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>

> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm=
_host.h
> index 2c343c3..a01cee9 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -275,7 +275,7 @@ enum emulation_result {
>  #define MIPS3_PG_FRAME         0x3fffffc0
>
>  #define VPN2_MASK              0xffffe000
> -#define KVM_ENTRYHI_ASID       MIPS_ENTRYHI_ASID
> +#define KVM_ENTRYHI_ASID       cpu_asid_mask(&boot_cpu_data)
>  #define TLB_IS_GLOBAL(x)       ((x).tlb_lo[0] & (x).tlb_lo[1] & ENTRYLO_=
G)
>  #define TLB_VPN2(x)            ((x).tlb_hi & VPN2_MASK)
>  #define TLB_ASID(x)            ((x).tlb_hi & KVM_ENTRYHI_ASID)
> --
> 2.7.0
>
