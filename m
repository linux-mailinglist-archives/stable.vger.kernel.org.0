Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D27F4C1ACA
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 19:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243801AbiBWSTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 13:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241030AbiBWSTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 13:19:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548C449FB8
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 10:18:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5BF2615C5
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 18:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F50C340E7;
        Wed, 23 Feb 2022 18:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645640335;
        bh=0HpHno4eU2F7nTr21tVZc5kPgIR4l3e61kEaPFpokwA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YpoIBBmFEh3JJeK6xFMFJX6gS/N5ZC8kRv2siyw26AR3w9xB+FnOmbKco5CDK8Niz
         sWS/EolqBXD47hRiimjKEGm5+WivL4bQcWOo3bO7WdQajckvrv9zflCE4Dh8tHiTsa
         JkppvXd+pHr4TLF2Y6bcBzUr+XiC4hYIaZ6Ifi64=
Date:   Wed, 23 Feb 2022 19:18:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     luto@kernel.org, contact@lsferreira.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/ptrace: Fix xfpregs_set()'s incorrect
 xmm clearing" failed to apply to 5.15-stable tree
Message-ID: <YhZ6jODFkliLkpSG@kroah.com>
References: <164542665924686@kroah.com>
 <YhNWY9Cc04ZDvvGH@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YhNWY9Cc04ZDvvGH@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 10:07:47AM +0100, Borislav Petkov wrote:
> On Mon, Feb 21, 2022 at 07:57:39AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> ---
> >From b0535322d006c7f49e7fca3485991c5f88a5e7cb Mon Sep 17 00:00:00 2001
> From: Andy Lutomirski <luto@kernel.org>
> Date: Mon, 14 Feb 2022 13:05:49 +0100
> Subject: [PATCH] x86/ptrace: Fix xfpregs_set()'s incorrect xmm clearing
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Commit 44cad52cc14ae10062f142ec16ede489bccf4469 upstream.
> 
> xfpregs_set() handles 32-bit REGSET_XFP and 64-bit REGSET_FP. The actual
> code treats these regsets as modern FX state (i.e. the beginning part of
> XSTATE). The declarations of the regsets thought they were the legacy
> i387 format. The code thought they were the 32-bit (no xmm8..15) variant
> of XSTATE and, for good measure, made the high bits disappear by zeroing
> the wrong part of the buffer. The latter broke ptrace, and everything
> else confused anyone trying to understand the code. In particular, the
> nonsense definitions of the regsets confused me when I wrote this code.
> 
> Clean this all up. Change the declarations to match reality (which
> shouldn't change the generated code, let alone the ABI) and fix
> xfpregs_set() to clear the correct bits and to only do so for 32-bit
> callers.
> 
> Fixes: 6164331d15f7 ("x86/fpu: Rewrite xfpregs_set()")
> Reported-by: Luís Ferreira <contact@lsferreira.net>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: <stable@vger.kernel.org>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215524
> Link: https://lore.kernel.org/r/YgpFnZpF01WwR8wU@zn.tnic
> ---
>  arch/x86/kernel/fpu/regset.c | 9 ++++-----
>  arch/x86/kernel/ptrace.c     | 4 ++--
>  2 files changed, 6 insertions(+), 7 deletions(-)


Now queued up,t hanks.

greg k-h
