Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1D562DD6A
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 15:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbiKQOAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 09:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiKQN77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 08:59:59 -0500
Received: from xry111.site (xry111.site [89.208.246.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FC212616;
        Thu, 17 Nov 2022 05:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1668693594;
        bh=BEJkus9SbXI3rKcbLiusL3L/dHDxpMdZ5fUjakFE5MU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fj+2TDqFTLoW0xpGUKDdR4O0EJmxgcAAhzsN6IWl84bp2UrCUiSCFFj7GsZ6VVtSJ
         TlGzYQSwv885crsUiOzQEkIScGNu2ysES5vM7iRBS+ba0rkZzOPD7nBEMje883XPpc
         eeeWtnq8f3/np6PrlvYOggWTi9TJ4e9bCdDjoc2w=
Received: from localhost.localdomain (xry111.site [IPv6:2001:470:683e::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id ACC0D6692F;
        Thu, 17 Nov 2022 08:59:51 -0500 (EST)
Message-ID: <b1707e1c04a6a9b91fd5f70ea012b5bcc764516e.camel@xry111.site>
Subject: Re: [PATCH 04/47] LoongArch: Set _PAGE_DIRTY only if _PAGE_WRITE is
 set in {pmd,pte}_mkdirty()
From:   Xi Ruoyao <xry111@xry111.site>
To:     Huacai Chen <chenhuacai@loongson.cn>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     loongarch@lists.linux.dev, Xuefeng Li <lixuefeng@loongson.cn>,
        Guo Ren <guoren@kernel.org>, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "David S . Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>
Date:   Thu, 17 Nov 2022 21:59:49 +0800
In-Reply-To: <20221117042532.4064448-1-chenhuacai@loongson.cn>
References: <20221117042532.4064448-1-chenhuacai@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.0 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Huacai,

On Thu, 2022-11-17 at 12:25 +0800, Huacai Chen wrote:
> Now {pmd,pte}_mkdirty() set _PAGE_DIRTY bit unconditionally, this causes
> random segmentation fault after commit 0ccf7f168e17bb7e ("mm/thp: carry
> over dirty bit when thp splits on pmd").

Hmm, the pte_mkdirty call is already removed in commit 624a2c94f5b7a081
("Partly revert \"mm/thp: carry over dirty bit when thp splits on
pmd\"").

Not sure if this issue is related to some random segfaults I've observed
recently though.  My last kernel build contains 0ccf7f168e17bb7e but
does not contain 624a2c94f5b7a081.

>=20
> The reason is: when fork(), parent process use pmd_wrprotect() to clear
> huge page's _PAGE_WRITE and _PAGE_DIRTY (for COW); then pte_mkdirty() set
> _PAGE_DIRTY as well as _PAGE_MODIFIED while splitting dirty huge pages;
> once _PAGE_DIRTY is set, there will be no tlb modify exception so the COW
> machanism fails; and at last memory corruption occurred between parent
> and child processes.
>=20
> So, we should set _PAGE_DIRTY only when _PAGE_WRITE is set in {pmd,pte}_
> mkdirty().
>=20
> Cc: stable@vger.kernel.org
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
> Note: CC sparc maillist because they have similar issues.
> =C2=A0
> =C2=A0arch/loongarch/include/asm/pgtable.h | 8 ++++++--
> =C2=A01 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/includ=
e/asm/pgtable.h
> index 946704bee599..debbe116f105 100644
> --- a/arch/loongarch/include/asm/pgtable.h
> +++ b/arch/loongarch/include/asm/pgtable.h
> @@ -349,7 +349,9 @@ static inline pte_t pte_mkclean(pte_t pte)
> =C2=A0
> =C2=A0static inline pte_t pte_mkdirty(pte_t pte)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pte_val(pte) |=3D (_PAGE_DIRTY=
 | _PAGE_MODIFIED);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pte_val(pte) |=3D _PAGE_MODIFI=
ED;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (pte_val(pte) & _PAGE_WRITE=
)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0pte_val(pte) |=3D _PAGE_DIRTY;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return pte;
> =C2=A0}
> =C2=A0
> @@ -478,7 +480,9 @@ static inline pmd_t pmd_mkclean(pmd_t pmd)
> =C2=A0
> =C2=A0static inline pmd_t pmd_mkdirty(pmd_t pmd)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pmd_val(pmd) |=3D (_PAGE_DIRTY=
 | _PAGE_MODIFIED);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pmd_val(pmd) |=3D _PAGE_MODIFI=
ED;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (pmd_val(pmd) & _PAGE_WRITE=
)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0pmd_val(pmd) |=3D _PAGE_DIRTY;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return pmd;
> =C2=A0}
> =C2=A0

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
