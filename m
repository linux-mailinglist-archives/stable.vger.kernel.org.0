Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485A6179C3B
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 00:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388473AbgCDXQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 18:16:32 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37045 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388468AbgCDXQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 18:16:32 -0500
Received: by mail-pl1-f196.google.com with SMTP id b8so1741754plx.4
        for <stable@vger.kernel.org>; Wed, 04 Mar 2020 15:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=fLuBSubRkGwc0et1lSwg/yOrJz68JCULXi64QxtD9L4=;
        b=Zfx3aZDHOKJv/xTct7dFMPFiJ5RG5nooZwf3B1Md2rdmwylu/vxshgKBxR/JXzh0tD
         ILxZPjvmXfQO/SuH/N0qK07KCfDtfALyxDCCZFxc2B5oaT8B5uCN1n5MIE8fM8Pw8OYT
         fyBlEUvLtcv7XvQQPzrsehVW9nxkUUlJnBnnBg4nPiFsqZpRmv0BIeAtS5xWy3bAUkK7
         EKOTDIA9tusMsoUyU23lmsiRUAutFyFaC9sPkiymBzoqkhA8m2XNEP5ACMQ87Dr1K9L7
         UhONoltdyIcJ0bCTJjQ6f3GbWTkvgcWNwd2jDPQLNNTAck6BZB9ffrWTJncrYXc7y5EN
         rk3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=fLuBSubRkGwc0et1lSwg/yOrJz68JCULXi64QxtD9L4=;
        b=NxfuMAoW8O1s/jJbtaLKiGpFZyXOxLlBM677NAmO66lAzA5LeJZmWNBynjR6mGE8gU
         7zF2XA+eHmC/Nhu6oPLNvl365EGGB8jhPoPEbbGxa0xTY3/PXofeoFBC3bQCdGgXjGpk
         CgplecEZVkJ3HySE1BYnIb+uSpIrIaGzmO3wPe9seKeU1SjXkTMfmFauwVNRCBsYlVmq
         /JXiAYUU0h5pgGmRN0+ZRenF5ibAFusgUPMZlXjMXGHjBezge49pkIP0iS+EbodxJUc3
         w3D5XdoT1MsWwIAVxecsQ1B5QeChsT3kN6jamgmfDz6YN9Uxn/cpG1g38xUYnGEcvItQ
         fu+Q==
X-Gm-Message-State: ANhLgQ3JsPT6rX/Kg4xJrCcqZXN55IYYkfGjYoicK6SzRJWHsrdK4Xz2
        HSY61AMaJOa2Ha7YpGYHhyA48w==
X-Google-Smtp-Source: ADFU+vs16bwXQpjbdGTb2gdRF0APKsg86dgJcOqt7o9kJ87t5Lecc5fFkxXvGGtSwPqdwC/b2hv4bg==
X-Received: by 2002:a17:90a:1f45:: with SMTP id y5mr5271710pjy.170.1583363791341;
        Wed, 04 Mar 2020 15:16:31 -0800 (PST)
Received: from localhost ([2620:0:1000:2514:23a5:d584:6a92:3e3c])
        by smtp.gmail.com with ESMTPSA id c5sm29203530pfi.10.2020.03.04.15.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 15:16:30 -0800 (PST)
Date:   Wed, 04 Mar 2020 15:16:30 -0800 (PST)
X-Google-Original-Date: Wed, 04 Mar 2020 15:10:33 PST (-0800)
Subject:     Re: [PATCH] riscv: Fix range looking for kernel image memblock
In-Reply-To: <20200217052847.3174-1-alex@ghiti.fr>
CC:     Paul Walmsley <paul.walmsley@sifive.com>, anup@brainfault.org,
        jan.kiszka@web.de, stable@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        alex@ghiti.fr
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     alex@ghiti.fr
Message-ID: <mhng-2ab0d9dd-182f-4c81-8432-5d510cd3dd51@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 16 Feb 2020 21:28:47 PST (-0800), alex@ghiti.fr wrote:
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
>  	for_each_memblock(memory, reg) {
>  		phys_addr_t end = reg->base + reg->size;
>
> -		if (reg->base <= vmlinux_end && vmlinux_end <= end) {
> +		if (reg->base <= vmlinux_start && vmlinux_end <= end) {
>  			mem_size = min(reg->size, (phys_addr_t)-PAGE_OFFSET);
>
>  			/*

Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>

Thanks.  I'm going to target this for the next RC.
