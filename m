Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B072563D1
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 09:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfFZH4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 03:56:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37888 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfFZH4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 03:56:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=liZehjV6yq2WxrgDL5h4NwlwF63olriPQGBcf7kidZk=; b=QhxqLBcNl1rG6mEsaPN11LcDl
        m33b5go99KfJxgwuiMSZXqc1ssEG023S3UUtSkCT0DILnT4j1Du6IPP7y5avepmcYmwcfAPXGRybe
        JFEXxjA+7/71H2VFnMcHoXA7M0N2zRu7r5L5VvKJAhVD+5YzRuYQbFcKB/bxFA14ZhSMeh1Cgc5sl
        nZKAqDbRGL97BAXFf5MtqvUrY4mRWMY4kSJKP/k2xf2UfxfO0mgNvJfWwtuJ0tfKOtIkAKl2G3Z4c
        7hbhWz1FhtVJD78+1CkEGc3skwsmn3pNj0cRiNRjyS1v67iKvVCqnMDVak2PxeqD4iyhFtoIlTvpK
        6guZ6U3tQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hg2mD-0006TL-KB; Wed, 26 Jun 2019 07:55:33 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4BAA6209CEE60; Wed, 26 Jun 2019 09:55:31 +0200 (CEST)
Date:   Wed, 26 Jun 2019 09:55:31 +0200
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
Subject: Re: [PATCH 1/2 RESEND2] perf/x86/amd/uncore: Do not set ThreadMask
 and SliceMask for non-L3 PMCs
Message-ID: <20190626075531.GG3419@hirez.programming.kicks-ass.net>
References: <20190625145548.11600-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625145548.11600-1-kim.phillips@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 02:56:23PM +0000, Phillips, Kim wrote:
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
> 
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

Still base64 encoded garbage; the actual email reads like below.

Please use a sane MUa and send it plain text.

---


Content-Transfer-Encoding: base64

RnJvbTogS2ltIFBoaWxsaXBzIDxraW0ucGhpbGxpcHNAYW1kLmNvbT4NCg0KQ29tbWl0IGQ3Y2Ji
ZTQ5YTkzMCAoInBlcmYveDg2L2FtZC91bmNvcmU6IFNldCBUaHJlYWRNYXNrIGFuZCBTbGljZU1h
c2sNCmZvciBMMyBDYWNoZSBwZXJmIGV2ZW50cyIpIGVuYWJsZXMgTDMgUE1DIGV2ZW50cyBmb3Ig
YWxsIHRocmVhZHMgYW5kDQpzbGljZXMgYnkgd3JpdGluZyAxcyBpbiBDaEwzUG1jQ2ZnIChMMyBQ
TUMgUEVSRl9DVEwpIHJlZ2lzdGVyIGZpZWxkcy4NCg0KVGhvc2UgYml0ZmllbGRzIG92ZXJsYXAg
d2l0aCBoaWdoIG9yZGVyIGV2ZW50IHNlbGVjdCBiaXRzIGluIHRoZSBEYXRhDQpGYWJyaWMgUE1D
IGNvbnRyb2wgcmVnaXN0ZXIsIGhvd2V2ZXIuDQoNClNvIHdoZW4gYSB1c2VyIHJlcXVlc3RzIHJh
