Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7182A59B293
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiHUHYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiHUHYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:24:15 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD2920BC3
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 00:24:14 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 90DAE33740;
        Sun, 21 Aug 2022 07:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661066651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nWzz0ycVcNSEJ468E1vHZiWD5Qf3ZUUazUUM3VlGcuc=;
        b=0YzvirrzVuRVkls5fIB4EZ+voxhjuE+8GE2ScLREPwBE4C1I7HFR+Y9ggIdg2XL9h2hNs5
        1KG5ELKAdmLvQW0YqL+o9If8HmgdHz3iPrs/yoErUm5BokEmnnVFaMra2tNxLl76W8L+bY
        mbDOkogR43MRC6Rw164/KEjuNtK5x7w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661066651;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nWzz0ycVcNSEJ468E1vHZiWD5Qf3ZUUazUUM3VlGcuc=;
        b=fFAgiy2mY/c5JgSwDEkrwGe2q2DoZtJOZlXux38FKC9QIY0hIO1ygdkZb4t/Ig8lO1vDD9
        AY2JW2K4VRNUEpAg==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 695CF2C141;
        Sun, 21 Aug 2022 07:24:11 +0000 (UTC)
Date:   Sun, 21 Aug 2022 09:24:10 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Coiby Xu <coxu@redhat.com>, bhe@redhat.com, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.15-stable tree
Message-ID: <20220821072410.GG28810@kitsune.suse.cz>
References: <16605775859368@kroah.com>
 <20220818040938.pllzarythgusnyzf@Rk>
 <Yv+hC9QyHn55uVAo@kroah.com>
 <YwEl3xUF8mwpuVrB@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwEl3xUF8mwpuVrB@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 20, 2022 at 08:20:15PM +0200, Greg KH wrote:
> On Fri, Aug 19, 2022 at 04:41:15PM +0200, Greg KH wrote:
> > On Thu, Aug 18, 2022 at 12:09:38PM +0800, Coiby Xu wrote:
> > > Hi Greg,
> > > 
> > > This patch depends on three prerequisites. This full list of commit ids
> > > should be backported is shown below,
> > > 
> > > 1. 65d9a9a60fd7 ("kexec_file: drop weak attribute from functions")
> > > 2. 689a71493bd2 ("kexec: clean up arch_kexec_kernel_verify_sig")
> > > 3. c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")
> > > 4. 0d519cadf751 ("arm64: kexec_file: use more system keyrings to verify kernel image signature")
> > > 
> > > And I can confirm they can be applied to linux-5.15.y branch
> > > successfully,
> > >     $ git checkout -b arm_key_5.15.y stable/linux-5.15.y
> > >     branch 'arm_key_5.15.y' set up to track 'stable/linux-5.15.y'.
> > >     Switched to a new branch 'arm_key_5.15.y'
> > >     $ git cherry-pick 65d9a9a60fd7 689a71493bd2 c903dae8941d 0d519cadf751
> > >     Auto-merging arch/arm64/include/asm/kexec.h
> > >     Auto-merging arch/powerpc/include/asm/kexec.h
> > >     Auto-merging arch/s390/include/asm/kexec.h
> > >     Auto-merging arch/x86/include/asm/kexec.h
> > >     Auto-merging include/linux/kexec.h
> > >     Auto-merging kernel/kexec_file.c
> > >     [arm_key_5.15.y 7c7844771360] kexec_file: drop weak attribute from functions
> > >      Author: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> > >      Date: Fri Jul 1 13:04:04 2022 +0530
> > >      6 files changed, 61 insertions(+), 40 deletions(-)
> > >     Auto-merging include/linux/kexec.h
> > >     Auto-merging kernel/kexec_file.c
> > >     [arm_key_5.15.y 4283e2681d86] kexec: clean up arch_kexec_kernel_verify_sig
> > >      Date: Thu Jul 14 21:40:24 2022 +0800
> > >      2 files changed, 13 insertions(+), 25 deletions(-)
> > >     Auto-merging include/linux/kexec.h
> > >     Auto-merging kernel/kexec_file.c
> > >     [arm_key_5.15.y c0cf50b9056f] kexec, KEYS: make the code in bzImage64_verify_sig generic
> > >      Date: Thu Jul 14 21:40:25 2022 +0800
> > >      3 files changed, 25 insertions(+), 19 deletions(-)
> > >     [arm_key_5.15.y 40b98256cb89] arm64: kexec_file: use more system keyrings to verify kernel image signature
> > >      Date: Thu Jul 14 21:40:26 2022 +0800
> > >      1 file changed, 1 insertion(+), 10 deletions(-)
> > 
> > thanks, now queued up.
> 
> Nope, it causes build breakages in powerpc :(
s390
> 
> See:
> 	https://lore.kernel.org/r/YwC6eQjx8xC9y3LD@debian
> and
> 	https://lore.kernel.org/r/CA+G9fYtXnZP2vdAi4eU_ApC_YFz6TqTd6Eh5Mumb2=0Y_dK5Yw@mail.gmail.com
> 
> for the reports.  I'm dropping these from 5.15.y now, please fix this up
> and resend if you want them included.

The offending function was removed in 5.16 by
commit 277c8389386e ("s390/kexec_file: move kernel image size check")

Thanks

Michal
