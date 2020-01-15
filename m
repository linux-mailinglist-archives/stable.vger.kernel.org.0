Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C410013C801
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgAOPhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:37:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53868 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgAOPhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:37:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0bpDRjXDgFG2TfuKfxIfpykpkn08PZenEGMh5CtbKpw=; b=sCH1FwbG9rGyq2V808PjdSuup
        d7YyNhlxZt/tPmzOj0EU51pbvwxu+cN/N9srqAtR3PLmO+HJy5Z+M1c7wSx4pjMEa5j60sCeaQxlq
        SaJ2VHi3CnYl1MUYwV547WD5Wd7mD2fPc1Vn51vQTzbzTpoGyEM6f/7CvT7V18El3GNfe0aXubfGH
        wbD6WBhwC9kDjjCgp42Lm4taObpkieKUWDu1QkYbFS9dRgUWnqCbFjeA8jc5x+gE2SkT7EsNp3E/E
        Mbhxk6ZyHBoiUIw/myvqqnvfpBKwiKne/XW0xBQMhVMp9OVIK7ha0ceKyDIeryyjTjN+cSf9RVpPH
        CjEgrOsvQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irkjc-0007vc-5f; Wed, 15 Jan 2020 15:37:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 626B2305EEC;
        Wed, 15 Jan 2020 16:35:54 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 989DE20137C8A; Wed, 15 Jan 2020 16:37:30 +0100 (CET)
Date:   Wed, 15 Jan 2020 16:37:30 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Waiman Long <longman@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] locking/rwsem: Fix kernel crash when spinning on
 RWSEM_OWNER_UNKNOWN
Message-ID: <20200115153730.GO2827@hirez.programming.kicks-ass.net>
References: <20200114190303.5778-1-longman@redhat.com>
 <20200115065055.GA21219@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115065055.GA21219@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 07:50:55AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 14, 2020 at 02:03:03PM -0500, Waiman Long wrote:
> > The commit 91d2a812dfb9 ("locking/rwsem: Make handoff writer
> > optimistically spin on owner") will allow a recently woken up waiting
> > writer to spin on the owner. Unfortunately, if the owner happens to be
> > RWSEM_OWNER_UNKNOWN, the code will incorrectly spin on it leading to a
> > kernel crash. This is fixed by passing the proper non-spinnable bits
> > to rwsem_spin_on_owner() so that RWSEM_OWNER_UNKNOWN will be treated
> > as a non-spinnable target.
> > 
> > Fixes: 91d2a812dfb9 ("locking/rwsem: Make handoff writer optimistically spin on owner")
> > 
> > Reported-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Waiman Long <longman@redhat.com>
> 
> This survives all the tests that showed the problems with the original
> code:
> 
> Tested-by: Christoph Hellwig <hch@lst.de>

Thanks!
