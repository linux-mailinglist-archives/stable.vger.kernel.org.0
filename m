Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E0255D21F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238075AbiF0PVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 11:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237948AbiF0PV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 11:21:27 -0400
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6B7186CF;
        Mon, 27 Jun 2022 08:20:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 07B51407435;
        Mon, 27 Jun 2022 11:20:28 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id gM9jpXD0zGeX; Mon, 27 Jun 2022 11:20:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A881C4072EA;
        Mon, 27 Jun 2022 11:20:27 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com A881C4072EA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1656343227;
        bh=3TioutwihSc8CEW2tiLyyeSsqZfAWkRLuzcsvj5rNgc=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=RjsRuvILNgqCtxiXug0tVyRylQ6APS8mQUX3XrmW3mb7PkxxMM66mWUDM+9+aM8Rn
         8lgqWI3ZQbY35t3GM9wpsdmyNdsnjwokTV7YTLt27XpGAe2/QRTV474HTLVOUGDt5K
         f1UIQh0wdi7GM6etZtBfKfWTmWXM24aSLDNCYVSXa9S/ZtJuZrOONqW9vD4c47BPvq
         1A//YOjkcf3tbwawzJ3DPqgmRBcI1Bp5V0IBYHIBwp8LvEGpBe+2x3Fc5knCNpEzDm
         GvJE9g6m3Poy5hXvqomMe/AIJXEvddxk8Scv3wZkKvXhk7UFnrxRCpo4zwsMiVqNnw
         hq6Bn/aZfU7WA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id nfYg2j5gOJwx; Mon, 27 Jun 2022 11:20:27 -0400 (EDT)
Received: from localhost (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by mail.efficios.com (Postfix) with ESMTPSA id 790E6407593;
        Mon, 27 Jun 2022 11:20:27 -0400 (EDT)
Date:   Mon, 27 Jun 2022 11:20:40 -0400
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Greg KH <gregkh@linuxfoundation.org>, peterz@infradead.org
Cc:     RAJESH DASARI <raajeshdasari@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Reg: rseq selftests failed on 5.4.199
Message-ID: <YrnKyKiNlsqkuI6k@localhost>
References: <CAPXMrf-_RGYBJNu51rq2mdzcpf7Sk_z3kRNL9pmLvf4xmUkmow@mail.gmail.com>
 <YrlbDgpIVFvh5L9O@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrlbDgpIVFvh5L9O@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27-Jun-2022 09:23:58 AM, Greg KH wrote:
> On Sun, Jun 26, 2022 at 10:01:20PM +0300, RAJESH DASARI wrote:
> > Hi ,
> > 
> > We are running rseq selftests on 5.4.199 kernel with  glibc 2.34
> > version  and we see that tests are failing to compile with invalid
> > argument errors. When we took all the commits from
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/tools/testing/selftests/rseq
> >  related to rseq locally , test cases have passed. I see that there are
> > some adaptations to the latest glibc version done in those commits, is
> > there any plan to backport them to 5.4.x versions. Could you please
> > provide your inputs.
> 
> What commits specifically are you referring to please?  A list of them
> would be great, and if you have tested them and verified that they can
> be backported cleanly would also be very helpful.

Hi Greg,

Specifically related to rseq selftests, the following string of commits
would be relevant on top of v5.4.199. Those are not all strictly only
bugfixes, but they help applying the following commits without
conflicts. I have validated that this string of commits cherry-picks on
top of v5.4.199, and that the resulting selftests build fine.

ea366dd79c ("seq/selftests,x86_64: Add rseq_offset_deref_addv()")
07ad4f7629 ("selftests/rseq: remove ARRAY_SIZE define from individual tests")
5c105d55a9 ("selftests/rseq: introduce own copy of rseq uapi header")
930378d056 ("selftests/rseq: Remove useless assignment to cpu variable")
94b80a19eb ("selftests/rseq: Remove volatile from __rseq_abi")
e546cd48cc ("selftests/rseq: Introduce rseq_get_abi() helper")
886ddfba93 ("selftests/rseq: Introduce thread pointer getters")
233e667e1a ("selftests/rseq: Uplift rseq selftests for compatibility with glibc-2.35")
24d1136a29 ("selftests/rseq: Fix ppc32: wrong rseq_cs 32-bit field pointer on big endian")
de6b52a214 ("selftests/rseq: Fix ppc32 missing instruction selection "u" and "x" for load/store")
26dc8a6d8e ("selftests/rseq: Fix ppc32 offsets by using long rather than off_t")
d7ed99ade3 ("selftests/rseq: Fix warnings about #if checks of undefined tokens")
94c5cf2a0e ("selftests/rseq: Remove arm/mips asm goto compiler work-around")
b53823fb2e ("selftests/rseq: Fix: work-around asm goto compiler bugs")
4e15bb766b ("selftests/rseq: x86-64: use %fs segment selector for accessing rseq thread area")
127b6429d2 ("selftests/rseq: x86-32: use %gs segment selector for accessing rseq thread area")
889c5d60fb ("selftests/rseq: Change type of rseq_offset to ptrdiff_t")

There is also this patch (currently in -tip, not in the master branch
yet) which is relevant for the case where a glibc-2.35 (or a glibc-2.34
with backported rseq support) ends up being built against kernel headers
that do not have rseq support:

https://lore.kernel.org/lkml/20220614154830.1367382-4-mjeanson@efficios.com/

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
