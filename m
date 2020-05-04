Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382D91C3F49
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 18:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgEDQDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 12:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgEDQDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 12:03:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AA5C061A0E;
        Mon,  4 May 2020 09:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MJiG06idgkhQ7ETomKvk+pXIhWmcVzgg6Sh67pMiRa8=; b=KSO+cu4KS04f9QMSMnoEgpz4lP
        xEUzzhMHMNy0nNQLb/oWLnGEmta0IgfeMaWPLFVU8v0KE5Q/SQ/kf7eZZQbtkWd1mh1jOtqlamJpr
        YN+qE50vHOxXepS7SXteLP+Jz8YM7GoPnzdBjtA78HfjZE5ci7Ix61JXsgZmNOz3ITCwjRyIZY+8f
        VyOZXfNmnntPRCfh/xfRBQBe6qX2/BPIpwkpCgcPE5LJxYzBjMyx5sO7eU8s1XolUvo0+SbSxsYHA
        IxtQuHWPpYcGkzHJS2c5PU+nqLHZ77pbjoE7P9V0lYxoaoYguZ5auscSJkpBNu3v2LiCVcQSeLZB2
        eIpOBNEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jVdYo-0007fF-8J; Mon, 04 May 2020 16:03:14 +0000
Date:   Mon, 4 May 2020 09:03:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, bigeasy@linutronix.de,
        tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: check to see if SIMD registers are available
 before using SIMD
Message-ID: <20200504160314.GA26373@infradead.org>
References: <20200430221016.3866-1-Jason@zx2c4.com>
 <20200501180731.GA2485@infradead.org>
 <158853721918.8377.18286963845226122104@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158853721918.8377.18286963845226122104@build.alporthouse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 03, 2020 at 09:20:19PM +0100, Chris Wilson wrote:
> > Err, why does i915 implements its own uncached memcpy instead of relying
> > on core functionality to start with?
> 
> What is this core functionality that provides movntqda?

A sensible name might be memcpy_uncached or mempcy_nontemporal.
But the important point is that this should be arch code with a common
fallback rather than hacking it up in drivers.
