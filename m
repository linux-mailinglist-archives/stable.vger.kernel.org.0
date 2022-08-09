Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A96B58DA73
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 16:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243768AbiHIOke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 10:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiHIOke (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 10:40:34 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EB426D9
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 07:40:33 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id d65-20020a17090a6f4700b001f303a97b14so12405114pjk.1
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 07:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=OdbOjGUjW12bCfbeWBjGSJ1Nu6Rk3c5Ky+ZI53W01wg=;
        b=TaXG+ej0jDZE0fRN4noaJtSFB5ltkCHj7OE6Qr0NL5hSpQhtaKSX0RdDRHiXlYQdy7
         MSEMDDxfpGEWa+w6jBWpVEwFG41oOAiq602dOmmdikaoW+Jsupla/nPEcG2Wug4G8QeI
         R/6wu3IwfV1cXrxn1hb2o5uHm34Q7XMdvKznNBglR8Vqp2fkXdJwB9/T97p/P5tbfJC2
         iJC6RTuGl32t6ZBKATAv6goAxQVAAVbtv3vsIH6qp290lpHClC8dvzuVSIkWK6lUJDt0
         ctBxtIYfoWBW7cm+VQpAFbdsgBentT5METMZgPILhQltDG0Q34WrrfR8jy3B1NmYNvwD
         EmWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=OdbOjGUjW12bCfbeWBjGSJ1Nu6Rk3c5Ky+ZI53W01wg=;
        b=MD+lNlMdfD19iwABCLhc5Kjx0OxRlFDIS8IGWsgMhZ4bF3MHp9Hx85qKBaI7vW7JsQ
         RUMPzmcjyhHgVh3rP7PYg8yzHOm6cfVTRZEGdupgJgXsKCE07qN69z5p3ois/YImlbca
         54RL8mCQcXzsPYS/YOuVPmkSdjW6JuQm/Dh/NQBxnRK/ELz9SGD3weNBoUVzCkV2xSvN
         7W/RdZd0kmq08xtqpWUqhLOg8G4yzzn0EJirx9KoN9LxIQgm5tFvOjdDxsS350yLTtac
         5ZjwpHHn4MoIWf0kW8FrcVrT457vntS4jHbrK3AF3+/qq9jyekTerBOyqfnF25M+Gfsl
         tNiQ==
X-Gm-Message-State: ACgBeo002jGTRkaezfeoXiYSVqnav4HIBZbhzetrOu/gAgoBIWMY3p+j
        ePjtHdbSoR1xnHwOuZTwT5UG0g==
X-Google-Smtp-Source: AA6agR5dJBGAgBiZdySMn0shi1wg9/jp8sdMtEe28i2vcg1gxytljbDTOA1J7khCTdbdWwzUz3C3pA==
X-Received: by 2002:a17:903:22c1:b0:16f:3d1:f5c with SMTP id y1-20020a17090322c100b0016f03d10f5cmr23843077plg.155.1660056032526;
        Tue, 09 Aug 2022 07:40:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q11-20020a170902dacb00b0016dcfedfe30sm11056894plx.90.2022.08.09.07.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 07:40:31 -0700 (PDT)
Date:   Tue, 9 Aug 2022 14:40:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Coleman Dietsch <dietschc@csp.edu>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com,
        metikaya <metikaya@amazon.co.uk>
Subject: Re: [PATCH v3 2/2] KVM: x86/xen: Stop Xen timer before changing IRQ
Message-ID: <YvJx3Dje4zS/c+H0@google.com>
References: <20220808190607.323899-2-dietschc@csp.edu>
 <20220808190607.323899-3-dietschc@csp.edu>
 <c648744c096588d30771a22efa6d65c31fffd06c.camel@infradead.org>
 <43e258cc-71ac-bde4-d1f8-9eb9519928d3@redhat.com>
 <4fc1371b83001b4eed1617c37bec6b9d007e45c2.camel@infradead.org>
 <YvJqIsQsg+ThMg/C@google.com>
 <0b5dcab333906f166fcdbc296373cc5e08bec79f.camel@infradead.org>
 <953d2e99-ed1a-384d-6d3a-0f656a243f82@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <953d2e99-ed1a-384d-6d3a-0f656a243f82@redhat.com>
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

On Tue, Aug 09, 2022, Paolo Bonzini wrote:
> On 8/9/22 16:16, David Woodhouse wrote:
> > I find the new version a bit harder to follow, with its init-then-stop-
> > then-start logic:
> > 
> > 	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
> > 		if (data->u.timer.port &&
> > 		    data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
> > 			r = -EINVAL;
> > 			break;
> >                  }
> > 
> > 		if (!vcpu->arch.xen.timer.function)
> > 			kvm_xen_init_timer(vcpu);
> > 
> > 		/* Stop the timer (if it's running) before changing the vector */
> > 		kvm_xen_stop_timer(vcpu);
> > 		vcpu->arch.xen.timer_virq = data->u.timer.port;
> 
> 
> I think this is fine, if anything the kvm_xen_stop_timer() call could be
> placed in an "else" but I'm leaning towards applying this version of the
> patch.

I wanted to separate the "init" from the "stop+start", e.g. if there were a more
appropriate place for invoking kvm_xen_init_timer() I would have suggested moving
the call outside of KVM_XEN_VCPU_ATTR_TYPE_TIMER entirely.
