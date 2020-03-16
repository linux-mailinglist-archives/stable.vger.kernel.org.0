Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4CCD18680E
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 10:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbgCPJlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 05:41:15 -0400
Received: from ozlabs.org ([203.11.71.1]:60373 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730231AbgCPJlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Mar 2020 05:41:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48grsM6VkJz9sP7;
        Mon, 16 Mar 2020 20:41:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1584351672;
        bh=0BJ3FURw+fjw50wR+e6LRkf2Tx726H888JVrSKrls5Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=DOf+CeQIRr9jP+zd801bgQ9LbD/TE+CByjPvWQvxtr5O+4o/uK2xFlU76UoHQRM1m
         PO1UW4Vu9Tn3ovq5neZhqoNPTofTuJvlkJdzuw73af6U6+M6OMMYOV5ATseJFLag1d
         eGFHtLkuRRd+l35uigGkppduH+zZfcCp+HEH5Ox0Lg6H5WOFmqhf3yKgYxTeypdh6d
         pHOnjPqwfPWJAnn4ZvO9glKgXR9NoACQZilm7+8n5WjERuDRAAt+e7zzdFJLFgKXIV
         CQsDHCnCtxvsQrpIyuKhAC4GTZJHC7VD8yOytmTWWGwHrRvIQ8hGEOiumZJOhsfWn+
         luLNejYRjYIaQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     WANG Wenhu <wenhu.wang@vivo.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        WANG Wenhu <wenhu.wang@vivo.com>,
        Allison Randal <allison@lohutok.net>,
        Richard Fontana <rfontana@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc:     trivial@kernel.org, kernel@vivo.com,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] powerpc/fsl-85xx: fix compile error
In-Reply-To: <20200314051035.64552-1-wenhu.wang@vivo.com>
References: <20200314051035.64552-1-wenhu.wang@vivo.com>
Date:   Mon, 16 Mar 2020 20:41:12 +1100
Message-ID: <875zf4r613.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

WANG Wenhu <wenhu.wang@vivo.com> writes:
> Include "linux/of_address.h" to fix the compile error for
> mpc85xx_l2ctlr_of_probe() when compiling fsl_85xx_cache_sram.c.
>
>   CC      arch/powerpc/sysdev/fsl_85xx_l2ctlr.o
> arch/powerpc/sysdev/fsl_85xx_l2ctlr.c: In function =E2=80=98mpc85xx_l2ctl=
r_of_probe=E2=80=99:
> arch/powerpc/sysdev/fsl_85xx_l2ctlr.c:90:11: error: implicit declaration =
of function =E2=80=98of_iomap=E2=80=99; did you mean =E2=80=98pci_iomap=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
>   l2ctlr =3D of_iomap(dev->dev.of_node, 0);
>            ^~~~~~~~
>            pci_iomap
> arch/powerpc/sysdev/fsl_85xx_l2ctlr.c:90:9: error: assignment makes point=
er from integer without a cast [-Werror=3Dint-conversion]
>   l2ctlr =3D of_iomap(dev->dev.of_node, 0);
>          ^
> cc1: all warnings being treated as errors
> scripts/Makefile.build:267: recipe for target 'arch/powerpc/sysdev/fsl_85=
xx_l2ctlr.o' failed
> make[2]: *** [arch/powerpc/sysdev/fsl_85xx_l2ctlr.o] Error 1
>
> Fixes: commit 6db92cc9d07d ("powerpc/85xx: add cache-sram support")

The syntax is:

Fixes: 6db92cc9d07d ("powerpc/85xx: add cache-sram support")

> Cc: stable <stable@vger.kernel.org>

The commit above went into v2.6.37.

So no one has noticed this bug since then, how? Or did something else
change to expose the problem?

cheers
