Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E4E4D25D0
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 02:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiCIBMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 20:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiCIBLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 20:11:45 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B091E151C66
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 16:54:15 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id w12so976895lfr.9
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 16:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=27qMIFA3SdVzHCN8QyFhnWM7hDBzyl2BeONHmhYOf8E=;
        b=ZzhkTDjM6jz+YP82Qy2AN7vuROXTbLjG8ZA8xzlHYer7eC5+TzcEnp9+YFaimnX9Sj
         6VrTiif7AocdizcPrNCrkw0BQE7s+nHZPt8txEkFBLhx11/oAsMmZlgHfOmoUO7C8JAh
         dYac38sepqqnHxZCQcJ8r18IcialSeyUOId04AqRy3++yTOf3yN/nMeeQWd1nZ6NW/U+
         3hfUEi+sDjipwsfcq5VfeYJ5HxDWMWMB/Bs+CrG3Ts8XQvbMnB/Uw9MXVMPMlz8pQI9D
         9WxMxR0+pX/LJ/ZSxlHSdmVbpQiIGWUs2L/pbDTOvw5S7T7eZWLXyqn3UGrYzYoGPdx6
         4i6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=27qMIFA3SdVzHCN8QyFhnWM7hDBzyl2BeONHmhYOf8E=;
        b=NUJpPOEEoucqzmugVsQ2T1ogsVUbCg0EOMG5ZimgnCcVkGZ5aEBdSfC/eyqHkfKyCz
         Wab631fXkolj0dm4B7uHM+1zfY/htSdt/BVl8Tf1AwqSSh0Q0PUXtb9yMqeR60SlbsWG
         xDJ7FPZKixAZ/r6kHUyRIkrSefKkREzOtbqqVCPxsXrJaXhBQZP/XIud2K6IEsV82rRx
         GKpWuPo3xvkzhe1idi5tZXsWLEgiy5TIs/KIwVC1CvVdw817H6DAtnv2kmxI5YGOqZTk
         rCaYyKCKZfRgdJxKZKzdywj6vMMBw3OXY1pJA0XpjfY4N/JCMOf+VOb1zS37BP3HW8G+
         0+Qw==
X-Gm-Message-State: AOAM532a7gXVDuR3fn0TdQ6DK55PcXJU6oN6XlTxvdzpVffG+O/wU3x1
        RxjByq2ZM1aY0cf1gR5d5VtRG5fT3gnHjvBXmrtSYvwBJvw=
X-Google-Smtp-Source: ABdhPJyNerlkbKDY3ZYw8bWJeCf9eEsUR1qHjsQTkZmQXzmYzerqaUnikiE3xvgSYw0AD6UBO32cxiBdGdIMgoynOX4=
X-Received: by 2002:a2e:8255:0:b0:247:dff4:1f with SMTP id j21-20020a2e8255000000b00247dff4001fmr9886575ljh.16.1646783123273;
 Tue, 08 Mar 2022 15:45:23 -0800 (PST)
MIME-Version: 1.0
References: <20220303183328.1499189-1-dmatlack@google.com> <20220303183328.1499189-2-dmatlack@google.com>
 <YifNPekMfIta+xcv@google.com> <CALzav=frpbRMkDtVTwii2hJ+trtF0m0p5Y_Rc5KS42rp1KEaNw@mail.gmail.com>
 <YifiC2Gqs98p0Tiy@google.com>
In-Reply-To: <YifiC2Gqs98p0Tiy@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 8 Mar 2022 15:44:56 -0800
Message-ID: <CALzav=dWJjbabpDy9sVvyuYe4NteNnX_U8eJc0BNmJ_A9bcp+w@mail.gmail.com>
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

On Tue, Mar 8, 2022 at 3:09 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Mar 08, 2022, David Matlack wrote:
> > On Tue, Mar 8, 2022 at 1:40 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Thu, Mar 03, 2022, David Matlack wrote:
> > > > Tie the lifetime the KVM module to the lifetime of each VM via
> > > > kvm.users_count. This way anything that grabs a reference to the VM via
> > > > kvm_get_kvm() cannot accidentally outlive the KVM module.
> > > >
> > > > Prior to this commit, the lifetime of the KVM module was tied to the
> > > > lifetime of /dev/kvm file descriptors, VM file descriptors, and vCPU
> > > > file descriptors by their respective file_operations "owner" field.
> > > > This approach is insufficient because references grabbed via
> > > > kvm_get_kvm() do not prevent closing any of the aforementioned file
> > > > descriptors.
> > > >
> > > > This fixes a long standing theoretical bug in KVM that at least affects
> > > > async page faults. kvm_setup_async_pf() grabs a reference via
> > > > kvm_get_kvm(), and drops it in an asynchronous work callback. Nothing
> > > > prevents the VM file descriptor from being closed and the KVM module
> > > > from being unloaded before this callback runs.
> > > >
> > > > Fixes: af585b921e5d ("KVM: Halt vcpu if page it tries to access is swapped out")
> > >
> > > And (or)
> > >
> > >   Fixes: 3d3aab1b973b ("KVM: set owner of cpu and vm file operations")
> > >
> > > because the above is x86-centric, at a glance PPC and maybe s390 have issues
> > > beyond async #PF.
> > >
> > > > Cc: stable@vger.kernel.org
> > > > Suggested-by: Ben Gardon <bgardon@google.com>
> > > > [ Based on a patch from Ben implemented for Google's kernel. ]
> > > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > > ---
> > > >  virt/kvm/kvm_main.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > >
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index 35ae6d32dae5..b59f0a29dbd5 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -117,6 +117,8 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
> > > >
> > > >  static const struct file_operations stat_fops_per_vm;
> > > >
> > > > +static struct file_operations kvm_chardev_ops;
> > > > +
> > > >  static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
> > > >                          unsigned long arg);
> > > >  #ifdef CONFIG_KVM_COMPAT
> > > > @@ -1131,6 +1133,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
> > > >       preempt_notifier_inc();
> > > >       kvm_init_pm_notifier(kvm);
> > > >
> > > > +     if (!try_module_get(kvm_chardev_ops.owner)) {
> > >
> > > The "try" aspect is unnecessary.  Stealing from Paolo's version,
> > >
> > >         /* KVM is pinned via open("/dev/kvm"), the fd passed to this ioctl(). */
> > >         __module_get(kvm_chardev_ops.owner);
> >
> > Right, I did see that and agree we're guaranteed the KVM module has a
> > reference at this point. But the KVM module might be in state
> > MODULE_STATE_GOING (e.g. if someone ran "rmmod --wait"), which
> > try_module_get() checks.
>
> Ah, can you throw that in as a comment?  Doesn't have to be much, just enough of
> a breadcrumb to connect the dots and to prevent us from "optimizing" this to
> __module_get() in the future.
>
>         /* Use the "try" variant to play nice with e.g. "rmmod --wait". */

Yeah. I should have included this in the first place (or at least a
blurb in the commit message).

>
> With a comment,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
