Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713F82CD40D
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 11:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388994AbgLCKzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 05:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387870AbgLCKzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 05:55:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B5AC061A4D;
        Thu,  3 Dec 2020 02:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9XAdOW0NAX0z97TKLA8+FaheS9mZEC++RheCYzCJiC0=; b=KKTMVrk2lo1kupWYSi6GnJ50BP
        bbFlrFd213SadLnGexgRgxCz6XGnrCowFQbZYP0Ek8+TnQmvse7dy5OKwmn3pXSROdY1BzfrmJGB7
        WW45gsa7uqgVDk/WxaN9QYY8s+hVcAKPMCMPVFg2fu9KPvvCsD0GvKgR/MmFKuTbob/dBDcKLVx5B
        P4sgOAspA60qV3ACg3l+Xcm5i655Z8KcWvX8nWRsfPX46HdLgl5RGBnPSVO5i2BEUZohg7qg0CNNo
        nWKWXZKL375ibiXy3GHDnLyLwKh1LD+IWnvr+atfzHA8HHC/BA61aXGhVhSOPkC/SH6irn6M9BAc8
        ZESKvs0w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkmFV-0001La-1V; Thu, 03 Dec 2020 10:54:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3C29D305C11;
        Thu,  3 Dec 2020 11:54:07 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 26E2820C22F92; Thu,  3 Dec 2020 11:54:07 +0100 (CET)
Date:   Thu, 3 Dec 2020 11:54:07 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Yi Zhang <yi.zhang@redhat.com>,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org,
        willy@infradead.org
Subject: Re: [PATCH] x86/mm: Fix leak of pmd ptlock
Message-ID: <20201203105407.GL2414@hirez.programming.kicks-ass.net>
References: <160697689204.605323.17629854984697045602.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160697689204.605323.17629854984697045602.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 02, 2020 at 10:28:12PM -0800, Dan Williams wrote:
> pmd_free() is close, but it is a messy fit due to requiring an @mm arg.

Hurpm, only parisc and s390 actually use that argument. And s390
_really_ needs it, because they're doing runtime folding per mm.

