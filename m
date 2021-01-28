Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60AB5307DDE
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 19:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhA1SZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 13:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhA1SU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 13:20:28 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0088BC0613D6
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 10:17:32 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id p15so4329659pjv.3
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 10:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eeNqR1SgKoX2yrJH2AARxzXA+IiTrltJp5YlpMldo3I=;
        b=RTFYj+vBo7GZF9Iw+gy7c3NF8+kMoyUMZFro01arhFKPjFw51xDdfNRUNRGeaM6wmN
         X7KMQwwinygUL4uLMkVcrrh7/yebqMdidTDkNgsPBqPzboIb4H6/EIpKV1pZtJB5Hu6g
         2k2Lm5eXDAkFN+OELOMeCthTkNgWWyWdFUXsHAP2trcddzIDA4ooK5adgBjWZszDT4F0
         Cut0N9r3JfTVFAFBF3H+QmOPjeIgZ2gYzNPWiUot9Wrlb70IIcuuyIopX2QLaryCjoka
         8qxgxoPBmx4lRJ1lW7hs/jb9me/kTCJW9hQLsvGEii+H2HMP4j3X9jkavU4SNZAwu/Yo
         w9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eeNqR1SgKoX2yrJH2AARxzXA+IiTrltJp5YlpMldo3I=;
        b=oTKLUtCxskEdK1qTmtrXi8G6rDJELCvs9rXQ6cH2PkWGSJTVcZsX4UY4DOeWwAOtXq
         E2oTnZtH0oBljC58WQk3tgSu7zsqdR7oQogX/7SEU/NEj9fwA+1huUIzhNltvFa3+jri
         mUFLtQlGueEFmCzNLHuEjS89BRGTHwiv1KCwovP+B5GbfwxAIrVocc5R38eplwOpdNef
         FvGX/V0WXnV7Q0CSxRkUZf7FMjJHcpOPP8pBeWmeFegX2j7WCwzZAs2QEK+db57aKT1f
         l62D/9VfZOlOkIdW+WxpqmVEe22g6jckGNCQdN0Kw8002BMY6lkGejA1wgFo6pGxy61w
         nBTw==
X-Gm-Message-State: AOAM5312TOWKqcUDQOPJetqkcujtq+3Nn2Q34Xspv8vvUA5pUXjVXOT6
        Lng1fOobQkebIIJggggJ8QI0cA==
X-Google-Smtp-Source: ABdhPJxmFPN5I6HOXWpjnyHjEPpVDXehxIdjosN6rFNAZjAkjyvNcm6wWH66gxGvKNIFWrxuTngTcg==
X-Received: by 2002:a17:90b:350b:: with SMTP id ls11mr623939pjb.166.1611857852356;
        Thu, 28 Jan 2021 10:17:32 -0800 (PST)
Received: from google.com ([2620:15c:f:10:91fd:c415:8a8b:ccc4])
        by smtp.gmail.com with ESMTPSA id gw20sm5757106pjb.55.2021.01.28.10.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 10:17:31 -0800 (PST)
Date:   Thu, 28 Jan 2021 10:17:25 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if
 tsx=off
Message-ID: <YBL/tTHHwDW6+vTd@google.com>
References: <20210128170800.1783502-1-pbonzini@redhat.com>
 <YBL65uIZggTjGO7F@google.com>
 <79f0ecab-3521-5df8-0a2e-8a344918b8a8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79f0ecab-3521-5df8-0a2e-8a344918b8a8@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021, Paolo Bonzini wrote:
> On 28/01/21 18:56, Sean Christopherson wrote:
> > On Thu, Jan 28, 2021, Paolo Bonzini wrote:
> > > -			vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
> > > +			if (boot_cpu_has(X86_FEATURE_RTM))
> > > +				vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
> > > +			else
> > > +				vmx->guest_uret_msrs[j].mask = 0;
> > 
> > IMO, this is an unnecessarily confusing way to "remove" the user return MSR.
> > Changing the ordering to do a 'continue' would also provide a separate chunk of
> > code for the new comment.  And maybe replace the switch with an if-statement to
> > avoid a 'continue' buried in a switch?
> 
> You still need the slot in vmx->guest_uret_msrs to store the guest value,
> even though the two available bits are both no-ops.  It's ugly but it makes
> sense: you don't want to ever re-enable TSX, so you use the ignore the guest
> value and run unconditionally with the host value.

Ugh, didn't think about the guest wanting to read back the value it wrote.

> I'll rephrase everything and resend.

Thanks!
