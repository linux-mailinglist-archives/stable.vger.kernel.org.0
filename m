Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3DA360E7C
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhDOPQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236314AbhDOPOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 11:14:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC77C06138D;
        Thu, 15 Apr 2021 08:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kVWKbo909oEyw1O5+F9uyQZwl6DSVadkzE/zOM/nYGY=; b=Mw+w+z0fhxwqMDSYXi3WtRspJg
        ZoC9nPTiUECw/jKn+LC1X9s75jb/7LWZOVfxa8yO4GhxGGnA1qHZRAfwRSXMeKccYLPxv3XeFf5MD
        9h5PRb2Q7QySMfUbCK5GY/FEu8AZIqHL9aEB9eLfNWtuO0RRENZSj52Eq6p5i6i5oE9AvtHqqR2mc
        q5XjJyZY+8cLfYHKk35svUj62vVzrgQ+/0g3FD/GilaYvaFXDB73YdUdPo+zdHv4EfEwbapCaj959
        s2FiO0fDPjvdRYB0c8TKJwtacP0RI330vxxkxRlUF3RKxOvx3afEZHlya3B1feN39G/kmbEkbJvvg
        GGbW2Xsw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lX3fY-008jGQ-Fq; Thu, 15 Apr 2021 15:13:02 +0000
Date:   Thu, 15 Apr 2021 16:12:36 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 12/25] radix tree test suite: Fix compilation
Message-ID: <20210415151236.GA2531743@casper.infradead.org>
References: <20210415144413.165663182@linuxfoundation.org>
 <20210415144413.551014173@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415144413.551014173@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 04:48:06PM +0200, Greg Kroah-Hartman wrote:
> From: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> [ Upstream commit 7487de534dcbe143e6f41da751dd3ffcf93b00ee ]
> 
> Commit 4bba4c4bb09a added tools/include/linux/compiler_types.h which
> includes linux/compiler-gcc.h.  Unfortunately, we had our own (empty)
> compiler_types.h which overrode the one added by that commit, and
> so we lost the definition of __must_be_array().  Removing our empty
> compiler_types.h fixes the problem and reduces our divergence from the
> rest of the tools.

I don't see 4bba4c4bb09a backported to 5.10.y, so I think this will break
compilation of the radix tree test suite.  The corresponding commit for
5.11.y is good, since 5.11.y includes 4bba4c4bb09a.
