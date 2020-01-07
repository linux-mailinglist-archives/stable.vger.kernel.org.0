Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33FC6132E1D
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 19:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgAGSOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 13:14:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728364AbgAGSOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 13:14:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 311AE20715;
        Tue,  7 Jan 2020 18:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578420892;
        bh=u2Kqw8PPemCe4zQiWmOSOhxfqhSK/8TcMxfKRSHQtjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MvbMlhifBE3SWsovXgCgiGyYvN8MJKNOHONSdsRph2/JQmXN1InAAVYrL/3er5QwN
         IeroUd9iZoWiLWWrqwJThVnMBPQSDUmQRyZF7IJowQ/Q6sI//N5PDaZkRKoSdCTRC7
         X6gmL9oG5S+rhnvaWAomn/T4sDChdK/qWwXAFL/I=
Date:   Tue, 7 Jan 2020 19:14:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Sasha Levin <sashal@kernel.org>,
        Jari Ruusu <jariruusu@users.sourceforge.net>,
        stable <stable@vger.kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [stable] x86/atomic functions missing memory clobber
Message-ID: <20200107181450.GA2014625@kroah.com>
References: <90b417dcc1db1dfa637d9369af237879dda97e96.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90b417dcc1db1dfa637d9369af237879dda97e96.camel@decadent.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 05:48:55PM +0000, Ben Hutchings wrote:
> I noticed that backports of commit 69d927bba395 "x86/atomic: Fix
> smp_mb__{before,after}_atomic()" didn't touch atomic_or_long() (present
> in 3.16) or atomic_inc_short() (present in 4.9 and earlier).
> 
> These functions were only implemented on x86 and not actually used in-
> tree.  But it's possible they are used by some out-of-tree module, and
> that commit removed compiler barriers for them.
> 
> Would it might make sense to either
> 1. Add the memory clobber to these functions, or
> 2. Delete them
> on the affected stable branches?

Looks like we can drop atomic_inc_short for 4.9 as there are no users,
same for 4.4.  I'll go do that now.  It's not like the "fix" is really
needed here because of that :)

Good catch!

thanks,

greg k-h
