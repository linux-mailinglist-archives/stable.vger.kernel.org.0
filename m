Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B43160A15
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 06:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgBQFbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 00:31:44 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42863 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgBQFbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 00:31:44 -0500
Received: by mail-wr1-f68.google.com with SMTP id k11so18032204wrd.9
        for <stable@vger.kernel.org>; Sun, 16 Feb 2020 21:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qK8OjVx+UrlFpp7xoUR1rRApkI96TZRdTAo+J2wgjp4=;
        b=IL8t3UqzajJ8X/Va2bVJn/7/EnDmBxTC5T3DlaybGhuCCl//pvqxTZNF0kopfHdzfo
         cjNjQSLU6K3XvbxKh2ZcpySu6e953c3lgMTIHrjTORqzIgjVOkq0nR6aF8JzDAoAaRv9
         o1PGO8RbOgWv3kE0UK6ZzZlMBqm+zCR8upj6HwuMbOu1M+EUztm7RPAG/YPe7gXQ9c/I
         wv/8giNlnCfHC//hrLvzxWBORlf8+ZFMyv/VWbvJp5p8nyNZg32OrBQfuO9FYuYv4Nnk
         EIR6VGo0hLxhF9fWi+ocm2EzMdmGi7hsJWlZGL5ziWzY7xrdu+tR8Ldxz9IMSBCgLAQe
         XyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qK8OjVx+UrlFpp7xoUR1rRApkI96TZRdTAo+J2wgjp4=;
        b=ldYZgdbXPzPWT7vDyYATdqcQDNz3B6VU7pi/oo6qZz6+3Y5o66GNVUX5TlMqviJ3xA
         7PVqmyHiZLeR+9/OFi3n3VfonQavCW5e2Cs2YmRB1WYBhhIqbeKru+dxZZbBhYomeHSk
         jQBwCbvZxKqbykjlYM2wlB0Yxrvwwj66e2LVcm5NKET76zrFDDtlqHKxqY7OTzXHSKeK
         Q79WVAEmApwMf8nnuDa7gG9NMByDfQ5rkKTIgSV1dgPumKCg/7DHees8cti/xNEEu6SJ
         EkzLK3jGqBPG9saU/DRlp0zjb5TQnrEXXbF3R1MH5nYMkmI76l5rS05+MI7CR7J8xtfR
         4NBA==
X-Gm-Message-State: APjAAAUD/sLWGavnuuIz5iZbbJciMtXRuET5/te1MbmiYpwvhROuJsEB
        T8np7iN5nZ0UsYm7svIYHNHbBjuZMPoY0s87bfHg+Q==
X-Google-Smtp-Source: APXvYqxqiMYGPOfmAIxWfpIMpYDldi/Ms8VKDS5YeyS1wS56OJ4kfXS7npV6dhzi2WYsmwLbCS3e32Ft+dyEaXMatgg=
X-Received: by 2002:a05:6000:1289:: with SMTP id f9mr18846622wrx.381.1581917501593;
 Sun, 16 Feb 2020 21:31:41 -0800 (PST)
MIME-Version: 1.0
References: <20200217052847.3174-1-alex@ghiti.fr>
In-Reply-To: <20200217052847.3174-1-alex@ghiti.fr>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 17 Feb 2020 11:01:29 +0530
Message-ID: <CAAhSdy1aXUwCGYK61BeCXd+w-oEyf3=ZJmS+HM0mUxV-Paw-Rg@mail.gmail.com>
Subject: Re: [PATCH] riscv: Fix range looking for kernel image memblock
To:     Alexandre Ghiti <alex@ghiti.fr>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Jan Kiszka <jan.kiszka@web.de>, stable@vger.kernel.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 10:59 AM Alexandre Ghiti <alex@ghiti.fr> wrote:
>
> When looking for the memblock where the kernel lives, we should check
> that the memory range associated to the memblock entirely comprises the
> kernel image and not only intersects with it.
>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  arch/riscv/mm/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 965a8cf4829c..fab855963c73 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -131,7 +131,7 @@ void __init setup_bootmem(void)
>         for_each_memblock(memory, reg) {
>                 phys_addr_t end = reg->base + reg->size;
>
> -               if (reg->base <= vmlinux_end && vmlinux_end <= end) {
> +               if (reg->base <= vmlinux_start && vmlinux_end <= end) {
>                         mem_size = min(reg->size, (phys_addr_t)-PAGE_OFFSET);
>
>                         /*
> --
> 2.20.1
>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup
