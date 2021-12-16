Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF45A476ABE
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 08:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbhLPHEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 02:04:20 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.23]:26067 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbhLPHEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 02:04:20 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Dec 2021 02:04:19 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1639637895;
    s=strato-dkim-0002; d=goldelico.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=H1ZO+bF3QtNX7xgpf5VMMCpz3zPghhaf4POCn8UFfL4=;
    b=Js3ye/sjPYMCHmKot9mBmDgO5cSHG/cK02WXFWUrbJTegPC6E2JFFBNfjTsjBHIp+2
    2acO89SQAmKO7jMvpv9wNFHwlqo99Tn/S0Yq4C7ntQZ/fKCbyjdMRtAnd6loNXs3iXGL
    9OjXgiOjAc/u7ZoQnIIdVX216sVdl2szM3Kd+bxv20pvqLetVYG7tvhCCM7/ttP2Doeh
    AI6ijDAptl4QmwoYfkBR5s2Vr0KqDsuqPuyHtvhUlzpWPwYFbuK/Q9ny77Dw/FtRl4vn
    jgeF1GywJ1U0yzHsdDRG/HtB4Le6gf/9aNnwnk1UR7tfcrYWFdLhcDVu2Yyx44dkaLbr
    ce1Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7gpw91N5y2S3iMMUrw=="
X-RZG-CLASS-ID: mo00
Received: from mbp-13-nikolaus.fritz.box
    by smtp.strato.de (RZmta 47.35.3 DYNA|AUTH)
    with ESMTPSA id 404833xBG6wFBug
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Thu, 16 Dec 2021 07:58:15 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.21\))
Subject: Re: Bug with KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2
 and CPTR_EL2 to 1
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <DB8835B4-8F04-4669-87EA-D348FA47A79D@goldelico.com>
Date:   Thu, 16 Dec 2021 07:58:14 +0100
Cc:     Discussions about the Letux Kernel <letux-kernel@openphoenux.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8C04B3CF-4B26-4EA1-B6BD-A7AB30078FCE@goldelico.com>
References: <DB8835B4-8F04-4669-87EA-D348FA47A79D@goldelico.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Chris January <Chris.January@arm.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        reg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3445.104.21)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Catalin,

> Am 15.12.2021 um 19:40 schrieb H. Nikolaus Schaller =
<hns@goldelico.com>:
>=20
> this seems to break build of 5.10.y (and maybe earlier) for me:
>=20
>  CALL    scripts/checksyscalls.sh - due to target missing
>  CALL    scripts/atomic/check-atomics.sh - due to target missing
>  CHK     include/generated/compile.h
>  AS      arch/arm64/kvm/hyp/nvhe/hyp-init.nvhe.o - due to target =
missing
> arch/arm64/kvm/hyp/nvhe/hyp-init.S: Assembler messages:
> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: unexpected characters =
following instruction at operand 2 -- `mov x1,#((1U<<31)|(1<<23))'
> arch/arm64/kvm/hyp/nvhe/Makefile:28: recipe for target =
'arch/arm64/kvm/hyp/nvhe/hyp-init.nvhe.o' failed
> make[5]: *** [arch/arm64/kvm/hyp/nvhe/hyp-init.nvhe.o] Error 1
> scripts/Makefile.build:497: recipe for target =
'arch/arm64/kvm/hyp/nvhe' failed
> make[4]: *** [arch/arm64/kvm/hyp/nvhe] Error 2
> scripts/Makefile.build:497: recipe for target 'arch/arm64/kvm/hyp' =
failed
> make[3]: *** [arch/arm64/kvm/hyp] Error 2
> scripts/Makefile.build:497: recipe for target 'arch/arm64/kvm' failed
> make[2]: *** [arch/arm64/kvm] Error 2
> Makefile:1822: recipe for target 'arch/arm64' failed
> make[1]: *** [arch/arm64] Error 2
> Makefile:336: recipe for target '__build_one_by_one' failed
> make: *** [__build_one_by_one] Error 2
>=20
> Looking at the problematic line 87 of hyp-init.S shows that
> there is a macro expansion:
>=20
>      mov     x1, #TCR_EL2_RES1
>=20
> This macro was modified by the $subject patch
> (commit c71b5f37b5ff1a673b2e4a91d1b34ea027546e23 in v5.10.y)
> and reverting the patch makes the compile succeed.
>=20
> Now: why does it build for me for v5.15.y and v5.16-rc5?
> I think it is because my build system switches to gcc 6.3
> instead of gcc 4.9 depending on scripts/min-tool-version.sh.

I have run the cross-check and it
- fails with gcc 4.9.2 + binutils 2.25 (compatible to jessie)
- works with gcc 6.3.0 + binutils 2.28.1 (compatible to stretch)

>=20
> So I assume that the fix is not compatible with the minimum
> requirement for 5.10.y of gcc 4.9 (or even less - I don't know =
exactly).
> Earlier kernels may also be affected if $subject patch was also
> backported there, but I have not tested.
>=20
> This should somehow be fixed so that arch/arm64/include/asm/kvm_arm.h
> can be included by older assemblers.

BR and thanks,
Nikolaus Schaller

