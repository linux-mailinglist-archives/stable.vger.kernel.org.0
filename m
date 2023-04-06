Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A206D8D6A
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 04:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbjDFCZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 22:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbjDFCZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 22:25:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863627ED3
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 19:25:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b124-20020a253482000000b00b72947f6a54so37658649yba.14
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 19:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680747939;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uzLdQHPRXQy/82zolk+xJ8q+mSGRD7neb4gn4oC5I/4=;
        b=PCLY2Ypu6l6hh2CIW4bQoTuVenTn3Y0AAyzXiGMd3jfotzgF95xcRMTOSFFN0A48kl
         708o0LdF2NZTokf4TZaNDEPCCqsyuLOcV1YO2kCmobaGM5loFxXhR8p7LYmBdegZaWeY
         GgbIrvzonzzi5/utvjc23HnZoIjLGdb91gmdFO042JtKTL7/3Ed2T+hd7YvNfBhso1zD
         IDM60PbNRKbeHefJmqaZNLm1IyreMgpF3l2DI6lK3W2kb2OYWzk2/ill8MyhwZcvvIvE
         zJ443wwDyPaRoF7vsC3LgVnyZiIyOrXmTECEse4btdezgmiMIESwPYSHelMjGyG8Gc9A
         gIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680747939;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uzLdQHPRXQy/82zolk+xJ8q+mSGRD7neb4gn4oC5I/4=;
        b=iqn0t/EHlKZsmMyXAEF8J1hzFWmF/w+u4DuVkoS/LkgO/Qc90Ruu3AYgxZNElH9Y52
         2QLT+LDiZXnh9jQLjwKvWHaS450mGoF+jj8Hm9wwr4surcwZgEFPwL7fwpAMd0OYybzk
         YtRmU5lAIyh6vpK13K0D3HLYFgspWGlrdzknJyk5aJFvLbpPNeUuu06V1rLbZCfMXlLE
         Ab7+YGF/a3vNcDHSOQuIimQpwu5vOPk9f3h0jqoXyj7xXfB57T6AEqoux15bm2NuN/Ve
         mgAhTC3Ap/c/xS9SIYbcMCAU5fUfmag/9e+5GUXnjJ61F/chbvEhyyJoiS2xtlLCBlRP
         58yQ==
X-Gm-Message-State: AAQBX9d1e32thEMiRWONhixCGHOQVXByxoD/QyjpWtjwqk9pfvZgrNYf
        XBiSvyG336net3zLC7pCSq5DCUqrTcE=
X-Google-Smtp-Source: AKy350ZMzk2zAw14PQHNGkXIvmyddKylyhVTHoaHYhsZY7mxch8XxLPCKp4ZKpPAS5ZQweRcA/5WylDGeO0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cad1:0:b0:b75:3fd4:1b31 with SMTP id
 a200-20020a25cad1000000b00b753fd41b31mr1076802ybg.1.1680747938856; Wed, 05
 Apr 2023 19:25:38 -0700 (PDT)
Date:   Wed, 5 Apr 2023 19:25:37 -0700
In-Reply-To: <ZB7oKD6CHa6f2IEO@kroah.com>
Mime-Version: 1.0
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <167949641597.2215962.13042575709754610384.b4-ty@google.com>
 <190509c8-0f05-d05c-831c-596d2c9664ac@grsecurity.net> <ZB7oKD6CHa6f2IEO@kroah.com>
Message-ID: <ZC4tocf+PeuUEe4+@google.com>
Subject: Re: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP users
From:   Sean Christopherson <seanjc@google.com>
To:     Greg KH <greg@kroah.com>
Cc:     Mathias Krause <minipli@grsecurity.net>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 25, 2023, Greg KH wrote:
> On Sat, Mar 25, 2023 at 12:39:59PM +0100, Mathias Krause wrote:
> > On 23.03.23 23:50, Sean Christopherson wrote:
> > > On Wed, 22 Mar 2023 02:37:25 +0100, Mathias Krause wrote:
> > >> v3: https://lore.kernel.org/kvm/20230201194604.11135-1-minipli@grsecurity.net/
> > >>
> > >> This series is the fourth iteration of resurrecting the missing pieces of
> > >> Paolo's previous attempt[1] to avoid needless MMU roots unloading.
> > >>
> > >> It's incorporating Sean's feedback to v3 and rebased on top of
> > >> kvm-x86/next, namely commit d8708b80fa0e ("KVM: Change return type of
> > >> kvm_arch_vm_ioctl() to "int"").
> > >>
> > >> [...]
> > > 
> > > Applied 1 and 5 to kvm-x86 mmu, and the rest to kvm-x86 misc, thanks!
> > > 
> > > [1/6] KVM: x86/mmu: Avoid indirect call for get_cr3
> > >       https://github.com/kvm-x86/linux/commit/2fdcc1b32418
> > > [2/6] KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled
> > >       https://github.com/kvm-x86/linux/commit/01b31714bd90
> > > [3/6] KVM: x86: Ignore CR0.WP toggles in non-paging mode
> > >       https://github.com/kvm-x86/linux/commit/e40bcf9f3a18
> > > [4/6] KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
> > >       https://github.com/kvm-x86/linux/commit/74cdc836919b
> > > [5/6] KVM: x86/mmu: Fix comment typo
> > >       https://github.com/kvm-x86/linux/commit/50f13998451e
> > > [6/6] KVM: VMX: Make CR0.WP a guest owned bit
> > >       https://github.com/kvm-x86/linux/commit/fb509f76acc8
> > 
> > Thanks a lot, Sean!
> > 
> > As this is a huge performance fix for us, we'd like to get it integrated
> > into current stable kernels as well -- not without having the changes
> > get some wider testing, of course, i.e. not before they end up in a
> > non-rc version released by Linus. But I already did a backport to 5.4 to
> > get a feeling how hard it would be and for the impact it has on older
> > kernels.
> > 
> > Using the 'ssdd 10 50000' test I used before, I get promising results
> > there as well. Without the patches it takes 9.31s, while with them we're
> > down to 4.64s. Taking into account that this is the runtime of a
> > workload in a VM that gets cut in half, I hope this qualifies as stable
> > material, as it's a huge performance fix.
> > 
> > Greg, what's your opinion on it? Original series here:
> > https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/
> 
> I'll leave the judgement call up to the KVM maintainers, as they are the
> ones that need to ack any KVM patch added to stable trees.

These are quite risky to backport.  E.g. we botched patch 6[*], and my initial
fix also had a subtle bug.  There have also been quite a few KVM MMU changes since
5.4, so it's possible that an edge case may exist in 5.4 that doesn't exist in
mainline.

I'm not totally opposed to the idea since our tests _should_ be provide solid
coverage, e.g. existing tests caught my subtle bug, but I don't think we should
backport these without a solid usecase, as there is a fairly high risk of breaking
random KVM users that wouldn't see any meaningful benefit.

In other words, who cares enough about the performance of running grsecurity kernels
in VMs to want these backported, but doesn't have the resources to maintain (or pay
someone to maintain) their own host kernel?

[*] https://lkml.kernel.org/r/20230405002608.418442-1-seanjc%40google.com
