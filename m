Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 026C6188219
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgCQLWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:22:18 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49131 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbgCQLWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:22:18 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48hW3W3wNXzB3t3;
        Tue, 17 Mar 2020 22:22:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1584444136;
        bh=7m6xTV6ORC9fimP591QotV0DExi6ArwAslaYAD6a8gE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=R3suC07yLLownGnMiQtBzYlWQBjC2Y2Mr1fjgaMhi7I03Tw6ufjZw4WoaZXiqoW7X
         9w7zSb2LsfkCq8qcUn9o6JDfZtIASBH4sFz8ntWfjzvCQz05fGey3e+m483q7aENNl
         WTjER2R9FHM0pwErCXzPUaOlqszJZ/dyxvLAY/7h0QKpfmECwhSvG1su6e0j9+Ibat
         SXe0q3bo4rMn5DbePzxlsRagSr8oOu986j8OGuQrkaCUhpM00HGe9unpetpD+aO/eV
         wcdxLe1dn62eA00W63BAXp3KDbgrdVnAh5ByL/QW192YlMk3FeRuzPn7et6TB3Nz1X
         57yXL6Iyl5JEg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     =?utf-8?B?546L5paH6JmO?= <wenhu.wang@vivo.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Allison Randal <allison@lohutok.net>,
        Richard Fontana <rfontana@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, kernel@vivo.com,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] powerpc/fsl-85xx: fix compile error
In-Reply-To: <AJUA5gAVCMaMlIkPsaTC0KqL.3.1584357605616.Hmail.wenhu.wang@vivo.com>
References: <AJUA5gAVCMaMlIkPsaTC0KqL.3.1584357605616.Hmail.wenhu.wang@vivo.com>
Date:   Tue, 17 Mar 2020 22:22:13 +1100
Message-ID: <878sjzfcpm.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=E7=8E=8B=E6=96=87=E8=99=8E <wenhu.wang@vivo.com> writes:
> From: Michael Ellerman <mpe@ellerman.id.au>
>  Date: 2020-03-16 17:41:12
> To:WANG Wenhu <wenhu.wang@vivo.com>,Benjamin Herrenschmidt <benh@kernel.c=
rashing.org>,Paul Mackerras <paulus@samba.org>,WANG Wenhu <wenhu.wang@vivo.=
com>,Allison Randal <allison@lohutok.net>,Richard Fontana <rfontana@redhat.=
com>,Greg Kroah-Hartman <gregkh@linuxfoundation.org>,Thomas Gleixner <tglx@=
linutronix.de>,linuxppc-dev@lists.ozlabs.org,linux-kernel@vger.kernel.org
>  cc: trivial@kernel.org,kernel@vivo.com,stable <stable@vger.kernel.org>
> Subject: Re: [PATCH v3] powerpc/fsl-85xx: fix compile error>WANG Wenhu <w=
enhu.wang@vivo.com> writes:
>>> Include "linux/of_address.h" to fix the compile error for
>>> mpc85xx_l2ctlr_of_probe() when compiling fsl_85xx_cache_sram.c.
>>>
>>>   CC      arch/powerpc/sysdev/fsl_85xx_l2ctlr.o
>>> arch/powerpc/sysdev/fsl_85xx_l2ctlr.c: In function =E2=80=98mpc85xx_l2c=
tlr_of_probe=E2=80=99:
>>> arch/powerpc/sysdev/fsl_85xx_l2ctlr.c:90:11: error: implicit declaratio=
n of function =E2=80=98of_iomap=E2=80=99; did you mean =E2=80=98pci_iomap=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>>>   l2ctlr =3D of_iomap(dev->dev.of_node, 0);
>>>            ^~~~~~~~
>>>            pci_iomap
>>> arch/powerpc/sysdev/fsl_85xx_l2ctlr.c:90:9: error: assignment makes poi=
nter from integer without a cast [-Werror=3Dint-conversion]
>>>   l2ctlr =3D of_iomap(dev->dev.of_node, 0);
>>>          ^
>>> cc1: all warnings being treated as errors
>>> scripts/Makefile.build:267: recipe for target 'arch/powerpc/sysdev/fsl_=
85xx_l2ctlr.o' failed
>>> make[2]: *** [arch/powerpc/sysdev/fsl_85xx_l2ctlr.o] Error 1
>>>
>>> Fixes: commit 6db92cc9d07d ("powerpc/85xx: add cache-sram support")
>>
>>The syntax is:
>>
>>Fixes: 6db92cc9d07d ("powerpc/85xx: add cache-sram support")
>>
>>> Cc: stable <stable@vger.kernel.org>
>>
>>The commit above went into v2.6.37.
>>
>>So no one has noticed this bug since then, how? Or did something else
>>change to expose the problem?
>
> Actually a hard question to answer cause it also left me scratching for l=
ong.
> However, I can not find right or definite answer.

Oh, actually it's fairly straight forward, the code can't be built at
all in upstream because CONFIG_FSL_85XX_CACHE_SRAM is not selectable or
selected by anything.

You sent a patch previously to make it selectable, which Scott thought
was a bad idea.

So this whole file is dead code as far as I'm concerned, so patches for
it definitely do not need to go to stable.

If you want to add a user for it then please send a series doing that,
and this commit can be the first.

cheers
