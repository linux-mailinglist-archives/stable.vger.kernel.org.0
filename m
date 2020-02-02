Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89C8E14FCEF
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 12:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgBBLsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 06:48:32 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39286 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgBBLsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Feb 2020 06:48:31 -0500
Received: by mail-wm1-f65.google.com with SMTP id c84so13781489wme.4
        for <stable@vger.kernel.org>; Sun, 02 Feb 2020 03:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Op0zfe58XdVsuLFDv+kV1nCs9niSTB0gzCPSk7DxSPs=;
        b=UGxus0UvDEEJ26RDo6DrWOA2vo37glkXXFSFf+GTlBeShN0snPnY61EzyFpFflbcP6
         1AgXPK07wWXJXS9BGhu9nzE6uaoHggg4jwSLJczzAxLPO33lbgqV07O3Z0jvovl7o3aG
         wfZukZU1s67yckW3jLJ8T1HiFu9IWrptgcPvcztYI2DIypbNNs7/Khp19P0WrNiaFJ+i
         NaK3kdgK6HEBrD0SPfcD98NTFP75FyC/Y2O6ctpqZmqsJZQmYs+BA4mBDxns/msWKpmy
         CqIsb3Ge7I9O09tHPaJpE6Xy7g4dD7HbrfcfSP+nT7X6J9aOXVcCcyVxatvywF3/UN6N
         vpHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Op0zfe58XdVsuLFDv+kV1nCs9niSTB0gzCPSk7DxSPs=;
        b=M6ciGZjh5KrHAo1bXIj4/WMt7YMIgTeUeCf4KVRyTKzZTbty0V60UWb5E7EHRXDy8K
         S1YP72zFcYBrhMOmVSb1LItvTuE/c5w8FN+pizk4+mHCQO/bhjgUxP3TkdRRcyqdrMTn
         /U+65B8sslZoXViAfC1LRmckbiHUUY7WhLnidcQl0g2lp+9eFKofrj/RGi/+mP/MkRNC
         tzRvHdF/3uQ5IpSmIZCN8/IT9WbN0Fp/Ffn8ugbmwBcNPACX4XPGGzCs8NyAVnyOE8co
         8z6tqopWyLjB4rwmBnaRkIiRYLPwiIKbjNsAmo9QtmYt71baa86A2vtlEu+aHAP6sqrO
         tpfg==
X-Gm-Message-State: APjAAAXnFQ9HxGtgG6Z3Ax7yLxilx6+9du5tzZvwVrjoD0gO827rVGEP
        SQrUI7fqMfdKCw3b94S674LurpVAeLUirO4CRQ3u
X-Google-Smtp-Source: APXvYqxq7L4O+L8Zw+nM1sKEx/N3GRXkz3TOVixpfJQrX2G1q0+48Y2iIlYhn2cIHDmMG2e+GnhI1z0A0QWYcaZav2w=
X-Received: by 2002:a05:600c:2113:: with SMTP id u19mr22862304wml.78.1580644110192;
 Sun, 02 Feb 2020 03:48:30 -0800 (PST)
MIME-Version: 1.0
References: <20200202110202.124048-1-anup.patel@wdc.com>
In-Reply-To: <20200202110202.124048-1-anup.patel@wdc.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Sun, 2 Feb 2020 03:48:18 -0800
Message-ID: <CAOnJCU+_CnH6XcXbVrf4LCg3s830n6x6OyWckzoBC-kG2yFpwQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: Don't enable all interrupts in trap_init()
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 2, 2020 at 3:06 AM Anup Patel <anup.patel@wdc.com> wrote:
>
> Historically, we have been enabling all interrupts for each
> HART in trap_init(). Ideally, we should only enable M-mode
> interrupts for M-mode kernel and S-mode interrupts for S-mode
> kernel in trap_init().
>
> Currently, we get suprious S-mode interrupts on Kendryte K210
> board running M-mode NO-MMU kernel because we are enabling all
> interrupts in trap_init(). To fix this, we only enable software
> and external interrupt in trap_init(). In future, trap_init()
> will only enable software interrupt and PLIC driver will enable
> external interrupt using CPU notifiers.
>
> Cc: stable@vger.kernel.org
> Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code)
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
>  arch/riscv/kernel/traps.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
> index f4cad5163bf2..ffb3d94bf0cc 100644
> --- a/arch/riscv/kernel/traps.c
> +++ b/arch/riscv/kernel/traps.c
> @@ -156,6 +156,6 @@ void __init trap_init(void)
>         csr_write(CSR_SCRATCH, 0);
>         /* Set the exception vector address */
>         csr_write(CSR_TVEC, &handle_exception);
> -       /* Enable all interrupts */
> -       csr_write(CSR_IE, -1);
> +       /* Enable interrupts */
> +       csr_write(CSR_IE, IE_SIE | IE_EIE);
>  }
> --
> 2.17.1
>
>

Looks good.
Reviewed-by: Atish Patra <atish.patra@wdc.com>
-- 
Regards,
Atish
