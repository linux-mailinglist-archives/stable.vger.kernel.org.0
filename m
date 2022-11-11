Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A27C625FF5
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 18:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbiKKRAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 12:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbiKKRAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 12:00:49 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC63125EB2
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 09:00:47 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id k22so5381701pfd.3
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 09:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uQv9t+cMfRNztb2MDGSgO4oDyG4lJFnP/83dETMShPI=;
        b=eUXi9U7rhUSr3br6rmgiaIsYp+RsvxivcSImOAntLprwvBzpzxq2snkTdeBA8QRF46
         RXeLlcRsTKcvZJc3YTbTZylMl6Us+u9gpVr5UwcDJFNmaExFr+vmd22q2xYYFH+dtwx7
         pLSFUZPZgU10jm+ODpk3evi02MKFS2RUChGxbenRrKzhC74MRZRYnQype4+mANvG7nAe
         rXTJGaSyuU+BSfy99bzHO4xKYizlQyyustnK8EAYw+E6b/GaGChT8FXr+VKxGtvbNNXy
         To2ze0rt3SWOsQvWQnRzcTH3JwXjVb09eAxaZfAsEy6avrhdbnhStjtmpg1Z/yBAl145
         /FzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQv9t+cMfRNztb2MDGSgO4oDyG4lJFnP/83dETMShPI=;
        b=x66Kn4MxOJj0vjihLvPXVBI4+Hw4/EITzklKDi1BnEfV4O254ZagRTWjswcZzJow6w
         Jl0XFCvtyIKW29hc8E7bL72EbnjvbjOgm9swCJfxAhE5ybJH30A8tf/fJjH10OHMriLe
         uh1dMRZtAeUi1hwZnm6s40AuC0RA+hN//QA72Gj/v3Qco0N3mtpb4943yBNj8HkReKxq
         KCD4CxzQep+X1gNUEOlc1JOhH1eiPXkBJlZMwDSbN3NqoP6iHSHTJyRlfkl/HKmb5JXr
         rDau+iNWw6zDesv6h9NBWJNM5pRxQjR4J9N5Kd/v7TlUCqrKL37ZDuIFiErgEECXIWQT
         ykzg==
X-Gm-Message-State: ANoB5pkTliFrzh06umSDYFedAK9cLTSjiBcOfMmOmj61r9AZVKv3gAwD
        MIW3mlH1rrN1qJVZ8tgHNVOtrQ==
X-Google-Smtp-Source: AA0mqf4GWxv9k1sfQt7GDw99/UCt6cxg6CadWvuK/9pl2DShLvK1kL9WgKrNokFMXhAV/lhebQXpJA==
X-Received: by 2002:a63:881:0:b0:46e:c7be:16fc with SMTP id 123-20020a630881000000b0046ec7be16fcmr2366257pgi.462.1668186047086;
        Fri, 11 Nov 2022 09:00:47 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i8-20020a170902c94800b00187197c4999sm1964530pla.167.2022.11.11.09.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 09:00:46 -0800 (PST)
Date:   Fri, 11 Nov 2022 17:00:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kyle Huey <me@kylehuey.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org
Subject: Re: [RESEND PATCH v6 1/2] x86/fpu: Allow PKRU to be (once again)
 written by ptrace.
Message-ID: <Y25/u6IlqJGYkVD/@google.com>
References: <20221107063807.81774-1-khuey@kylehuey.com>
 <20221107063807.81774-2-khuey@kylehuey.com>
 <64e62ab9-71f6-6d90-24de-402921c244e7@intel.com>
 <CAP045ArEuTmA6DGoVEgeSRd-F+oQCqRaeyzwgdxuCnOP0jgqWA@mail.gmail.com>
 <b41b6a33-7fdc-bd54-8b15-02bf4e713ed7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b41b6a33-7fdc-bd54-8b15-02bf4e713ed7@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 10, 2022, Dave Hansen wrote:
> On 11/10/22 16:03, Kyle Huey wrote:
> > On Tue, Nov 8, 2022 at 10:23 AM Dave Hansen <dave.hansen@intel.com> wrote:
> BTW, I'd love to know if KVM *REALLY* depends on this.

Unlikely, but nearly impossible to know for sure.  Copy+pasting my response[1] to
an earlier version.

 : Hrm, the current behavior has been KVM ABI for a very long time.
 : 
 : It's definitely odd because all other components will be initialized due to their
 : bits being cleared in the header during kvm_load_guest_fpu(), and it probably
 : wouldn't cause problems in practice as most VMMs likely do "all or nothing" loads.
 : But, in theory, userspace could save/restore a subset of guest XSTATE and rely on
 : the kernel not overwriting guest PKRU when its bit is cleared in the header.
 : 
 : All that said, I don't see any reason to force KVM to change at this time, it's
 : trivial enough to handle KVM's oddities while providing sane behavior for others.
 : Nullify the pointer in the guest path and then update copy_uabi_to_xstate() to
 : play nice with a NULL pointer, e.g. 
 : 
 : 	/*
 : 	 * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
 : 	 * in the header.  KVM's odd ABI is to leave PKRU untouched in this
 : 	 * case (all other components are eventually re-initialized).
 : 	 */
 : 	if (!(kstate->regs.xsave.header.xfeatures & XFEATURE_MASK_PKRU))
 : 		vpkru = NULL;
 : 
 : 	return copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);

> It'd be nice to kill if not.

I don't disagree, my hesitation is purely that doing so might subtly break
userspace.

That said, I'm 99.9% certain no traditional VMM, e.g. QEMU, is relying on this
behavior, as doing KVM_SET_XSAVE with anything except the guest's xfeatures mask
would corrupt guest XSAVE state for everything except PKRU.  I.e. for all intents
and purposes, a traditional VMM must do KVM_GET_SAVE => KVM_SET_XSAVE without
touching the xfeatures mask.

And for non-traditional usage of KVM, I would be quite surprised if any of those
use cases utilize PKRU in the guest, let alone play games with KVM_{G,S}SET_XSAVE.

So, I'm not completely opposed to "fixing" KVM's ABI, but it should be done as a
separate patch that is tagged "KVM: x86:" and clearly states that it's changing
KVM's ABI in a way that could theoretically break userspace.

> >> Would something like this be more clear?
> >>
> >>         if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
> >>                 struct pkru_state *xpkru;
> >>
> >>                 xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
> >>                 *pkru = xpkru->pkru;
> >>         } else {
> >>                 /*
> >>                  * KVM may pass a NULL 'pkru' to indicate
> >>                  * that it does not need PKRU updated.
> >>                  */
> >>                 if (pkru)
> >>                         *pkru = 0;
> >>         }
> > 
> > Yeah, Sean Christopherson suggested this (with the else and if
> > collapsed into a single level) when I submitted this previously.
> 
> I generally agree with Sean, but he's also been guilty of an atrocity or
> two over the years.  :)

Heh, just one or two?  I'll call that a win.

> While I generally like low levels of indentation I also think my version is
> much more clear in this case.

I've no objection to a standalone if.  My suggestion[2] was in response to code
that zeroed @pkru before the XFEATURE_MASK_PKRU check.

      if (pkru)
              *pkru = 0;

      if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
              struct pkru_state *xpkru;
              xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
              *pkru = xpkru->pkru;
      }

[1] https://lore.kernel.org/all/Yv6szXuKGv75wWmm@google.com
[2] https://lore.kernel.org/all/YxDP6jie4cwzZIHp@google.com
