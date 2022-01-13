Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EBA48D0FA
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 04:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiAMDcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 22:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbiAMDcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 22:32:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3563BC06173F;
        Wed, 12 Jan 2022 19:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YG1ESH6nM4PsW5sYKq0SmThrpwQbKs/L9zhiBvIqtao=; b=XazdFwUSjbLDBGsMkbIMs5fDI+
        3qbf1KYN1ukUyB44y5mPBO/0sAKm0WP5jcUzSZf/5OFfluqfg4Z/YGLSv3Dg3jaPPLRQT78GOJPQH
        baIuthK1t/nK9yZWkNzi2tI22/xZaH71V5m9hXQF5pzAgY6GDx6y88tQEfkVSAiB2LqHrxzMqFoaH
        xPORFdSy6zhj+FHSuhZbn3KGpyU2NOcQG5ESo/RIUnecPKfgC4HkmvPPpCwXKr9F+9mFq9998gBYF
        Vokx+Ac/y9QUJOh//2UKix6YoDsi3KviwL4J6rc3y3gudnUnCxOo5hE2jiDwaet3ACM5BjUVVQ72K
        UAiAfM9g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7qqs-004c8V-Jt; Thu, 13 Jan 2022 03:32:38 +0000
Date:   Thu, 13 Jan 2022 03:32:38 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: use compare-exchange operation to set KASAN page tag
Message-ID: <Yd+dVmATnfdMfQVN@casper.infradead.org>
References: <20220113031434.464992-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113031434.464992-1-pcc@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 07:14:34PM -0800, Peter Collingbourne wrote:
> It has been reported that the tag setting operation on newly-allocated
> pages can cause the page flags to be corrupted when performed
> concurrently with other flag updates as a result of the use of
> non-atomic operations. Fix the problem by using a compare-exchange
> loop to update the tag.

I really dislike it that kasan has taken some page flags for its use.
I would much prefer it if kasan used some page_ext_flags.  It's somewhat
slower to access them, and they take up a bit of extra space (unless
you already have CONFIG_PAGE_EXTENSION enabled).  But page flags are a
really scarce resource and kasan has taken 9.
