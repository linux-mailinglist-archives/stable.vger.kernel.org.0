Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4762C54CBFD
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 16:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242506AbiFOO6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 10:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbiFOO6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 10:58:42 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDD333EBB
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 07:58:40 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id p18so19386756lfr.1
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 07:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p5WjwBxoG8hcN2wNzdX82aRVBrLb67GAEmI1dQxMZy0=;
        b=r4gnFG1k9OgfmQ7EP/1Y+kdN2g5zJ3GOyFpW2D2CfDDrt/w87w3TdP8K++zTRXmZ1O
         BUsJ3h/tq/C3iprUij5d3WqyvOGMw/I5Nw2LzaFWW8Kk0jJmwkKplMI+l41JN3y5PSh4
         fnlFCyTAhS1yp+NaBsuAeFVDg+5EuG0LyQq5/dUn8T7aUi5OZPsYHQCp1xCWXpUZPDXd
         rJIptAm7vdcpJ/0G+qLHiC/f1LoLW2Sc6al5aQ3TJyiMG5BWUbqQ6aJ5ktnFyy06b9xI
         vu0WMbDHRbaiTdW1pIt4zXGO7csAzT3AsR+uTXqQIKxq3R7RPeMvVGoqtPSHqpYKJYto
         cxjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p5WjwBxoG8hcN2wNzdX82aRVBrLb67GAEmI1dQxMZy0=;
        b=LNI/Md0GWNvmyw8ocY9fuSY1g6CTr0tM4wluLatsauVm3jk8iYainrNpiyAf6aPrZI
         1vHfOIhsdT6+iX5heM0welZMACXKzO1vSc+aV7YaGQWIdZCUCJvxOx5Ydhe3RCgniL/Z
         8sj6rfMNobBaxm2CMipuQVeiS56i1RdZ6FczbzXtIS6PcfKQ2qZ1qgBViJ8gg72sEOWj
         B/+zBeNGcklAkFwQdet5FuEUTsOVW8rMmOGD6fJ2fWbNvPPYsrTDhhg5EX0fpc4V6l3f
         R5IepFbvo9rrbV+a6O7d4YCI02qpwNEfQR2ZQZJkylyzg0pYtWC5icc7ua1IVSbsSuhU
         YfEg==
X-Gm-Message-State: AJIora/ay2s4imzSgJdM49gN20KmK8rFsDu2armyvV0TrLgP4O6qwG5m
        5eUrVz5W6zTDuAuewKO81yyz0/JlyyG4KyU81/lJIw==
X-Google-Smtp-Source: AGRyM1tsa7MGR5pQIMXjpltWXkrdU447D/S/FlKYW140feHY76B0SAzLsFd6ea6D8NUxYt63ZdD7D4DNCzgzKnVlH+0=
X-Received: by 2002:a05:6512:ba6:b0:47d:a6e3:ab37 with SMTP id
 b38-20020a0565120ba600b0047da6e3ab37mr6168253lfv.157.1655305118992; Wed, 15
 Jun 2022 07:58:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220614021141.1101486-1-sashal@kernel.org> <CAG48ez1bRMCUzmkP2zpQ_4Jx0sqRw=b9-sDa-0QSqoGHpqZVJA@mail.gmail.com>
In-Reply-To: <CAG48ez1bRMCUzmkP2zpQ_4Jx0sqRw=b9-sDa-0QSqoGHpqZVJA@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 15 Jun 2022 16:58:02 +0200
Message-ID: <CAG48ez3nxe32Hv3dXO27_rK3qrSGZUW8Pp1sxLDxwKWkL1BaoQ@mail.gmail.com>
Subject: Re: [PATCH MANUALSEL 5.15 1/4] KVM: x86: do not report a vCPU as
 preempted outside instruction boundaries
To:     Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 15, 2022 at 4:53 PM Jann Horn <jannh@google.com> wrote:
>
> On Tue, Jun 14, 2022 at 4:11 AM Sasha Levin <sashal@kernel.org> wrote:
> >
> > From: Paolo Bonzini <pbonzini@redhat.com>
> >
> > [ Upstream commit 6cd88243c7e03845a450795e134b488fc2afb736 ]
> >
> > If a vCPU is outside guest mode and is scheduled out, it might be in the
> > process of making a memory access.  A problem occurs if another vCPU uses
> > the PV TLB flush feature during the period when the vCPU is scheduled
> > out, and a virtual address has already been translated but has not yet
> > been accessed, because this is equivalent to using a stale TLB entry.
> >
> > To avoid this, only report a vCPU as preempted if sure that the guest
> > is at an instruction boundary.  A rescheduling request will be delivered
> > to the host physical CPU as an external interrupt, so for simplicity
> > consider any vmexit *not* instruction boundary except for external
> > interrupts.
> >
> > It would in principle be okay to report the vCPU as preempted also
> > if it is sleeping in kvm_vcpu_block(): a TLB flush IPI will incur the
> > vmentry/vmexit overhead unnecessarily, and optimistic spinning is
> > also unlikely to succeed.  However, leave it for later because right
> > now kvm_vcpu_check_block() is doing memory accesses.  Even
> > though the TLB flush issue only applies to virtual memory address,
> > it's very much preferrable to be conservative.
> >
> > Reported-by: Jann Horn <jannh@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> This feature was introduced in commit f38a7b75267f1f (first in 4.16).
> I think the fix has to be applied all the way back to there (so
> additionally to what you already did, it'd have to be added to 4.19,
> 5.4 and 5.10)?
>
> But it doesn't seem to apply cleanly to those older branches. Paolo,
> are you going to send stable backports of this?

Also, I think the same thing applies for "KVM: x86: do not set
st->preempted when going back to user space"?
