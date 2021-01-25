Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75675302C0C
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 20:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731830AbhAYTye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 14:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbhAYTy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 14:54:26 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E26C061573
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 11:53:46 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id kx7so250663pjb.2
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 11:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UthBW/7aTeKJLkQ2gI2ILuvzKbz0dGSFoA74H4DgD7Y=;
        b=GZzwzP8DUYjfTXLWP/nUmiRbzFuoYgCUUa7CEV0bHsQnZ6fo3XVNbKEiqz74xF/RI2
         78oL5/yrKXKUetF3IaCfiyzdbySyPdbHJdUm1jnfjiiBhL8P4ATBORLSqwpBS70OttGE
         fExOoES24GlJeWAAed6RnLnN7gi7chTaxqvn0ckIf3y2SbrLDJW+OCLeEbynTCYxvc/w
         bNhpLLUzjldHOxitllIGRAR+4gxED3PfD48QnEHemekcceQ7Z3wKxgrJGQVugejPNdX1
         ci3O+CWL9IlDLbu4EpJLd1KmyPOVWzds2a3RkNsorfioivrZAr4Z7hbldhHR4dqW8k/D
         NdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UthBW/7aTeKJLkQ2gI2ILuvzKbz0dGSFoA74H4DgD7Y=;
        b=l77CnkQpXHxsx4kC1Lr/hWZnsKdhsU0M22RoMb480skvmj43Qto2lubuGpblLaiC8q
         CeG1IgJeqJBGK7P7dXFFFURADQT+8dOn6zpuEj8UqsnuDpbPFZx8hZ8XO78UlSKeJ3k+
         gPib0oxwJGwp8RevW15RRS9v1vKtimTrn7QBhhlCkfop8hIpchRV0L+jSsmRQOhUTcYM
         6HNvCk/xFh/gFi4Lng9l07RVwcTG52hzuzB/OmRHYuzM2tXjTGfuyRtcIcJkUAVXYE3q
         ag3/p6FEwfmg4TWDJiT9cgTokL5itF6R6ZGgK3F5EOr63eGgViqsOaeWt1GC5Il8sttA
         PqCg==
X-Gm-Message-State: AOAM530AfzzIx9GSeaZZzLoFtnYPK3sAOg2H+UQWtU5l86R2Tx8asZv2
        TJqkcYn3q5UgsA2EhVYin/H3nQ==
X-Google-Smtp-Source: ABdhPJyDSLN/cq1I5pWOjFeRUOmc6e+1xThysV13+nq1I4sH4C2tZ4DvvdmGgxaME8f6BqeBE63udw==
X-Received: by 2002:a17:90a:e16:: with SMTP id v22mr1852642pje.73.1611604425437;
        Mon, 25 Jan 2021 11:53:45 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id j16sm181905pjj.18.2021.01.25.11.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 11:53:44 -0800 (PST)
Date:   Mon, 25 Jan 2021 11:53:38 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside
 guest mode for VMX
Message-ID: <YA8hwsL8SWzWEA0h@google.com>
References: <20210125172044.1360661-1-pbonzini@redhat.com>
 <YA8ZHrh9ca0lPJgk@google.com>
 <0b90c11b-0dce-60f3-c98d-3441b418e771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b90c11b-0dce-60f3-c98d-3441b418e771@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021, Paolo Bonzini wrote:
> On 25/01/21 20:16, Sean Christopherson wrote:
> > >   }
> > > +static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
> > > +{
> > > +	if (!nested_get_evmcs_page(vcpu))
> > > +		return false;
> > > +
> > > +	if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
> > > +		return false;
> > nested_get_evmcs_page() will get called twice in the common case of
> > is_guest_mode() == true.  I can't tell if that will ever be fatal, but it's
> > definitely weird.  Maybe this?
> > 
> > 	if (!is_guest_mode(vcpu))
> > 		return nested_get_evmcs_page(vcpu);
> > 
> > 	return nested_get_vmcs12_pages(vcpu);
> > 
> 
> I wouldn't say there is a common case;

Eh, I would argue that it is more common to do KVM_REQ_GET_NESTED_STATE_PAGES
with is_guest_mode() than it is with !is_guest_mode(), as the latter is valid if
and only if eVMCS is in use.  But, I think we're only vying for internet points. :-)

> however the idea was to remove the call to nested_get_evmcs_page from
> nested_get_vmcs12_pages, since that one is only needed after
> KVM_GET_NESTED_STATE and not during VMLAUNCH/VMRESUME.

I'm confused, this patch explicitly adds a call to nested_get_evmcs_page() in
nested_get_vmcs12_pages().
