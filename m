Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB0D4D25A9
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 02:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiCIBL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 20:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiCIBLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 20:11:44 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D7BC683D
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 16:54:10 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id 3so994821lfr.7
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 16:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nCdD3sQqnKJUyCXjoQIWWYik/UVOacEyJhPiXRkqPhw=;
        b=BEGslrjfRvpCN4jdyJSHh1JbnDf2fA5/7RvTdiZ95KEK8tz4bZGeH/gFBMpg9UJh8w
         KG6i2b2nE7/a3dTAkYihQHcj9yU1nLyZLC89CYRCMi4FFAa/Cyh0O1stJoEBYjPBTGE7
         fkKRc/S+QBqGgG4A5q4CBpHCpbgIbrV0qDaCduqGhSC0GOlzoPxjv9Y+Ysn8Czh3l6mZ
         Tap0Ci3fR6OMKTl8SVDPhtLN6/Phal0VKyFKRlq40qB40Vsufg+yxZR6wHeFmbiYmEWg
         ++EN14da0QHaqsATfGv0nOF/Xj6Tme2EMJGvnl+7f2kPkfoSKSLaJpMdEXRo2rG/o244
         Ruwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nCdD3sQqnKJUyCXjoQIWWYik/UVOacEyJhPiXRkqPhw=;
        b=Q4tlEWecAFFUzo94tLevw731qig6vLUvbk0p+A2L6rgRdNWabsX67JrX5AjzjCR1EY
         TT1+RL/CNaeNuvXXLFwYbgtmuREyjJWB8t2B/aa4fbWij6JuEh93ogMzNEGkU+BEEmrU
         KPNRDIW+xVva85JbZQNqepo88zKLpdweToALKlKvvmfkj1sC8DK9q+onT5CZhwxMwzmz
         TFEWC+UpEh63HyBfrc2NmwyLkZjwdp8VS4i4AiTGyVbXEgL9Hn701Gdf4LDykJfQaYYF
         zGeb9usS8AasD6jOuIQLRrXpCUvps/s/u/g0uJlroFfvKNVxhUw1yV/dm4CC5ZZRtQqS
         83Uw==
X-Gm-Message-State: AOAM530wWlOUnoI0yLoFsqc4Sb3dhJ2/iumH2eC6Oq6dIDZHeoiAO/Am
        nTveHynDXjkhKNbZMx5i/Eq1aNCD1DgT7WgiJasz5x/hJe5ahQ==
X-Google-Smtp-Source: ABdhPJzR8TsofjdSD7dN+nIpZWpLqGsJWoV3sfUXzDleVMPV2HQfR9vmcwag/mjfc62gRBdA9LPZHOgI+tstwcFfu5c=
X-Received: by 2002:a05:6512:108c:b0:443:d8a6:dff6 with SMTP id
 j12-20020a056512108c00b00443d8a6dff6mr12662005lfg.235.1646783063591; Tue, 08
 Mar 2022 15:44:23 -0800 (PST)
MIME-Version: 1.0
References: <20220303183328.1499189-1-dmatlack@google.com> <20220303183328.1499189-2-dmatlack@google.com>
 <YifNPekMfIta+xcv@google.com>
In-Reply-To: <YifNPekMfIta+xcv@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 8 Mar 2022 15:43:57 -0800
Message-ID: <CALzav=foWcCdiM98ZNB2B2vAqndg3gvOAX-jh5V-h4OC5f1dSQ@mail.gmail.com>
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

SGTM. It's a moot point in terms of stable inclusion since
af585b921e5d was first added in v2.6.38. But for anyone doing their
own backporting, 3d3aab1b973b makes it a bit more obvious this is a
generic problem even though it's not the commit that introduces the
bug.

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
