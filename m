Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C453DD6A7
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbhHBNLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbhHBNL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 09:11:27 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEABC0617BF
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 06:11:13 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k38-20020a05600c1ca6b029025af5e0f38bso2624008wms.5
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 06:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y+0uaIcI0mf0ejSXXUrubCKbBMCdNsNKojVgct2vGJc=;
        b=byi63PIOkTLrQ3+UVW6t6Nu8bIplNFnTeI8Al2gNkJj/Ntg9CXWWhVqe2Y6WGtrj74
         Zjt2WO0HgkRiXwOm2DP9hu5N+igm0XJwOM52BYAcf2rTDeYhwNOpAT80bBzwkuNlw0dm
         VwiIz+l+w/zRklTygHBpoulOMIPVMDfUD2wl7HDy0F8hEmdzlUAabcdkOEehUB45MTrP
         iEAc+DG+MTBDD483So934wmNTSUVZGKVPgVT/s6va8wV/Zs5HrZZgKxu9QiqSis3XAft
         IqltpSp2l22oHBbjTLkroYFTLhjkAbn+h2gWjiHlqsk28mNjMjLuKEC+rcuSrSrOKtn/
         UPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y+0uaIcI0mf0ejSXXUrubCKbBMCdNsNKojVgct2vGJc=;
        b=jf9hAn8hp0lqw4wnRIidWnOU0L9duO6kFkVPydOc7gYe0Nyyfb3wgVtiMLi6S9u8QE
         CNMlK9oZdqtrtVX7moSFox1mJOWQZ9Q99pnDwJ+2rApwWXaSLfri+nADKsiWT/BkhTYW
         ezbiEnun2Z9604B+bxuNZjzzhJTdgH6bQRdk0Zj5XOoeuR6lTuICe1mANUb9hrIi4mxr
         p+JNwvKxA1IxbqBivpMk8zbNyoYzrDwvw0JzjvPh4RgRqf89ViKzNS75J5d4TckaAZwL
         sdFxtZF2eLrq6Fkj2lulQ7FQyWdsMjpy0G9NcL4Lv+2erOGbKr3oxlfuDG1KFWYjR3Z4
         WzEw==
X-Gm-Message-State: AOAM530wxP/drqawqVB7xlt8pZe8snqv7Lt6uDsXd/KvEAMfj4JpdCMy
        d1+0EjrXk120biBavyNZtt3TKg==
X-Google-Smtp-Source: ABdhPJy6LhSB+zaOl8biQZCLEmpra28+MUW1EPrRJ99jo7BMsfeo2ldRPESQWWEITnMPTAsaU2dASA==
X-Received: by 2002:a1c:4409:: with SMTP id r9mr16799679wma.150.1627909870168;
        Mon, 02 Aug 2021 06:11:10 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:44fe:c9a8:c2b2:3798])
        by smtp.gmail.com with ESMTPSA id d5sm11047663wre.77.2021.08.02.06.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:11:09 -0700 (PDT)
Date:   Mon, 2 Aug 2021 14:11:07 +0100
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] arm64: Move .hyp.rodata outside of the
 _sdata.._edata range
Message-ID: <YQfu6+3uo6qlxrpv@google.com>
References: <20210802123830.2195174-1-maz@kernel.org>
 <20210802123830.2195174-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802123830.2195174-2-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On Monday 02 Aug 2021 at 13:38:29 (+0100), Marc Zyngier wrote:
> The HYP rodata section is currently lumped together with the BSS,
> which isn't exactly what is expected (it gets registered with
> kmemleak, for example).
> 
> Move it away so that it is actually marked RO. As an added
> benefit, it isn't registered with kmemleak anymore.

2d7bf218ca73 ("KVM: arm64: Add .hyp.data..ro_after_init ELF section")
states explicitly that the hyp ro_after_init section should remain RW in
the host as it is expected to modify it before initializing EL2. But I
can't seem to trigger anything with this patch applied, so I'll look
into this a bit more.

> Fixes: 380e18ade4a5 ("KVM: arm64: Introduce a BSS section for use at Hyp")

Not sure this is the patch to blame?

> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org #5.13
> ---
>  arch/arm64/kernel/vmlinux.lds.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index 709d2c433c5e..f6b1a88245db 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -181,6 +181,8 @@ SECTIONS
>  	/* everything from this point to __init_begin will be marked RO NX */
>  	RO_DATA(PAGE_SIZE)
>  
> +	HYPERVISOR_DATA_SECTIONS
> +
>  	idmap_pg_dir = .;
>  	. += IDMAP_DIR_SIZE;
>  	idmap_pg_end = .;
> @@ -260,8 +262,6 @@ SECTIONS
>  	_sdata = .;
>  	RW_DATA(L1_CACHE_BYTES, PAGE_SIZE, THREAD_ALIGN)
>  
> -	HYPERVISOR_DATA_SECTIONS
> -
>  	/*
>  	 * Data written with the MMU off but read with the MMU on requires
>  	 * cache lines to be invalidated, discarding up to a Cache Writeback
> -- 
> 2.30.2

Thanks,
Quentin
