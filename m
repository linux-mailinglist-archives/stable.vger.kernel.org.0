Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91912056C7
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 18:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731723AbgFWQJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 12:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728916AbgFWQJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 12:09:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D81E2076E;
        Tue, 23 Jun 2020 16:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592928587;
        bh=ZKbW+hi2fTiFFbVApqxBlewv3AKeWsqG37V24OQP02g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SiWhfAJHF/f00FVrEd0FpvRvCX2TD56OcDhJGPQgjmTHSBJGu2m4vf1vTWhrhDhAD
         wMQ2Qpkr/kXySf5lB/9cblYRQMIs90G/rgi9Yo+wwkk1UGdwZPwPBmZJqEswMvWsWq
         HZzBV76My+uodA7mmTVcnPdQLlGftVYBK50JyH+M=
Date:   Tue, 23 Jun 2020 18:09:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     mhiramat@kernel.org, anders.roxell@linaro.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        gustavoars@kernel.org, mingo@elte.hu, mingo@kernel.org,
        naveen.n.rao@linux.ibm.com, peterz@infradead.org,
        rostedt@goodmis.org, zsun@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kprobes: Fix to protect
 kick_kprobe_optimizer() by" failed to apply to 4.9-stable tree
Message-ID: <20200623160941.GA2479375@kroah.com>
References: <159291344624382@kroah.com>
 <20200623132628.GX1931@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623132628.GX1931@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 09:26:28AM -0400, Sasha Levin wrote:
> On Tue, Jun 23, 2020 at 01:57:26PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 1a0aa991a6274161c95a844c58cfb801d681eb59 Mon Sep 17 00:00:00 2001
> > From: Masami Hiramatsu <mhiramat@kernel.org>
> > Date: Tue, 12 May 2020 17:02:56 +0900
> > Subject: [PATCH] kprobes: Fix to protect kick_kprobe_optimizer() by
> > kprobe_mutex
> > 
> > In kprobe_optimizer() kick_kprobe_optimizer() is called
> > without kprobe_mutex, but this can race with other caller
> > which is protected by kprobe_mutex.
> > 
> > To fix that, expand kprobe_mutex protected area to protect
> > kick_kprobe_optimizer() call.
> > 
> > Link: http://lkml.kernel.org/r/158927057586.27680.5036330063955940456.stgit@devnote2
> > 
> > Fixes: cd7ebe2298ff ("kprobes: Use text_poke_smp_batch for optimizing")
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: "Gustavo A . R . Silva" <gustavoars@kernel.org>
> > Cc: Anders Roxell <anders.roxell@linaro.org>
> > Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
> > Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Ziqian SUN <zsun@redhat.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> The conflict happened because we don't have 2d1e38f56622 ("kprobes: Cure
> hotplug lock ordering issues") on 4.9 and 4.4. I've fixed it up and
> queued for both branches.

Thanks for fixing this, and the other FAILED patches up as well.

greg k-h
