Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E9B32B14B
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhCCApL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446811AbhCBQPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 11:15:49 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 057FEC06178A;
        Tue,  2 Mar 2021 08:14:02 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 13B8A92009C; Tue,  2 Mar 2021 17:14:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 05E9692009B;
        Tue,  2 Mar 2021 17:14:00 +0100 (CET)
Date:   Tue, 2 Mar 2021 17:14:00 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     YunQiang Su <yunqiang.su@cipunited.com>
cc:     tsbogend@alpha.franken.de, jiaxun.yang@flygoat.com,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v6] MIPS: force use FR=0 for FPXX binary
In-Reply-To: <20210302022907.1835-1-yunqiang.su@cipunited.com>
Message-ID: <alpine.DEB.2.21.2103021645120.19637@angie.orcam.me.uk>
References: <20210302022907.1835-1-yunqiang.su@cipunited.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2 Mar 2021, YunQiang Su wrote:

> The MIPS FPU may have 2 mode:
>   FR=0: MIPS I style, odd-FPR can only be single,
>         and even-FPR can be double.

 Depending on the ISA level FR=0 may or may not allow single arithmetic 
with odd-numbered FPRs.  Compare the FP64A ABI.

>   FR=1: all 32 FPR can be double.

 I think it's best to describe the FR=0 mode as one where the FP registers 
are 32-bit and the FR=1 mode as one where the FP registers are 64-bit 
(this mode is also needed for the paired-single format).  See:

<https://dmz-portal.mips.com/wiki/MIPS_O32_ABI_-_FR0_and_FR1_Interlinking#1._Introduction>

> The binary may have 3 mode:
>   FP32: can only work with FR=0 mode
>   FPXX: can work with both FR=0 and FR=1 mode.
>   FP64: can only work with FR=1 mode
> 
> Some binary, for example the output of golang, may be mark as FPXX,
> while in fact they are FP32.
> 
> Currently, FR=1 mode is used for all FPXX binary, it makes some wrong
> behivour of the binaries. Since FPXX binary can work with both FR=1 and FR=0,
> we force it to use FR=0.

 I think you need to document here what we discussed, that is the linker 
bug exposed in the context of FPXX annotation by legacy modules that lack 
FP mode annotation, which is the underlying problem.

> v5->v6:
> 	Rollback to V3, aka remove config option.

 You can't reuse v3 as it stands because it breaks R6 as we previously 
discussed.  You need to tell R6 and earlier ISAs apart and set the FR bit 
accordingly.

 It would be more proper I suppose if we actually checked at the boot time 
whether the bit is writable, just like we handle NAN2008, but I don't see 
it as a prerequisite for this workaround since we currently don't do this 
either (it would also be good to check if the FP emulation code gets the 
read-only FR bit right for R6 for FPU-less operation).

 Also you need to put the history in the comment section and not the 
commit description, so that the change can be directly applied and does 
not have to be hand-edited by the maintainer.  You don't want to overload 
him with mechanical work.

  Maciej
