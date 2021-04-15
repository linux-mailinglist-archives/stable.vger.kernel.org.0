Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296CC360A99
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 15:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhDONhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 09:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbhDONhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 09:37:23 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B32DC061574;
        Thu, 15 Apr 2021 06:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rmmd2MnkoiOz6+31WCvz2SljYBXG1ZHyCZdZS1oIPaw=; b=DGczTqARvMf/0/wZARvuJQXtcX
        fJ3VwdUbeGmOaliuJtMplXcQ/gNCn/1W3PiuUTikVMiXgZRabeYoywRbtPlp70jXwEkzsU8RAxG7y
        XH5vfGpFPib2JOZj83+F1zFn5CNsbSsroKjLSSWBBo/WvKEo1onXnApmqUkpbD846EeAvGRjytdD8
        qBI5+5kcfy7mHVlmETIorUFQScHdrqGbXYrix+/n2dE9zfUzuXJH+i94u7AaI3dw6QTjKbIGDwPwA
        Q1z8qMLCMeQ/v4DT/mqRAcevDZSCGgsafjIXbUtKuBPEOCthWDeZEIhb4PBN620wdifwP9rx+4Lwy
        2WtAvo9Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lX2Ak-00GHOV-GJ; Thu, 15 Apr 2021 13:36:42 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D9459300212;
        Thu, 15 Apr 2021 15:36:40 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AD84C2C12A6C2; Thu, 15 Apr 2021 15:36:40 +0200 (CEST)
Date:   Thu, 15 Apr 2021 15:36:40 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alison Schofield <alison.schofield@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>, brice.goglin@gmail.com
Subject: Re: [PATCH v3] x86, sched: Treat Intel SNC topology as default, COD
 as exception
Message-ID: <YHhBaDLjBOZUKCrW@hirez.programming.kicks-ass.net>
References: <20210310190233.31752-1-alison.schofield@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310190233.31752-1-alison.schofield@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 11:02:33AM -0800, Alison Schofield wrote:
> Commit 1340ccfa9a9a ("x86,sched: Allow topologies where NUMA nodes
> share an LLC") added a vendor and model specific check to never
> call topology_sane() for Intel Skylake Server systems where NUMA
> nodes share an LLC.
> 
> Intel Ice Lake and Sapphire Rapids CPUs also enumerate an LLC that is
> shared by multiple NUMA nodes. The LLC on these CPUs is shared for
> off-package data access but private to the NUMA node for on-package
> access. Rather than managing a list of allowable SNC topologies, make
> this SNC topology the default, and treat Intel's Cluster-On-Die (COD)
> topology as the exception.
> 
> In SNC mode, Sky Lake, Ice Lake, and Sapphire Rapids servers do not
> emit this warning:
> 
> sched: CPU #3's llc-sibling CPU #0 is not on the same node! [node: 1 != 0]. Ignoring dependency.
> 
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Seeing how this is basically what I gave you earlier; but now tested and
with comments on,

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Boris, will you make it happen, or you want me to queue it somewhere
x86/core like?
