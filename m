Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1F9B1418DA
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 19:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgARSFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 13:05:34 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50843 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgARSFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 13:05:34 -0500
Received: by mail-wm1-f65.google.com with SMTP id a5so10471436wmb.0;
        Sat, 18 Jan 2020 10:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jd8LOECtGgkjQMzMELux70cWFLm7vLIXL4uMj5c+Mc4=;
        b=ppRY61cluOh/i7kCa+pc0aMlJG19WXrLn2uCj6i+5EZVSAF6ZLoXNZcXUrDyjKOGFz
         166xcAlAeR7kqtUslev2cUmUa8m8JUYidG1OMCEPi23dhmWMKSJW1kneupbMv0xSiwk3
         fULR8JHaIuedXStAENnQ06JcCrsSf+mDPfNpYsIVuB32EmJkQQ6AHJLsQRKXiwLWd09Z
         8Bu0Piw3OS5xZ0ZflhV2d1syR8QMmHlu8JxW+zIeTRJZ9amLpzouiABWf9oMCaO8zP6c
         s9hqOSkf9MCFRIuOkJNDfHvJ11gTdin0JifzToRmOOaEWIFeDPH/fucm0uhHP/M7Peb2
         Xo6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=jd8LOECtGgkjQMzMELux70cWFLm7vLIXL4uMj5c+Mc4=;
        b=fFQRCXFTDs3e4Y1MxvOSDgdS7bYpv5+lgfiwmsUWJu7YWycP353b2ysBJ/F0PKiGlJ
         WDIZA/hXw8SkkfC/CnHzWfUYFR8nAMxgPU446bwphjrS/r8+2dslROFmODaZXvxo4SGt
         hGLanWsZYw0IjPg8nsyD1VLYXfh/35+NPDwdnEv12dnYHyHznJUlNQllsNPecCGbZldY
         g1YE6lm44RNE0h7cFf+33FgRfWwZ6NnLxXZjNrGb5U6dcuhcujgorKNwBnnJ3ulz4FHf
         n02cuOWzy/OUZBgmpJz4Cd9BOeuGJGJRUB+AAV8QMra0ON/nVFG4LRyDUPRuC8GDIhba
         eXAA==
X-Gm-Message-State: APjAAAVsg5jbLChs1ELvXpHdTQ1gf92fzV4ENHOp87IeLEr+mF8FB0cB
        fMmN5iOjRBwaTtxwS12b+9Q=
X-Google-Smtp-Source: APXvYqzfI4zJxPwtRvelSofy/IzZhjx9TxcmrGiih2eflAykds6fE9KLWGTshxHOAke+7NS3pGL7rQ==
X-Received: by 2002:a7b:c389:: with SMTP id s9mr10277060wmj.7.1579370731944;
        Sat, 18 Jan 2020 10:05:31 -0800 (PST)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id m10sm39740892wrx.19.2020.01.18.10.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 10:05:31 -0800 (PST)
Date:   Sat, 18 Jan 2020 19:05:29 +0100
From:   Ingo Molnar <mingo@kernel.org>
To:     Vince Weaver <vincent.weaver@maine.edu>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable kernel team <stable@vger.kernel.org>
Subject: [PATCH, v5.4] perf: Correctly handle failed perf_get_aux_event()
Message-ID: <20200118180529.GA70028@gmail.com>
References: <alpine.DEB.2.21.2001021349390.11372@macbook-air>
 <alpine.DEB.2.21.2001021418590.11372@macbook-air>
 <20200106120338.GC9630@lakrids.cambridge.arm.com>
 <alpine.DEB.2.21.2001061307460.24675@macbook-air>
 <alpine.DEB.2.21.2001161144590.29041@macbook-air>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001161144590.29041@macbook-air>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Vince Weaver <vincent.weaver@maine.edu> wrote:

> On Mon, 6 Jan 2020, Vince Weaver wrote:
> 
> > On Mon, 6 Jan 2020, Mark Rutland wrote:
> > 
> > > On Thu, Jan 02, 2020 at 02:22:47PM -0500, Vince Weaver wrote:
> > > > On Thu, 2 Jan 2020, Vince Weaver wrote:
> > > > 
> > > Vince, does the below (untested) patch work for you?
> > 
> > 
> > yes, this patch fixes things for me.
> > 
> > Tested-by: Vince Weaver <vincent.weaver@maine.edu>
> > 
> 
> is this patch going to make it upstream?  It's a fairly major correctness 
> bug with perf_event_open().

I just sent it to Linus.

In hindsight this should have been marked Cc: stable for v5.4 - we should 
forward it to Greg once Linus has pulled it:

   da9ec3d3dd0f: ("perf: Correctly handle failed perf_get_aux_event()")


Note that in the v5.4 cherry-pick there's a conflict due to interaction 
with another recent commit - I've attached the ported fix against v5.4, 
but have only test built it.

Thanks,

	Ingo

==============>
From 703595681c934d2a88a91e8a41f7f63eeb1573e0 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@kernel.org>
Date: Sat, 18 Jan 2020 19:03:55 +0100
Subject: [PATCH] perf: Correctly handle failed perf_get_aux_event()

Vince reports a worrying issue:

| so I was tracking down some odd behavior in the perf_fuzzer which turns
| out to be because perf_even_open() sometimes returns 0 (indicating a file
| descriptor of 0) even though as far as I can tell stdin is still open.

... and further the cause:

| error is triggered if aux_sample_size has non-zero value.
|
| seems to be this line in kernel/events/core.c:
|
| if (perf_need_aux_event(event) && !perf_get_aux_event(event, group_leader))
|                goto err_locked;
|
| (note, err is never set)

This seems to be a thinko in commit:

  ab43762ef010967e ("perf: Allow normal events to output AUX data")

... and we should probably return -EINVAL here, as this should only
happen when the new event is mis-configured or does not have a
compatible aux_event group leader.

Fixes: ab43762ef010967e ("perf: Allow normal events to output AUX data")
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Tested-by: Vince Weaver <vincent.weaver@maine.edu>
(cherry picked from commit da9ec3d3dd0f1240a48920be063448a2242dbd90)
---
 kernel/events/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 00a014670ed0..291fe3e2165f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11184,8 +11184,10 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	if (event->attr.aux_output && !perf_get_aux_event(event, group_leader))
+	if (event->attr.aux_output && !perf_get_aux_event(event, group_leader)) {
+		err = -EINVAL;
 		goto err_locked;
+	}
 
 	/*
 	 * Must be under the same ctx::mutex as perf_install_in_context(),
