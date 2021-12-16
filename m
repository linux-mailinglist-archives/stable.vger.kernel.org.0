Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1FD4774AC
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 15:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbhLPOa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 09:30:59 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:23184 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237137AbhLPOa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 09:30:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1639665041;
    s=strato-dkim-0002; d=goldelico.com;
    h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=nHjV2/w4uk4t23A+mk/+ID66lmP7ArnJmR0AFAKwGX4=;
    b=BKogtTki9xKRX4Fq4mCXJdzDE7E4jpmtMny05qOiRga6psZEsY+xNJk5qsFfVUj+Vk
    3y80eclIezjQUoUJPVXA/w8CI/YuWE9CZKQneGpDdEJo+O7yekUNcGUBsTXhCa3oOjCJ
    CXcpnOlyYsbl3pE3/c07oFdULgJdGuocRz3eUlpz20DXe7Nf+kFQNKcXkmke7AgtzVnO
    VDcKuuSWt5u8B+lwo087U69WgSYpFA6CSp20V1P9XIr03FWTDc0HRPfQKIGiUG8ze+Zl
    xFSQLTaPiC2dqVEtd66ricPdFsdnGmgXAAcupzTNHI2QjZQHuWxsqejWATCk9+vV/kEf
    cRBw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7gpw91N5y2S3iMMUrw=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
    by smtp.strato.de (RZmta 47.35.3 DYNA|AUTH)
    with ESMTPSA id 404833xBGEUeEje
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Thu, 16 Dec 2021 15:30:40 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.21\))
Subject: Re: Bug with KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2
 and CPTR_EL2 to 1
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <be707d0d8fa0419470cb07b47e6f0464@kernel.org>
Date:   Thu, 16 Dec 2021 15:30:40 +0100
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Chris January <Chris.January@arm.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        reg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CD07B147-6798-46C8-A01C-6CBDB73A44B2@goldelico.com>
References: <DB8835B4-8F04-4669-87EA-D348FA47A79D@goldelico.com>
 <8C04B3CF-4B26-4EA1-B6BD-A7AB30078FCE@goldelico.com>
 <be707d0d8fa0419470cb07b47e6f0464@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
X-Mailer: Apple Mail (2.3445.104.21)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

> Am 16.12.2021 um 09:43 schrieb Marc Zyngier <maz@kernel.org>:
>=20
> Hi Nikolaus,
>=20
> On 2021-12-16 06:58, H. Nikolaus Schaller wrote:
>> Hi Catalin,
>>> Am 15.12.2021 um 19:40 schrieb H. Nikolaus Schaller =
<hns@goldelico.com>:
>>> this seems to break build of 5.10.y (and maybe earlier) for me:
>>> CALL    scripts/checksyscalls.sh - due to target missing
>>> CALL    scripts/atomic/check-atomics.sh - due to target missing
>>> CHK     include/generated/compile.h
>>> AS      arch/arm64/kvm/hyp/nvhe/hyp-init.nvhe.o - due to target =
missing
>>> arch/arm64/kvm/hyp/nvhe/hyp-init.S: Assembler messages:
>>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
>>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
>>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'This should =
somehow be fixed so that arch/arm64/include/asm/kvm_arm.h
>>> can be included by older assemblers.
>=20
> GCC versions prior to 5.1 are known to miscompile the kernel,
> and the minimal GCC version was bumped in dca5244d2f5b.

> I am surprised this requirement wasn't backported to 5.10-stable,
> as this results in all sorts of terrible bugs that are hard to
> diagnose (see the horror story in the commit message).

Indeed.

My build system checks for existence of scripts/min-tool-version.sh
and if it exists it chooses the right gcc version. If it does not exist
it assumes that gcc 4.9 is still good enough...

>=20
> As for the issue you describe, does the following help?

>=20
> Thanks,
>=20
>        M.
>=20
> diff --git a/arch/arm64/include/asm/kvm_arm.h =
b/arch/arm64/include/asm/kvm_arm.h
> index 01d47c5886dc..d03087308ab5 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -91,7 +91,7 @@
> #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
>=20
> /* TCR_EL2 Registers bits */
> -#define TCR_EL2_RES1		((1U << 31) | (1 << 23))
> +#define TCR_EL2_RES1		((UL(1) << 31) | (UL(1) << 23))
> #define TCR_EL2_TBI		(1 << 20)
> #define TCR_EL2_PS_SHIFT	16
> #define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
>=20
> --=20
> Jazz is not dead. It just smells funny...


Yes, it does! This can be compiled with gcc 4.9 (resp. binutils).

So IMHO there are 3 different ways to solve it:
a) your fix applied to 5.10.y
b) someone backports scripts/min-tool-version.sh
to allow for dependable automation...
c) we leave 5.10.y unfixed and I just add a special
rule for arm64 to choose a newer gcc (it is no problem to
use 4.9 for other architectures) in my build setup.

BR and thanks,
Nikolaus


