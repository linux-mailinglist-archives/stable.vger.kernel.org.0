Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBA326BFFE
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 11:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgIPJAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 05:00:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:55062 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgIPJAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 05:00:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 40B73ADBD;
        Wed, 16 Sep 2020 09:00:50 +0000 (UTC)
Date:   Wed, 16 Sep 2020 11:00:32 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     peterz@infradead.org
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
Message-ID: <20200916090032.GO29778@kitsune.suse.cz>
References: <20200915084302.GG29778@kitsune.suse.cz>
 <20200915180659.12503-1-msuchanek@suse.de>
 <20200915181642.GF2674@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915181642.GF2674@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 08:16:42PM +0200, peterz@infradead.org wrote:
> On Tue, Sep 15, 2020 at 08:06:59PM +0200, Michal Suchanek wrote:
> > This reverts commit 116ac378bb3ff844df333e7609e7604651a0db9d.
> > 
> > This commit causes the kernel to oops and reboot when injecting a SLB
> > multihit which causes a MCE.
> > 
> > Before this commit a SLB multihit was corrected by the kernel and the
> > system continued to operate normally.
> > 
> > cc: stable@vger.kernel.org
> > Fixes: 116ac378bb3f ("powerpc/64s: machine check interrupt update NMI accounting")
> > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> 
> Ever since 69ea03b56ed2 ("hardirq/nmi: Allow nested nmi_enter()")
> nmi_enter() supports nesting natively.

And this patch was merged in parallel with this native nesting support
and conflicted with it - hence the explicit nesting in the hunk that did
not conflict.

Either way the bug is present on kernels both with and without
69ea03b56ed2. So besides the conflict 69ea03b56ed2 does not affect this
problem.

Thanks

Michal
