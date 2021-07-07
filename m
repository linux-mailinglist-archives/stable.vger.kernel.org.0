Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29EB3BE759
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 13:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhGGLrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 07:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbhGGLrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 07:47:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F39C061574;
        Wed,  7 Jul 2021 04:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zSY/q9amJOqIbQTwSD5jnwRuDs6SKtOJ+EYwUjO/PlU=; b=cawyPc5IAWmVl4N2zPGHcAbfCS
        Isxrsovp5U5OJ1kzcBpOFpRMy9omtLh/7Vgt4CnEBIfi5fni3UCgViMDMd0aBM4nYRUnhrO524Fac
        UTzFfSaol3EZqgAuuMLibrfXtjfRroXUz92tnlvwDwwJhI1aE1zxj9+ZoXiED45Q1IvpUlU00aq61
        LV7zp4Bh3HBZVvIpSmRAjSNo8jNCToa4sdHXB/4Mg+e0ldNVgV+9guRh3Q3YwwZeonLT1iuKoSUL1
        sruBUjqWRgMpZ0RvAs+NeQ4+YnLjhFNSlZWLragrvoDuUR260nMbOpUQvfDOnv83nX4Qnx6+V4DZt
        5n5C1Nrg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m15yK-00CMIc-Ed; Wed, 07 Jul 2021 11:44:17 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id F051C300233;
        Wed,  7 Jul 2021 13:44:07 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D71C0200D9D6C; Wed,  7 Jul 2021 13:44:07 +0200 (CEST)
Date:   Wed, 7 Jul 2021 13:44:07 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     alexander.antonov@linux.intel.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, ak@linux.intel.com, stable@vger.kernel.org,
        alexey.v.bayduraev@linux.intel.com
Subject: Re: [PATCH] perf/x86/intel/uncore: Fix IIO cleanup mapping procedure
 for SNR/ICX
Message-ID: <YOWTh20yJ6uJ8IKK@hirez.programming.kicks-ass.net>
References: <20210706090723.41850-1-alexander.antonov@linux.intel.com>
 <3d634baf-8abe-480d-61ed-ade1945324ee@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d634baf-8abe-480d-61ed-ade1945324ee@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 06, 2021 at 10:12:55AM -0400, Liang, Kan wrote:
> 
> 
> On 7/6/2021 5:07 AM, alexander.antonov@linux.intel.com wrote:
> > From: Alexander Antonov <alexander.antonov@linux.intel.com>
> > 
> > Cleanup mapping procedure for IIO PMU is needed to free memory which was
> > allocated for topology data and for attributes in IIO mapping
> > attribute_group.
> > Current implementation of this procedure for Snowridge and Icelake Server
> > platforms doesn't free allocated memory that can be a reason for memory
> > leak issue.
> > Fix the issue with IIO cleanup mapping procedure for these platforms
> > to release allocated memory.
> > 
> > Fixes: 10337e95e04c ("perf/x86/intel/uncore: Enable I/O stacks to IIO PMON mapping on ICX")
> > 
> > Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
> 
> The patch looks good to me.
> 
> Reviewed-by: Kan Liang <kan.liang@linux.intel.com>

Thanks!

---
Subject: perf/x86/intel/uncore: Fix IIO cleanup mapping procedure for SNR/ICX
From: Alexander Antonov <alexander.antonov@linux.intel.com>
Date: Tue, 06 Jul 2021 12:07:23 +0300

From: Alexander Antonov <alexander.antonov@linux.intel.com>

skx_iio_cleanup_mapping() is re-used for snr and icx, but in those
cases it fails to use the appropriate XXX_iio_mapping_group and as
such fails to free previously allocated resources, leading to memory
leaks.

Fixes: 10337e95e04c ("perf/x86/intel/uncore: Enable I/O stacks to IIO PMON mapping on ICX")
Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
[peterz: Changelog]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210706090723.41850-1-alexander.antonov@linux.intel.com
---
