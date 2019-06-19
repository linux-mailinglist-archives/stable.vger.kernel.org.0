Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737F44B371
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 09:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731261AbfFSH5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 03:57:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41886 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731260AbfFSH5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 03:57:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=O9PX4Evk9ozBEp0+hOqHmr/yxryDhmYRUg7Ro6SH9UI=; b=FF6UGkhSjGG997X0qq7M0m91t
        IvKA3fuh/rw4lUT3Om9KPynfH6Rut/mKt18gfYyZaImUJL21usi2rVlgL9tdDF/mRcGySqtDij9ST
        thDDaue3m6Sj581sfYa2ysp4Z3Yx+SgRv2tytQCED29VZMaTi/jTifts1f7/VPRnSal8w0eHSG8Ia
        QGpMt3RZIbsD5e0AUq8Dv5y5Y5oKS6LWlQyzzp/b56JmFJRaj/+ByXEq9dNzS2/y66oM3E0pWmPDH
        T2xtsuH28GZqHrZlP9PvkbKEv8m+mjdSgOTrkjIKrgqowqeIf8T9HoF4GUcKDrtc3X3ZAeFge8y7u
        8PUe00bAw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hdVSs-0006qJ-Bi; Wed, 19 Jun 2019 07:57:06 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BE75920A4E0CD; Wed, 19 Jun 2019 09:57:03 +0200 (CEST)
Date:   Wed, 19 Jun 2019 09:57:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] ubsan: mark ubsan_type_mismatch_common inline
Message-ID: <20190619075703.GK3419@hirez.programming.kicks-ass.net>
References: <20190617123109.667090-1-arnd@arndb.de>
 <20190617140210.GB3436@hirez.programming.kicks-ass.net>
 <CAK8P3a3iwWOkMBL-H3h5aSaHKjKWFce22rvydvVE=3uMfeOhVg@mail.gmail.com>
 <fc10bc69-0628-59eb-c243-9cd1dd3b47a4@virtuozzo.com>
 <20190618135911.GR3436@hirez.programming.kicks-ass.net>
 <CAK8P3a1ZgSYMuD0Xy_fxTqzPhg=U6rqG2Lcfc+3Bni=ZijiE3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1ZgSYMuD0Xy_fxTqzPhg=U6rqG2Lcfc+3Bni=ZijiE3A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 18, 2019 at 05:06:39PM +0200, Arnd Bergmann wrote:
> On Tue, Jun 18, 2019 at 3:59 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Jun 18, 2019 at 04:27:45PM +0300, Andrey Ryabinin wrote:
> > > On 6/18/19 3:56 PM, Arnd Bergmann wrote:
> > > > On Mon, Jun 17, 2019 at 4:02 PM Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > I guess this:
> > > ccflags-y += $(DISABLE_STACKLEAK_PLUGIN)
> >
> > Or more specifically this, I guess:
> >
> > CFLAGS_ubsan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) $(DISABLE_STACKLEAK_PLUGIN)
> >
> > we'd not want to exclude all of lib/ from stackleak I figure.
> >
> > Of these two options, I think I prefer the latter, because a smaller
> > whitelist is a better whitelist and since we already disable
> > stack protector, it is only consistent to also disable stack leak.
> 
> Ok, sounds good to me. Can you send that upstream then, or should
> I write it up as a proper patch?

If you could verify it actually works that would be great, I haven't
tried to construct a failing .config yet.
