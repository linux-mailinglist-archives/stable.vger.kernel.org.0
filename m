Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFB72B6595
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgKQN45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731936AbgKQN4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 08:56:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B067FC0613CF;
        Tue, 17 Nov 2020 05:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=E24uSWfoTl4Cofu3qQrfxUps4G3LuyBx4MqJTQyuhJA=; b=rvxkhDnmXgjJbSa0RuhPokJurG
        4hj1wuzM6npD+VT1WBhyXi5yfWDwjljSh+RudYdsVi6dDwzKgRF68oomM8b+EL/c1Wts9xTk3stdm
        X+pYUQkf7P75emWj2l0M3stykyOof+6vx13/6SKZJlt8JxGH8laobVtcD4/FFEnnKPAJd0FWMxGHP
        bf0pKMf4pOfzkTcIbhm698q7Rdo4KZzXW8PTtwcUtRB53mUM84AH88jTP83QglTSLVMql8iiGsp5d
        1LuGwqCN3CF6i5dM3TKHWbwErVu+OJI5O4IQ7ztRsQ6k2rTl0hA5c/tuoi7ln0XoQ95AhfLQZP7sF
        I5tw4Tfw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kf1TE-0007V6-Mi; Tue, 17 Nov 2020 13:56:32 +0000
Date:   Tue, 17 Nov 2020 13:56:32 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mm/vunmap: add cond_resched() in
 vunmap_pmd_range"
Message-ID: <20201117135632.GA27763@infradead.org>
References: <20201105170249.387069-1-minchan@kernel.org>
 <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
 <20201107083939.GA1633068@google.com>
 <20201112200101.GC123036@google.com>
 <20201112144919.5f6b36876f4e59ebb4a99d6d@linux-foundation.org>
 <20201113162529.GA2378542@google.com>
 <20201116175323.GB3805951@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116175323.GB3805951@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Btw, I remember that the whole vmalloc magic in zsmalloc was only giving
a small benefit for a few niche use cases.  Given that it generally has
very strange interaction with the vmalloc core, including using various
APIs not used by any driver I'm going to ask once again why we can't
just drop the CONFIG_ZSMALLOC_PGTABLE_MAPPING case entirely?
