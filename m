Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B16264084
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 10:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgIJIux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 04:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbgIJIus (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 04:50:48 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49BBC061573;
        Thu, 10 Sep 2020 01:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eKsZkWdvIiBRnt555PJ6VzAcymBcJaI9YZ3lDNxYBks=; b=rilNWYgjFUy/9/MU1y5a6Ej2af
        Zz3OjPMQhDSVq43wUhkoi09DbKNkf8SSqSJy5eD6jLr4iA6+ld3q0o0KlLtFt9/4vHgePevUUeSdY
        Pi5d4PaG1W0JZWGiqbY8r1HKwnhhRtfUeJ/Z4jjTabOYsBuN5HfSq6ljFrP7NfADSJKq+oyjxcAU+
        12fTNz6gqkyQdSp9GFsN0m1923u+tQrYI6AEKkw2JgkGuHa3Co/rLN7p3C+5ZbbZ9kbXoYosgva3T
        Bq5znOuD1CPAsIeYR2JsKb+gVJinOUtBCCwAbT2HWVCilg3+CCtS86XgNYQFUBISMahXmkeQvJR3+
        A+c3gqQQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGIHu-0001vn-77; Thu, 10 Sep 2020 08:50:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 533183007CD;
        Thu, 10 Sep 2020 10:50:36 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 305522651245D; Thu, 10 Sep 2020 10:50:36 +0200 (CEST)
Date:   Thu, 10 Sep 2020 10:50:36 +0200
From:   peterz@infradead.org
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephane Eranian <eranian@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Stephane Eranian <stephane.eranian@google.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 3/7] arch/x86/amd/ibs: Fix re-arming IBS Fetch
Message-ID: <20200910085036.GD35926@hirez.programming.kicks-ass.net>
References: <20200908214740.18097-1-kim.phillips@amd.com>
 <20200908214740.18097-4-kim.phillips@amd.com>
 <20200910083223.GY1362448@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910083223.GY1362448@hirez.programming.kicks-ass.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 10, 2020 at 10:32:23AM +0200, peterz@infradead.org wrote:
> > @@ -363,7 +363,14 @@ perf_ibs_event_update(struct perf_ibs *perf_ibs, struct perf_event *event,
> >  static inline void perf_ibs_enable_event(struct perf_ibs *perf_ibs,
> >  					 struct hw_perf_event *hwc, u64 config)
> >  {
> > -	wrmsrl(hwc->config_base, hwc->config | config | perf_ibs->enable_mask);
> > +	u64 _config = (hwc->config | config) & ~perf_ibs->enable_mask;
> > +
> > +	/* On Fam17h, the periodic fetch counter is set when IbsFetchEn is changed from 0 to 1 */
> > +	if (perf_ibs == &perf_ibs_fetch && boot_cpu_data.x86 >= 0x16 && boot_cpu_data.x86 <= 0x18)
> > +		wrmsrl(hwc->config_base, _config);

> A better option would be to use hwc->flags, you're loading from that
> line already, so it's guaranteed hot and then you only have a single
> branch. Or stick it in perf_ibs near enable_mask, same difference.

I fixed it for you.

---

struct perf_ibs {
	struct pmu                 pmu;                  /*     0   296 */
	/* --- cacheline 4 boundary (256 bytes) was 40 bytes ago --- */
	unsigned int               msr;                  /*   296     4 */

	/* XXX 4 bytes hole, try to pack */

	u64                        config_mask;          /*   304     8 */
	u64                        cnt_mask;             /*   312     8 */
	/* --- cacheline 5 boundary (320 bytes) --- */
	u64                        enable_mask;          /*   320     8 */
	u64                        valid_mask;           /*   328     8 */
	u64                        max_period;           /*   336     8 */
	long unsigned int          offset_mask[1];       /*   344     8 */
	int                        offset_max;           /*   352     4 */
	unsigned int               fetch_count_reset_broken:1; /*   356: 0  4 */

	/* XXX 31 bits hole, try to pack */

	struct cpu_perf_ibs *      pcpu;                 /*   360     8 */
	struct attribute * *       format_attrs;         /*   368     8 */
	struct attribute_group     format_group;         /*   376    40 */
	/* --- cacheline 6 boundary (384 bytes) was 32 bytes ago --- */
	const struct attribute_group  * attr_groups[2];  /*   416    16 */
	u64                        (*get_count)(u64);    /*   432     8 */

	/* size: 440, cachelines: 7, members: 15 */
	/* sum members: 432, holes: 1, sum holes: 4 */
	/* sum bitfield members: 1 bits, bit holes: 1, sum bit holes: 31 bits */
	/* last cacheline: 56 bytes */
};

--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -89,6 +89,7 @@ struct perf_ibs {
 	u64				max_period;
 	unsigned long			offset_mask[1];
 	int				offset_max;
+	unsigned int			fetch_count_reset_broken : 1;
 	struct cpu_perf_ibs __percpu	*pcpu;
 
 	struct attribute		**format_attrs;
@@ -370,7 +371,13 @@ perf_ibs_event_update(struct perf_ibs *p
 static inline void perf_ibs_enable_event(struct perf_ibs *perf_ibs,
 					 struct hw_perf_event *hwc, u64 config)
 {
-	wrmsrl(hwc->config_base, hwc->config | config | perf_ibs->enable_mask);
+	u64 _config = (hwc->config | config) & ~perf_ibs->enable_mask;
+
+	if (perf_ibs->fetch_count_reset_broken)
+		wrmsrl(hwc->config_base, _config);
+
+ 	_config |= perf_ibs->enable_mask;
+	wrmsrl(hwc->config_base, _config);
 }
 
 /*
@@ -756,6 +763,13 @@ static __init void perf_event_ibs_init(v
 {
 	struct attribute **attr = ibs_op_format_attrs;
 
+	/*
+	 * Some chips fail to reset the fetch count when it is written; instead
+	 * they need a 0-1 transition of IbsFetchEn.
+	 */
+	if (boot_cpu_data.x86 >= 0x16 && boot_cpu_data.x86 <= 0x18)
+		perf_ibs_fetch.fetch_count_reset_broken = 1;
+
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
 
 	if (ibs_caps & IBS_CAPS_OPCNT) {
