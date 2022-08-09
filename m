Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB1B58DA13
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 16:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbiHIOHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 10:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiHIOHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 10:07:37 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2B412AA0
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 07:07:35 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x10so11449925plb.3
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 07:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=NnEsu78UdgWUFfbUzx2FaqG+fLzRYJgztuHCMcvogJA=;
        b=oDtJsLEQQYL30wcvIv5F3ooBK0Zf/9c8h4+kW5/jz5Nl67dgnb73eDU7C8tmnt4nYY
         cCMyJmMxEiHiWPNM5WQB2io2rxq9bgmB+TaseJV90fL2r3xfh5kJ6m5B6y7/BiuHZEc2
         xde5cBI2o6E657tDSS6U8BOe2jW6sBWiX9XXvh65MlJJUS7AaWOV4KvFfxIIfmZCuNwc
         oOoe0EJLXJhc0M3MGpwUWJQ1cAhegx+jjeoZ433VUWG15wBgZfP+Bpz4F5TPaAVFcv1G
         xIwBkATQVJVHWkK6kqQjZYTL5Jpf+PTD6HmUUJaV9clHvHt2RUqA3nIziuDGmoL3H5PH
         aSCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=NnEsu78UdgWUFfbUzx2FaqG+fLzRYJgztuHCMcvogJA=;
        b=tj8bw/jUSuL4CmvmURZVhP7/gKCBm+NtYhbTQAL0KjqjCxogJFgND8xt/FzOZ7nWk6
         JBEtamFOTswWJnlTSfuOaw5VroWdRJ+5YJKxJYY6KqcvmX5DTar7q2Ui4EYUtzf5F88d
         yLv9wu2f3a5Xk5yiOesSdjzOH3X6ub45miJQtwAB3aQ8LWUE7xXlKNw3UtHjMI9m4c02
         73LWM3JSGWNkAE1z3qSx01NsW9iRDd6eRGR7G1xnPq+Dvn49j0KeWDkFqURjBQemA2RP
         wa6hu0iyuzJ8xfTbgMMaRDdPMN4JV9LB5HOY+cAx+o15EvKw+2rlh+F8d1ggRmsVGkj0
         wGGQ==
X-Gm-Message-State: ACgBeo2U5vyzAJ0Drbfy+V4eWnc5VNjJA/Gpe87B/nlSmJ1AahAgztIi
        lKsghqywwYKOeaVlOaYKvLZmmQ==
X-Google-Smtp-Source: AA6agR4aiTL+Daci9AK1TqyyNVqT0wIL4ZZnOZ8/yvhfKaMJTNse+c98EGQik7SdrsdREq1iYR++YQ==
X-Received: by 2002:a17:902:b903:b0:170:9964:b47b with SMTP id bf3-20020a170902b90300b001709964b47bmr12764209plb.83.1660054055288;
        Tue, 09 Aug 2022 07:07:35 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c14-20020a170902d48e00b0017086b082c1sm8154199plg.173.2022.08.09.07.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 07:07:34 -0700 (PDT)
Date:   Tue, 9 Aug 2022 14:07:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Coleman Dietsch <dietschc@csp.edu>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 2/2] KVM: x86/xen: Stop Xen timer before changing IRQ
Message-ID: <YvJqIsQsg+ThMg/C@google.com>
References: <20220808190607.323899-2-dietschc@csp.edu>
 <20220808190607.323899-3-dietschc@csp.edu>
 <c648744c096588d30771a22efa6d65c31fffd06c.camel@infradead.org>
 <43e258cc-71ac-bde4-d1f8-9eb9519928d3@redhat.com>
 <4fc1371b83001b4eed1617c37bec6b9d007e45c2.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fc1371b83001b4eed1617c37bec6b9d007e45c2.camel@infradead.org>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022, David Woodhouse wrote:
> On Tue, 2022-08-09 at 14:59 +0200, Paolo Bonzini wrote:
> > On 8/9/22 11:22, David Woodhouse wrote:
> > > On Mon, 2022-08-08 at 14:06 -0500, Coleman Dietsch wrote:
> > > > Stop Xen timer (if it's running) prior to changing the IRQ vector and
> > > > potentially (re)starting the timer. Changing the IRQ vector while the
> > > > timer is still running can result in KVM injecting a garbage event, e.g.
> > > > vm_xen_inject_timer_irqs() could see a non-zero xen.timer_pending from
> > > > a previous timer but inject the new xen.timer_virq.
> > > 
> > > Hm, wasn't that already addressed in the first patch I saw, which just
> > > called kvm_xen_stop_timer() unconditionally before (possibly) setting
> > > it up again?
> > 
> > Which patch is that?
> 
> The one I acked in
> https://lore.kernel.org/all/9bad724858b6a06c25ead865b2b3d9dfc216d01c.camel@infradead.org/

It's effectively the same patch.  I had asked Coleman to split it into two separate
patches: (1) fix the re-initialization of an active timer bug and (2) stop the active
timer before changing the vector (this patch).
