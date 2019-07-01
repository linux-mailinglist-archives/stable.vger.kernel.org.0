Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD815B6B6
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 10:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfGAIWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 04:22:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33170 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbfGAIWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 04:22:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hHxh7hxf/C/2tThRjcvY3tDwP0bpGNzg5vvFRY9dbkM=; b=XTAilpBMYs8Tjbgyb9pk9hVYc
        2435zWi+B8kTuiJ9D2a/oqmBMwLzvZygPOJf85+xEvGgZYXQNz+9vNldxE3U+w/sxQxnBS1zUEOJH
        v1n4p48hiBJ0U2LQXEXnt09rhBBFYljwR0os4TDBYkcXrOK/AQzQGozg2+IXZZFLBrIWC7U5XXtgh
        Jru8UuojQtFyqUsJ/gPFA0ROTENRHLx+L3eAYgMPhQ8/hNqZ8xk1Ld2gt11wl9yKgv0BEmTF+htkX
        sKsDPW98YLq1PE4uvB8+bBKYls1ldZDN/Ki0ZTJSiF9QgzEUQaN66jxhiuIe6XxYw6/qX8Caaz2l4
        oAmma9fBA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hhrZO-0004Z8-Gk; Mon, 01 Jul 2019 08:21:51 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D653F20963E24; Mon,  1 Jul 2019 10:21:48 +0200 (CEST)
Date:   Mon, 1 Jul 2019 10:21:48 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Phillips, Kim" <kim.phillips@amd.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Martin Liska <mliska@suse.cz>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>, Pu Wen <puwen@hygon.cn>,
        Stephane Eranian <eranian@google.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/2 RESEND3] perf/x86/amd/uncore: Do not set ThreadMask
 and SliceMask for non-L3 PMCs
Message-ID: <20190701082148.GN3402@hirez.programming.kicks-ass.net>
References: <20190628215906.4276-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628215906.4276-1-kim.phillips@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 09:59:20PM +0000, Phillips, Kim wrote:
> From: Kim Phillips <kim.phillips@amd.com>
> 
> Commit d7cbbe49a930 ("perf/x86/amd/uncore: Set ThreadMask and SliceMask
> for L3 Cache perf events") enables L3 PMC events for all threads and
> slices by writing 1s in ChL3PmcCfg (L3 PMC PERF_CTL) register fields.
> 
> Those bitfields overlap with high order event select bits in the Data
> Fabric PMC control register, however.
> 
> So when a user requests raw Data Fabric events (-e amd_df/event=0xYYY/),
> the two highest order bits get inadvertently set, changing the counter
> select to events that don't exist, and for which no counts are read.
> 
> This patch changes the logic to write the L3 masks only when dealing
> with L3 PMC counters.
> 
> AMD Family 16h and below Northbridge (NB) counters were not affected.


Thanks!
