Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA4D1CA80C
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 12:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgEHKPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 06:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgEHKPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 06:15:19 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B4BC05BD43;
        Fri,  8 May 2020 03:15:18 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g12so9992848wmh.3;
        Fri, 08 May 2020 03:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mH4zcj4jAFO6of/XHBeCHGTKbSV21AdNuIYsxQykbg0=;
        b=pDdlmsdZ8CkNvrQbbd4GjumxAzozSa2oP2fF1wBBFwzTGatcplKgpfDIqVQipqpecq
         4N9xuoN0ltj8m4CzfaDwc8g84ygpzkzAuddOyYBpIfvI8sy+5KAmizrto8RteRINems4
         Hy2XgXTNbdv9qFolyPghf1DVtzIieYcGZJitGh3HtL5CuLGvsuO/kl8wpLxVczKdS/r4
         WDJY3AE/TGyhu5uAgteiM9DqFuWZjZgd02ddFHImczuHt0kYfUPCBJ80KiI0OmqQLage
         8QlpThHUPyLS4+b5aAr5XiRyvoM3EtOZIz9XJ3nL6HFEsX4yNdiUgbNY8dNCFcNnuZmU
         9mvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mH4zcj4jAFO6of/XHBeCHGTKbSV21AdNuIYsxQykbg0=;
        b=XV0t9Zw31oZW3U5OBqr1j7tNBp8UWkATk/UCLm4eioFvNhMT2s6R4OtuZi2iKN7TPl
         +qsq0BlUvoih4KG2/nO9WiYT2xRlFMrYLLjEZCKJTDzkRt9LdnXlixLqlZQMm5Pifp24
         jTAX/jE5Om2j77EYJ0TY1FroWFBFgDFctoEl2it26clSbMkqrCgi4KFUy/AuDL3Pq2H+
         9xVIfkwvnMBnxpLVIYFgR8GXZIIek8bdoskY+ux7qLIX1BvLuAgpz6WcVi+0bmQUsII3
         Bb32awTr/aMRTTgen13QBAy2HFCHDfqSyArtHEeb17C95qnhvwC2W4cLQPK8CZuiDT22
         gVcg==
X-Gm-Message-State: AGi0PuaTyWPwErykeO7U6UG+lnW/fOw149d0WRtsJd0h5bYCGEirre08
        mHp39+4CojbcEshFlT6QoCmSU4BPDKEdkVL3Sck=
X-Google-Smtp-Source: APiQypIREaQqmfF7+C8yUOxOZSymcWKhbwxCIVdrJyeSmilFqo7y6mn+Or2O1brlhklUlY5+b0V7MLT3rhV4/VuubS0=
X-Received: by 2002:a7b:c190:: with SMTP id y16mr16390070wmi.50.1588932916746;
 Fri, 08 May 2020 03:15:16 -0700 (PDT)
MIME-Version: 1.0
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com> <1588500367-1056-3-git-send-email-chenhc@lemote.com>
In-Reply-To: <1588500367-1056-3-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Fri, 8 May 2020 12:14:40 +0200
Message-ID: <CAHiYmc44B4e1PZXoyhBGy_AizLbbOrScPg2w=tZT1OPsnVcuUA@mail.gmail.com>
Subject: Re: [PATCH V3 02/14] KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
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

=D0=BD=D0=B5=D0=B4, 3. =D0=BC=D0=B0=D1=98 2020. =D1=83 12:07 Huacai Chen <c=
henhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> From: Xing Li <lixing@loongson.cn>
>
> If a CPU support more than 32bit vmbits (which is true for 64bit CPUs),
> VPN2_MASK set to fixed 0xffffe000 will lead to a wrong EntryHi in some
> functions such as _kvm_mips_host_tlb_inv().
>
> The cpu_vmbits definition of 32bit CPU in cpu-features.h is 31, so we
> still use the old definition.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Xing Li <lixing@loongson.cn>
> [Huacai: Improve commit messages]
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/include/asm/kvm_host.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm=
_host.h
> index a01cee9..caa2b936 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -274,7 +274,11 @@ enum emulation_result {
>  #define MIPS3_PG_SHIFT         6
>  #define MIPS3_PG_FRAME         0x3fffffc0
>
> +#if defined(CONFIG_64BIT)
> +#define VPN2_MASK              GENMASK(cpu_vmbits - 1, 13)
> +#else
>  #define VPN2_MASK              0xffffe000
> +#endif
>  #define KVM_ENTRYHI_ASID       cpu_asid_mask(&boot_cpu_data)
>  #define TLB_IS_GLOBAL(x)       ((x).tlb_lo[0] & (x).tlb_lo[1] & ENTRYLO_=
G)
>  #define TLB_VPN2(x)            ((x).tlb_hi & VPN2_MASK)
> --
> 2.7.0
>

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
