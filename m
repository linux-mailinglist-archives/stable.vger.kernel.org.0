Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2022B4D24A1
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 00:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiCHXKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 18:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiCHXKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 18:10:04 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EF36C93D
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 15:09:04 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id t19so441019plr.5
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 15:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eEcOwEnTCsoRODrbH9WKZeOW5g4d6mtfEmYy7dNkCgk=;
        b=QxMDvrC37ShjB2pSN9wA20Vlar3+06Cm4YnIP3YVV/IGHAYKErEoDG4beO8uH30ubs
         HBdZPpAIAyqbHZxgC/r3/IVfTvA7fJebDWfmrzzD/mcdMNs7H7h4pIEBcsjJDcJ2XWVl
         9yLTmLVYCC28tRxqry9y//t/g+YJM4UG5gqmSXHnSrz9PXFtqYuY0sM6W8ZnBtwYM+bD
         YxrmWPXKaeuj0wsfbXgJDgqxwEYiUdoPTZBm3x9oZt8iOxNct4t0A/v0w7kFCQLpjAA4
         M4tdrO8Nfv51rN04kKYBHGpeoBBnKPz6hhEsR6D1lf1y6fyjwObB7ZWaQqajHYysXxn4
         Nlxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eEcOwEnTCsoRODrbH9WKZeOW5g4d6mtfEmYy7dNkCgk=;
        b=WIXixviD6EnZvbAQRdo+fUTXHIetLFrBh1Bj9YS2+ZHddL+et8trrOShK9RfH6RikC
         Ia5ZlnSqyhv2TlE0pKEvsPURzUtuHqvHwx49deqA4Ywgv75Ac08Pc1CBAxGKF+iIwaCo
         T2le01xccUoGDC1UrbfSKAOc/rxsrmwxFAaFJDcIoDRM9odW6XBG654woIEokVAsv8Av
         ukkHycKW8+7dDX7WJ/LGdZParavByFxv+qSNM72+FvrAR8KWOdLFD8mI12KzQinNdV7C
         wKitp/f+/w60yS1KotKFazrc1UO+B64ouBBtcVZBdslodu2z3bWYBzMVpxkud0lnj4b+
         vevg==
X-Gm-Message-State: AOAM531xnlKj2H9Hza54kBj6SIl8ut7y4NdJGtufE48lFxmfJno9Nusu
        YOB1VgXAQt4+TNrPkIyjrrY1Tw==
X-Google-Smtp-Source: ABdhPJzw3CB/8gpoMZy8L1RPu7Ynf156Hx+5E0vsaoqcpRaxfS9hWV3nxQqMxHcDoxtVsc+NwtKPOg==
X-Received: by 2002:a17:90a:19d2:b0:1be:d815:477f with SMTP id 18-20020a17090a19d200b001bed815477fmr7325044pjj.23.1646780943683;
        Tue, 08 Mar 2022 15:09:03 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m4-20020a17090a7f8400b001bef3fc3938sm146223pjl.49.2022.03.08.15.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 15:09:02 -0800 (PST)
Date:   Tue, 8 Mar 2022 23:08:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        Ben Gardon <bgardon@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] KVM: Prevent module exit until all VMs are
 freed
Message-ID: <YifiC2Gqs98p0Tiy@google.com>
References: <20220303183328.1499189-1-dmatlack@google.com>
 <20220303183328.1499189-2-dmatlack@google.com>
 <YifNPekMfIta+xcv@google.com>
 <CALzav=frpbRMkDtVTwii2hJ+trtF0m0p5Y_Rc5KS42rp1KEaNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=frpbRMkDtVTwii2hJ+trtF0m0p5Y_Rc5KS42rp1KEaNw@mail.gmail.com>
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

On Tue, Mar 08, 2022, David Matlack wrote:
> On Tue, Mar 8, 2022 at 1:40 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Mar 03, 2022, David Matlack wrote:
> > > Tie the lifetime the KVM module to the lifetime of each VM via
> > > kvm.users_count. This way anything that grabs a reference to the VM via
> > > kvm_get_kvm() cannot accidentally outlive the KVM module.
> > >
> > > Prior to this commit, the lifetime of the KVM module was tied to the
> > > lifetime of /dev/kvm file descriptors, VM file descriptors, and vCPU
> > > file descriptors by their respective file_operations "owner" field.
> > > This approach is insufficient because references grabbed via
> > > kvm_get_kvm() do not prevent closing any of the aforementioned file
> > > descriptors.
> > >
> > > This fixes a long standing theoretical bug in KVM that at least affects
> > > async page faults. kvm_setup_async_pf() grabs a reference via
> > > kvm_get_kvm(), and drops it in an asynchronous work callback. Nothing
> > > prevents the VM file descriptor from being closed and the KVM module
> > > from being unloaded before this callback runs.
> > >
> > > Fixes: af585b921e5d ("KVM: Halt vcpu if page it tries to access is swapped out")
> >
> > And (or)
> >
> >   Fixes: 3d3aab1b973b ("KVM: set owner of cpu and vm file operations")
> >
> > because the above is x86-centric, at a glance PPC and maybe s390 have issues
> > beyond async #PF.
> >
> > > Cc: stable@vger.kernel.org
> > > Suggested-by: Ben Gardon <bgardon@google.com>
> > > [ Based on a patch from Ben implemented for Google's kernel. ]
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  virt/kvm/kvm_main.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 35ae6d32dae5..b59f0a29dbd5 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -117,6 +117,8 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
> > >
> > >  static const struct file_operations stat_fops_per_vm;
> > >
> > > +static struct file_operations kvm_chardev_ops;
> > > +
> > >  static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
> > >                          unsigned long arg);
> > >  #ifdef CONFIG_KVM_COMPAT
> > > @@ -1131,6 +1133,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
> > >       preempt_notifier_inc();
> > >       kvm_init_pm_notifier(kvm);
> > >
> > > +     if (!try_module_get(kvm_chardev_ops.owner)) {
> >
> > The "try" aspect is unnecessary.  Stealing from Paolo's version,
> >
> >         /* KVM is pinned via open("/dev/kvm"), the fd passed to this ioctl(). */
> >         __module_get(kvm_chardev_ops.owner);
> 
> Right, I did see that and agree we're guaranteed the KVM module has a
> reference at this point. But the KVM module might be in state
> MODULE_STATE_GOING (e.g. if someone ran "rmmod --wait"), which
> try_module_get() checks.

Ah, can you throw that in as a comment?  Doesn't have to be much, just enough of
a breadcrumb to connect the dots and to prevent us from "optimizing" this to
__module_get() in the future.

	/* Use the "try" variant to play nice with e.g. "rmmod --wait". */

With a comment,

Reviewed-by: Sean Christopherson <seanjc@google.com>
