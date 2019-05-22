Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D382926A84
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbfEVTGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:06:32 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43717 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbfEVTGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 15:06:31 -0400
Received: by mail-pf1-f196.google.com with SMTP id c6so1802262pfa.10
        for <stable@vger.kernel.org>; Wed, 22 May 2019 12:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=O4Lgy1HcDOlUdiimGp2mC8htfWd2dmb5LrsCRVE8Lzs=;
        b=mLr4J9nClYarpjN5MzkiEhH4pl94lMa15pd0qF/2gb5OwX04Fwez3+qqXuC/IrOumt
         sfZxpGIvjT6zCsgWfG/MHMcPXQiQzrU8PUW3j658UWaYRrS5DPqt1pclF/Jj9m538ua0
         P7qWxYBs9hV3rPZcx7SoNQFttEbuEC/9/5Eg52Z4bfRF08k8SiPrHDEMXXS3fYzJDfVi
         UdWn1mYYu9J1d8JEK0Gz35ZEIg8IInp9L0uYfjy4iAuLkKvp/xOPImGODFtiHSe5oIzu
         qWZLsmLwtUL1pKTqF6XG7tHZMWiAyiTFLHOA7p9X2zG2RbXFFkIORQ+WNr/v/bIzElE4
         fZ+w==
X-Gm-Message-State: APjAAAVh0y0S4ckEe8cgqWYgxYd2pk7Es6Rnkpi/gRP2aKFAmj0tNtW/
        iaV3h5qnbJJTMtMrNr80l5lpWw==
X-Google-Smtp-Source: APXvYqx3m27s+HcebvdxF5BSCwSO57+wNPviNkWwWa2QOpfHVB/hCT5TN1uBIIvmgbIo6CL6lv7v7A==
X-Received: by 2002:a62:14d6:: with SMTP id 205mr97781058pfu.4.1558551990575;
        Wed, 22 May 2019 12:06:30 -0700 (PDT)
Received: from localhost (70-35-37-12.static.wiline.com. [70.35.37.12])
        by smtp.gmail.com with ESMTPSA id q4sm29383798pgb.39.2019.05.22.12.06.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 12:06:29 -0700 (PDT)
Date:   Wed, 22 May 2019 12:06:29 -0700 (PDT)
X-Google-Original-Date: Wed, 22 May 2019 11:59:30 PDT (-0700)
Subject:     Re: [PATCH 11/18] locking/atomic: riscv: fix atomic64_sub_if_positive() offset argument
In-Reply-To: <20190522132250.26499-12-mark.rutland@arm.com>
CC:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        Will Deacon <will.deacon@arm.com>, aou@eecs.berkeley.edu,
        Arnd Bergmann <arnd@arndb.de>, bp@alien8.de,
        catalin.marinas@arm.com, davem@davemloft.net, fenghua.yu@intel.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        ink@jurassic.park.msu.ru, jhogan@kernel.org, linux@armlinux.org.uk,
        mark.rutland@arm.com, mattst88@gmail.com, mingo@kernel.org,
        mpe@ellerman.id.au, paul.burton@mips.com, paulus@samba.org,
        ralf@linux-mips.org, rth@twiddle.net, stable@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, vgupta@synopsys.com
From:   Palmer Dabbelt <palmer@sifive.com>
To:     mark.rutland@arm.com
Message-ID: <mhng-07aca7a6-5b81-401d-9f0a-438fcd9aef43@palmer-si-x1e>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 22 May 2019 06:22:43 PDT (-0700), mark.rutland@arm.com wrote:
> Presently the riscv implementation of atomic64_sub_if_positive() takes
> a 32-bit offset value rather than a 64-bit offset value as it should do.
> Thus, if called with a 64-bit offset, the value will be unexpectedly
> truncated to 32 bits.
>
> Fix this by taking the offset as a long rather than an int.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Palmer Dabbelt <palmer@sifive.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/riscv/include/asm/atomic.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/atomic.h b/arch/riscv/include/asm/atomic.h
> index 93826771b616..c9e18289d65c 100644
> --- a/arch/riscv/include/asm/atomic.h
> +++ b/arch/riscv/include/asm/atomic.h
> @@ -336,7 +336,7 @@ static __always_inline int atomic_sub_if_positive(atomic_t *v, int offset)
>  #define atomic_dec_if_positive(v)	atomic_sub_if_positive(v, 1)
>
>  #ifndef CONFIG_GENERIC_ATOMIC64
> -static __always_inline long atomic64_sub_if_positive(atomic64_t *v, int offset)
> +static __always_inline long atomic64_sub_if_positive(atomic64_t *v, long offset)
>  {
>         long prev, rc;

Reviewed-by: Palmer Dabbelt <palmer@sifive.com>

Thanks!
