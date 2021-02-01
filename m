Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F19830AD57
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 18:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhBARD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 12:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhBARDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 12:03:55 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C57C0613D6
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 09:03:15 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id md11so10698411pjb.0
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 09:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AbLcBMadzfPNUKPpChxU3zdp0WkPHuBpL7HFiG9WOA8=;
        b=iPO/jFlJkD0ioLqPa854SWjC1n4YOUXfH2OQ2aPZAWRcRmbZucOfXp178t7DmONYTM
         494MAbZ0Eajq1M0wT3gv74Ig1q0clmDanfXx28Kdr/xBSzcC2F61M4rsAQAGi/3hcZy+
         cDxmSNA0L+2LkQxy89Q+P0sQgqcHzidLVLe0ekEO7DyUMBk+ywbqOe4qIhlvFCs0gTZn
         MecXJ/nb4Gsb/Uyp+dbghIjdHjcLJqwMtIiEsreIghPKqCWO17NeFMMG78rnrFCywPts
         yE6FcOx4/5/MhwsQKSB8Yyc3gPgXkKpr4jnH0yCIdaiQAjiooJvyk/beMZyFDZo/Wdku
         VlHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AbLcBMadzfPNUKPpChxU3zdp0WkPHuBpL7HFiG9WOA8=;
        b=NOOQERbxHhFalo1WZkfjshzJPi6wJc4DyV2YoYNeSW/GmIPOXWAAMVGjRqSLlDxEhx
         LB7LAta9rqjpgyV5j81+B4t51CAZo0ba0+FNDx51FK2jYlDAsOHAZFfxYiq/5o8W0atg
         Iiq7iyJ0McbGa7JcJY4bh32M7tw3/GTh4yVGEk1OXuTkYYiCebUuis2rE/3G8GH6WtOx
         Q314H/FLYYYutQG20IJv1UOFjzFKdxJnOJX1Hy6SoqvwCL46vk8JSjelDQ0KxxPmiaOZ
         Al5TuHri7TOucdZzhEepgrefa9nUDkXgoMW2IOYVaHZjNILpHllKIdWf3eVHcpDceCMV
         czmw==
X-Gm-Message-State: AOAM530YqhcYhTflTU1YHVHtTrOY8gMmGOqvUw2D9BRWn5Z/ugax8o/7
        0kTTGUv1I1u0wyMAVPcjq+Kudw==
X-Google-Smtp-Source: ABdhPJwhNigfENOgksJTjP0i72PpJc/SwaWNspkOhsfnSt2m32E0FV/18a4q0HPVj3AsIYD3+j4d/Q==
X-Received: by 2002:a17:902:be0d:b029:e1:4ab:8fd2 with SMTP id r13-20020a170902be0db02900e104ab8fd2mr18582360pls.6.1612198994977;
        Mon, 01 Feb 2021 09:03:14 -0800 (PST)
Received: from google.com ([2620:15c:f:10:829:fccd:80d7:796f])
        by smtp.gmail.com with ESMTPSA id b14sm17152725pfi.74.2021.02.01.09.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:03:14 -0800 (PST)
Date:   Mon, 1 Feb 2021 09:03:07 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even
 if tsx=off
Message-ID: <YBg0Sy3MlD0Rn3mF@google.com>
References: <20210129101912.1857809-1-pbonzini@redhat.com>
 <YBQ+peAEdX2h3tro@google.com>
 <37be5fb8-056f-8fba-3016-464634e069af@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37be5fb8-056f-8fba-3016-464634e069af@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021, Paolo Bonzini wrote:
> On 29/01/21 17:58, Sean Christopherson wrote:
> > On Fri, Jan 29, 2021, Paolo Bonzini wrote:
> > >   	 */
> > >   	if (!boot_cpu_has(X86_FEATURE_RTM))
> > > -		data &= ~(ARCH_CAP_TAA_NO | ARCH_CAP_TSX_CTRL_MSR);
> > > +		data &= ~ARCH_CAP_TAA_NO;
> > 
> > Hmm, simply clearing TSX_CTRL will only preserve the host value.  Since
> > ARCH_CAPABILITIES is unconditionally emulated by KVM, wouldn't it make sense to
> > unconditionally expose TSX_CTRL as well, as opposed to exposing it only if it's
> > supported in the host?  I.e. allow migrating a TSX-disabled guest to a host
> > without TSX.  Or am I misunderstanding how TSX_CTRL is checked/used?
> 
> I'm a bit wary of having a combination (MDS_NO=0, TSX_CTRL=1) that does not
> exist on bare metal.  There are other cases where such combinations can
> happen, especially with the Spectre and SSBD mitigations (for example due to
> AMD CPUID bits for Intel processors), but at least those are just
> redundancies in the CPUID bits and it's more likely that the guest does
> something sensible with them.

Gotcha.  The vulnerability combos and all the double and triple negatives make
my head spin.

Thanks!
