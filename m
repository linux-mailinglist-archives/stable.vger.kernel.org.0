Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3E51C9978
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 20:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgEGSll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 14:41:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:7254 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgEGSll (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 14:41:41 -0400
IronPort-SDR: 3OmsZvWetR45zOQbsJ8b3yJDuOwkLT9qrvZyaTd3iDvs7IgVqUNID31tinG7fFWoQBTjFB0v3X
 HAczm/TOAy9g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 11:41:40 -0700
IronPort-SDR: VEZfRswUS/KVAU8v0krBpSBjk+yroyuqK7k44DkO5wcStSykjoRRbBKB/pBMrKzTWimB/4jVyW
 VXbfE0ZEUOSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,364,1583222400"; 
   d="scan'208";a="249375814"
Received: from yyu32-desk.sc.intel.com ([143.183.136.146])
  by orsmga007.jf.intel.com with ESMTP; 07 May 2020 11:41:39 -0700
Message-ID: <605779b67af22009111aa9eda287026327d070d0.camel@intel.com>
Subject: Re: [PATCH] x86/fpu/xstate: Clear uninitialized xstate areas in
 core dump
From:   Yu-cheng Yu <yu-cheng.yu@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Rik van Riel <riel@surriel.com>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     sam <sunhaoyl@outlook.com>, Kees Cook <keescook@chromium.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Date:   Thu, 07 May 2020 11:41:43 -0700
In-Reply-To: <87lfm3ehbd.fsf@nanos.tec.linutronix.de>
References: <20200507164904.26927-1-yu-cheng.yu@intel.com>
         <87lfm3ehbd.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-05-07 at 20:22 +0200, Thomas Gleixner wrote:
> Yu-cheng Yu <yu-cheng.yu@intel.com> writes:
> > @@ -983,6 +983,7 @@ int copy_xstate_to_kernel(void *kbuf, struct xregs_state *xsave, unsigned int of
> >  {
> >  	unsigned int offset, size;
> >  	struct xstate_header header;
> > +	int last_off;
> >  	int i;
> >  
> >  	/*
> > @@ -1006,7 +1007,17 @@ int copy_xstate_to_kernel(void *kbuf, struct xregs_state *xsave, unsigned int of
> >  
> >  	__copy_xstate_to_kernel(kbuf, &header, offset, size, size_total);
> >  
> > +	last_off = 0;
> > +
> >  	for (i = 0; i < XFEATURE_MAX; i++) {
> > +		/*
> > +		 * Clear uninitialized area before XSAVE header.
> > +		 */
> > +		if (i == FIRST_EXTENDED_XFEATURE) {
> > +			memset(kbuf + last_off, 0, XSAVE_HDR_OFFSET - last_off);
> > +			last_off = XSAVE_HDR_OFFSET + XSAVE_HDR_SIZE;
> > +		}
> > +
> >  		/*
> >  		 * Copy only in-use xstates:
> >  		 */
> > @@ -1020,11 +1031,16 @@ int copy_xstate_to_kernel(void *kbuf, struct xregs_state *xsave, unsigned int of
> >  			if (offset + size > size_total)
> >  				break;
> >  
> > +			memset(kbuf + last_off, 0, offset - last_off);
> > +			last_off = offset + size;
> > +
> >  			__copy_xstate_to_kernel(kbuf, src, offset, size, size_total);
> >  		}
> >  
> >  	}
> >  
> > +	memset(kbuf + last_off, 0, size_total - last_off);
> 
> Why doing all this partial zeroing? There is absolutely no point.
> 
> Either the caller clears the buffer or this function clears it right at
> the beginning with:
> 
>     memset(kbuf, 0, min(size_total, XSAVE_MAX_SIZE));

I was concerned that the XSAVES buffer can be large, but this is not in a
performance-critical path.  Yes, clear it in the beginning is simpler.

Yu-cheng

