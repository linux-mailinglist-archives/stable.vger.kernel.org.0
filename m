Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498B233420D
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 16:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhCJPtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 10:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbhCJPth (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 10:49:37 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AE6C061761
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 07:49:37 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so7700821pjg.5
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 07:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rQ93tMEwr6U526k1fsxQ9/WZUiZ2ng9jqDwoo0eooT4=;
        b=herUCoWwqCzMUdp2VEF/vl0v0bCdyOxs5i841tz1i82yeAqnIMGWUVavassvGe5JaS
         q69Bx0+wVVYKr1Qt4ZY8s6Sraw6q4M1vVwJZpM0WRcFEshEASOv5Li9VRs/5pkoKM2we
         l0sXIv3wjP1C/rr138wXDLkkVTOJkWWrBWjMCUCJDfDEtoGH9or1r4zUYikuYEousYLM
         3IUnxhLrWe9GlVwRqCNzpZnbPv8fg5XBLOXrVWNfdwk8H4rEXW9/faUqrsvDLbwY5cds
         IKGRDGXbELux+bFuzGj5iOU6OLLuALPGXOmyNb3BCAGV4ush+T35hFOnsAdNyyWR+Ohr
         UJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rQ93tMEwr6U526k1fsxQ9/WZUiZ2ng9jqDwoo0eooT4=;
        b=KC2U4Wu3Q5sVPd60RoMWGVEx00j1lB/YGspv240uldER+IvAPGy2q3XGIpvIiFRUS7
         V0tocdNu/F3N4qygwWj9A5QHstpb6iX8Zi5ixLcBxzF/aS4Oe1eVm5c0PJIO+5Cu4qek
         HzBwPEcAtYNXMZd4mzjFwwEepovfdqlDNOw+hdeFw+q9ebJXKZwnnlJlGVXi3mvZgfUq
         omEfxw2GooY6jhMVPunFaJn/voN5p7QOn5PmxPL3Z+naZnsfIY0MjzVmH5YmJVzi2Re+
         OdyySMFC7qqDIFGADu8kaTt95MXSDJvRp/d4nQ25hc7stqRYO1y6sdTViuWEGcbCxrTF
         p4kQ==
X-Gm-Message-State: AOAM533ipSEYPjHLDHk7YI6Df8+LqlnOalTGW7WDZEtkA+4herlFSIqe
        LwVhA0jrdnk/ogj/vFR0doD0DQ==
X-Google-Smtp-Source: ABdhPJzZu6TIEnXdFU/SB8ODEVOTSc2aZia3Rsr9rUPRVgXCW9Nh7jwnYvZUVFJ68biB8WS/mXbITw==
X-Received: by 2002:a17:902:7d8d:b029:e6:4061:b767 with SMTP id a13-20020a1709027d8db02900e64061b767mr3690837plm.32.1615391376577;
        Wed, 10 Mar 2021 07:49:36 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e4dd:6c31:9463:f8da])
        by smtp.gmail.com with ESMTPSA id y9sm18620pgc.9.2021.03.10.07.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 07:49:35 -0800 (PST)
Date:   Wed, 10 Mar 2021 07:49:29 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Serge Ayoun <serge.ayoun@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] x86/sgx: Fix a resource leak in sgx_init()
Message-ID: <YEjqieABvycpGn0h@google.com>
References: <20210303150323.433207-1-jarkko@kernel.org>
 <20210303150323.433207-2-jarkko@kernel.org>
 <57b33fb5-f961-5c81-72f1-ebf5e6af671c@intel.com>
 <YEjfEzDfRdd0fK88@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEjfEzDfRdd0fK88@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021, Jarkko Sakkinen wrote:
> On Wed, Mar 03, 2021 at 08:56:52AM -0800, Dave Hansen wrote:
> > On 3/3/21 7:03 AM, Jarkko Sakkinen wrote:
> > > If sgx_page_cache_init() fails in the middle, a trivial return
> > > statement causes unused memory and virtual address space reserved for
> > > the EPC section, not freed. Fix this by using the same rollback, as
> > > when sgx_page_reclaimer_init() fails.
> > ...
> > > @@ -708,8 +708,10 @@ static int __init sgx_init(void)
> > >  	if (!cpu_feature_enabled(X86_FEATURE_SGX))
> > >  		return -ENODEV;
> > >  
> > > -	if (!sgx_page_cache_init())
> > > -		return -ENOMEM;
> > > +	if (!sgx_page_cache_init()) {
> > > +		ret = -ENOMEM;
> > > +		goto err_page_cache;
> > > +	}
> > 
> > 
> > Currently, the only way sgx_page_cache_init() can fail is in the case
> > that there are no sections:
> > 
> >         if (!sgx_nr_epc_sections) {
> >                 pr_err("There are zero EPC sections.\n");
> >                 return false;
> >         }
> > 
> > That only happened if all sgx_setup_epc_section() calls failed.
> > sgx_setup_epc_section() never both allocates memory with vmalloc for
> > section->pages *and* fails.  If sgx_setup_epc_section() has a successful
> > memremap() but a failed vmalloc(), it cleans up with memunmap().
> > 
> > In other words, I see how this _looks_ like a memory leak from
> > sgx_init(), but I don't see an actual leak in practice.
> > 
> > Am I missing something?
> 
> In sgx_setup_epc_section():
> 
> 
> 	section->pages = vmalloc(nr_pages * sizeof(struct sgx_epc_page));
> 	if (!section->pages) {
> 		memunmap(section->virt_addr);
> 		return false;
> 	}
> 
> I.e. this rollback does not happen without this fix applied:
> 
> 	for (i = 0; i < sgx_nr_epc_sections; i++) {
> 		vfree(sgx_epc_sections[i].pages);
> 		memunmap(sgx_epc_sections[i].virt_addr);
> 	}

Dave is pointing out that sgx_page_cache_init() fails if and only if _all_
sections fail sgx_setup_epc_section(), and if all sections fail then
sgx_nr_epc_sections is '0' and the above is a nop.

That behavior is by design, as we didn't want to kill SGX if a single section
failed to initialize for whatever reason.
