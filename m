Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5338B1C87
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 13:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbfIMLtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 07:49:43 -0400
Received: from 10.mo173.mail-out.ovh.net ([46.105.74.148]:50725 "EHLO
        10.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfIMLtn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 07:49:43 -0400
X-Greylist: delayed 2236 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Sep 2019 07:49:43 EDT
Received: from player738.ha.ovh.net (unknown [10.109.146.175])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 7E5A31196DA
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 13:12:26 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player738.ha.ovh.net (Postfix) with ESMTPSA id EF3859E61DD3;
        Fri, 13 Sep 2019 11:12:22 +0000 (UTC)
Date:   Fri, 13 Sep 2019 13:12:21 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] powerpc/xive: Fix bogus error code returned by OPAL
Message-ID: <20190913131221.3ea88b5a@bahia.lan>
In-Reply-To: <20190912073049.CF36B20830@mail.kernel.org>
References: <156821713818.1985334.14123187368108582810.stgit@bahia.lan>
        <20190912073049.CF36B20830@mail.kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8762316029017168339
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrtdejgdefiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 12 Sep 2019 07:30:49 +0000
Sasha Levin <sashal@kernel.org> wrote:

> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: 4.12+
> 
> The bot has tested the following trees: v5.2.14, v4.19.72, v4.14.143.
> 
> v5.2.14: Build OK!
> v4.19.72: Failed to apply! Possible dependencies:
>     75d9fc7fd94e ("powerpc/powernv: move OPAL call wrapper tracing and interrupt handling to C")
> 

This is the only dependency indeed.

> v4.14.143: Failed to apply! Possible dependencies:
>     104daea149c4 ("kconfig: reference environment variables directly and remove 'option env='")
>     21c54b774744 ("kconfig: show compiler version text in the top comment")
>     315bab4e972d ("kbuild: fix endless syncconfig in case arch Makefile sets CROSS_COMPILE")
>     3298b690b21c ("kbuild: Add a cache for generated variables")
>     4e56207130ed ("kbuild: Cache a few more calls to the compiler")
>     75d9fc7fd94e ("powerpc/powernv: move OPAL call wrapper tracing and interrupt handling to C")
>     8f2133cc0e1f ("powerpc/pseries: hcall_exit tracepoint retval should be signed")
>     9a234a2e3843 ("kbuild: create directory for make cache only when necessary")
>     d677a4d60193 ("Makefile: support flag -fsanitizer-coverage=trace-cmp")
>     e08d6de4e532 ("kbuild: remove kbuild cache")
>     e17c400ae194 ("kbuild: shrink .cache.mk when it exceeds 1000 lines")
>     e501ce957a78 ("x86: Force asm-goto")
>     e9666d10a567 ("jump_label: move 'asm goto' support test to Kconfig")
> 

That's quite a lot of patches to workaround a hard to hit skiboot bug.
As an alternative, the patch can be backported so that it applies the
following change:

-OPAL_CALL(opal_xive_allocate_irq,              OPAL_XIVE_ALLOCATE_IRQ);
+OPAL_CALL(opal_xive_allocate_irq_raw,          OPAL_XIVE_ALLOCATE_IRQ);

to "arch/powerpc/platforms/powernv/opal-wrappers.S"
instead of "arch/powerpc/platforms/powernv/opal-call.c" .

BTW, this could also be done for 4.19.y .

> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 

Michael ?

> --
> Thanks,
> Sasha

