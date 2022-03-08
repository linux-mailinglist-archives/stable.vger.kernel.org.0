Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5813C4D2448
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 23:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241588AbiCHWaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 17:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238847AbiCHWaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 17:30:17 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5691D58E45
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 14:29:20 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so633048pju.2
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 14:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lcrkkjBENIYesydqiaasOTxpBce7QoI3ujVOSnsO1B4=;
        b=nJaHE2lI1yjIYJj/ybuRclsQuEbWR4Gm6ytnlJ6u9IDtCY6esGtyX8KJNebOkEokSJ
         d0+AKITI/OY1Y68Zvu0mcFGgSgB1VNTMVou2x2HV0lZSuZcKQNIoW14Se5weuEPNW1MK
         bTb2YUptnBdr90cub2sWw4LyBMTFVOH86nXqoFkHd1YbiA5MR+Oq9Eq2kxnOVyBuAogw
         u+CRnnu18K1BCTywk1ZkQv9Z0xuTSuOkiHZemDTi4JmR3d4W5y3lYO76M0JwrLRRtz/h
         l7xnRUbeFwc/57Q/xLM11EYjt0OYMCdMyE+dXPhS8o6uEmQ8uwkkrAzSqLD0Z09tM7yn
         sepQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lcrkkjBENIYesydqiaasOTxpBce7QoI3ujVOSnsO1B4=;
        b=XlB2M/BJslN94OKp3tb3klEjMJMpI/64Y8pjbcVcSuT8JNoH77+s0MH7nNqgVzw29/
         n7tn4s2OZDnR9oGNbNRNWEcBW960MMdnXdsqULVLN5huZ2ju8c5rSb9djIyjcMEXNERF
         p6tel5HPFvntpfIcxjbjfDWsf+25R72lCz9MlyfCBTfWgV+mXM29kfX2b6dkN6mbpeXz
         J78w1u0SFspNVwkavWgJUGDfZ/B8ro/nHVI4aCjV0K/brMhRoWW/PPlcHO1GSqKaSiME
         Fig9yjQuu3v1D75M6Z/02IL0ilVeHJcG3nk8D+QBblEKVTOzI/x9u8mTUPijr8etTMrZ
         pSvQ==
X-Gm-Message-State: AOAM5323izRDUzN10oShWTs0aFqtZsTgguCxPXzLkQl5A7p1xTasZjp3
        8GL/1lwJom8J/ekawwcEJL95pxrqH/LmkXyDnGBxQA==
X-Google-Smtp-Source: ABdhPJyFpRTvd02rvAC/Kf+WMGoh+2aCSSzrWOG96Yn5KqPBCJaSnmXw9faK4PL72W3N7T8tP/CyIPN67B/8aS1QiIM=
X-Received: by 2002:a17:903:292:b0:149:460a:9901 with SMTP id
 j18-20020a170903029200b00149460a9901mr19634846plr.44.1646778559549; Tue, 08
 Mar 2022 14:29:19 -0800 (PST)
MIME-Version: 1.0
References: <20220303183328.1499189-1-dmatlack@google.com> <20220303183328.1499189-2-dmatlack@google.com>
 <YifNPekMfIta+xcv@google.com>
In-Reply-To: <YifNPekMfIta+xcv@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 8 Mar 2022 14:28:53 -0800
Message-ID: <CALzav=frpbRMkDtVTwii2hJ+trtF0m0p5Y_Rc5KS42rp1KEaNw@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/2] KVM: Prevent module exit until all VMs are freed
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        Ben Gardon <bgardon@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 8, 2022 at 1:40 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Mar 03, 2022, David Matlack wrote:
> > Tie the lifetime the KVM module to the lifetime of each VM via
> > kvm.users_count. This way anything that grabs a reference to the VM via
> > kvm_get_kvm() cannot accidentally outlive the KVM module.
> >
> > Prior to this commit, the lifetime of the KVM module was tied to the
> > lifetime of /dev/kvm file descriptors, VM file descriptors, and vCPU
> > file descriptors by their respective file_operations "owner" field.
> > This approach is insufficient because references grabbed via
> > kvm_get_kvm() do not prevent closing any of the aforementioned file
> > descriptors.
> >
> > This fixes a long standing theoretical bug in KVM that at least affects
> > async page faults. kvm_setup_async_pf() grabs a reference via
> > kvm_get_kvm(), and drops it in an asynchronous work callback. Nothing
> > prevents the VM file descriptor from being closed and the KVM module
> > from being unloaded before this callback runs.
> >
> > Fixes: af585b921e5d ("KVM: Halt vcpu if page it tries to access is swapped out")
>
> And (or)
>
>   Fixes: 3d3aab1b973b ("KVM: set owner of cpu and vm file operations")
>
> because the above is x86-centric, at a glance PPC and maybe s390 have issues
> beyond async #PF.
>
> > Cc: stable@vger.kernel.org
> > Suggested-by: Ben Gardon <bgardon@google.com>
> > [ Based on a patch from Ben implemented for Google's kernel. ]
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 35ae6d32dae5..b59f0a29dbd5 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -117,6 +117,8 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
> >
> >  static const struct file_operations stat_fops_per_vm;
> >
> > +static struct file_operations kvm_chardev_ops;
> > +
> >  static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
> >                          unsigned long arg);
> >  #ifdef CONFIG_KVM_COMPAT
> > @@ -1131,6 +1133,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
> >       preempt_notifier_inc();
> >       kvm_init_pm_notifier(kvm);
> >
> > +     if (!try_module_get(kvm_chardev_ops.owner)) {
>
> The "try" aspect is unnecessary.  Stealing from Paolo's version,
>
>         /* KVM is pinned via open("/dev/kvm"), the fd passed to this ioctl(). */
>         __module_get(kvm_chardev_ops.owner);

Right, I did see that and agree we're guaranteed the KVM module has a
reference at this point. But the KVM module might be in state
MODULE_STATE_GOING (e.g. if someone ran "rmmod --wait"), which
try_module_get() checks.

>
> > +             r = -ENODEV;
> > +             goto out_err;
> > +     }
> > +
> >       return kvm;
> >
> >  out_err:
> > @@ -1220,6 +1227,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
> >       preempt_notifier_dec();
> >       hardware_disable_all();
> >       mmdrop(mm);
> > +     module_put(kvm_chardev_ops.owner);
> >  }
> >
> >  void kvm_get_kvm(struct kvm *kvm)
> >
> > base-commit: b13a3befc815eae574d87e6249f973dfbb6ad6cd
> > prerequisite-patch-id: 38f66d60319bf0bc9bf49f91f0f9119e5441629b
> > prerequisite-patch-id: 51aa921d68ea649d436ea68e1b8f4aabc3805156
> > --
> > 2.35.1.616.g0bdcbb4464-goog
> >
