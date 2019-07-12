Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A28E6762A
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 23:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfGLVVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 17:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbfGLVVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 17:21:13 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D7B42146E;
        Fri, 12 Jul 2019 21:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562966472;
        bh=UfhH+qwZBH+tVJt9XqklnwhR+TQu6aQMk7iJb9IF0v0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VyTzUkFwOSGD10Gtwey/oyOtWAAxst1dmhN6RE5AaeNaVvM/b/+22UD0qVzNQATrx
         dPHaudNa72m9jBuShTX3SO2XmSAu0YvIf20RvuUJzXu6uGLkPVhYBUxVQX+cpHRr1l
         o3nJ3wtiZtrUWIHvpVcShCPJAxXOCZ2SkkbIX73s=
Date:   Fri, 12 Jul 2019 14:21:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mel Gorman <mgorman@suse.de>
Cc:     Jan Kara <jack@suse.cz>, linux-mm@kvack.org, mhocko@suse.cz,
        stable@vger.kernel.org
Subject: Re: [PATCH RFC] mm: migrate: Fix races of __find_get_block() and
 page migration
Message-Id: <20190712142111.eac6322eea55f7e8f75b7b33@linux-foundation.org>
In-Reply-To: <20190712123935.GK13484@suse.de>
References: <20190711125838.32565-1-jack@suse.cz>
        <20190711170455.5a9ae6e659cab1a85f9aa30c@linux-foundation.org>
        <20190712091746.GB906@quack2.suse.cz>
        <20190712101042.GJ13484@suse.de>
        <20190712112056.GA24009@quack2.suse.cz>
        <20190712123935.GK13484@suse.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Jul 2019 13:39:35 +0100 Mel Gorman <mgorman@suse.de> wrote:

> > So although I still think that just failing the migration if we cannot
> > invalidate buffer heads is a safer choice, just extending the private_lock
> > protected section does not seem as bad as I was afraid.
> > 
> 
> That does not seem too bad and your revised patch looks functionally
> fine. I'd leave out the tracepoints though because a perf probe would have
> got roughly the same data and the tracepoint may be too specific to track
> another class of problem. Whether the tracepoint survives or not and
> with a changelog added;
> 
> Acked-by: Mel Gorman <mgorman@techsingularity.net>
> 
> Andrew, which version do you want to go with, the original version or
> this one that holds private_lock for slightly longer during migration?

The revised version looks much more appealing for a -stable backport. 
I expect any mild performance issues can be address in the usual
fashion.  My main concern is not to put a large performance regression
into mainline and stable kernels.  How confident are we that this is
(will be) sufficiently tested from that point of view?


