Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF6726ABF3
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 20:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgIOSaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 14:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgIOSRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 14:17:31 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24754C06174A;
        Tue, 15 Sep 2020 11:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TpXFc9y8wD3r1ZuGpqIyIgD31aYfhCp2Mbvu/dVpBHo=; b=iQt0WubjIBcofUDJWMFR7iUupl
        lk2xCKtz3F5Vm17nRnPtlqXMG8bS9S4kr8GvCw66sUZuuFMsx0LivRNIclHnQCWgwXsm8uIkR7Wd+
        iEiiMuPsAkoCL5U8Smqu+4oDMrVwam49jLQ26TRnafXau1S8TNxQPiuCpIMvdUC8xA/xw9bnrKcjC
        mVQ66WngyHdSuno6nChX6yZRsmxhTb3+mPoo2ZHNrd+Nnhb8gJM121PUBjw1UPGG6Ki+05Pp6nmsE
        73Xeffy5TiPXq0rB92Dd6gB24GE0m1Bpmy4o7o3ALn1PuyQjptlVLR3eXnfaIrTfpn7QOtdy3gR81
        IqFLjWow==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIFVb-0002aX-1S; Tue, 15 Sep 2020 18:16:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 827993006D0;
        Tue, 15 Sep 2020 20:16:42 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4DBE3299BA20F; Tue, 15 Sep 2020 20:16:42 +0200 (CEST)
Date:   Tue, 15 Sep 2020 20:16:42 +0200
From:   peterz@infradead.org
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Santosh Sivaraj <santosh@fossix.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Ganesh Goudar <ganeshgr@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Alistair Popple <alistair@popple.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Mike Rapoport <rppt@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "powerpc/64s: machine check interrupt update NMI
 accounting"
Message-ID: <20200915181642.GF2674@hirez.programming.kicks-ass.net>
References: <20200915084302.GG29778@kitsune.suse.cz>
 <20200915180659.12503-1-msuchanek@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915180659.12503-1-msuchanek@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 08:06:59PM +0200, Michal Suchanek wrote:
> This reverts commit 116ac378bb3ff844df333e7609e7604651a0db9d.
> 
> This commit causes the kernel to oops and reboot when injecting a SLB
> multihit which causes a MCE.
> 
> Before this commit a SLB multihit was corrected by the kernel and the
> system continued to operate normally.
> 
> cc: stable@vger.kernel.org
> Fixes: 116ac378bb3f ("powerpc/64s: machine check interrupt update NMI accounting")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>

Ever since 69ea03b56ed2 ("hardirq/nmi: Allow nested nmi_enter()")
nmi_enter() supports nesting natively.
