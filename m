Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEEF1AF74F
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 07:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgDSFu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 01:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgDSFu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Apr 2020 01:50:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBC7321473;
        Sun, 19 Apr 2020 05:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587275457;
        bh=OpujtjGG8dpfjlYIBZ+TFu1shjM35JR+QnGzJ+UUM8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hjyj0a9kMhI6nrbpU+kwXCKeonSjiEqj+UKQ8UDBtf5xxcaDme/c3g5tbcMg1e4Gx
         ZuEtjXVFGn+ejlKdXpZ6ZghRmzN7Spw+O117e4CmTO4H5BIC3e7qWR+H94sIZiKZh6
         N+7ZSxHXsK1CnY1doJIokkkZixoa9BX9g+xkOU1w=
Date:   Sun, 19 Apr 2020 07:50:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] posix-cpu-timers: Store a reference to a
 pid not a task" failed to apply to 5.6-stable tree
Message-ID: <20200419055050.GB3535557@kroah.com>
References: <158720526370190@kroah.com>
 <871rol3r7v.fsf@x220.int.ebiederm.org>
 <20200418160513.GB1809@sasha-vm>
 <20200418173841.GD1809@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418173841.GD1809@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 18, 2020 at 01:38:41PM -0400, Sasha Levin wrote:
> On Sat, Apr 18, 2020 at 12:05:13PM -0400, Sasha Levin wrote:
> > On Sat, Apr 18, 2020 at 07:37:08AM -0500, Eric W. Biederman wrote:
> > > <gregkh@linuxfoundation.org> writes:
> > > 
> > > > The patch below does not apply to the 5.6-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > 
> > > So for anyone who cares the fix I refer to in the commit comment is the
> > > workaround that keeps the past implementation from being a real problem.
> > > 
> > > I just see this as code cleanup so I can remove the old workaround.  The
> > > old workaround will cause posix_cpu_timers_exit_group to be called early
> > > on particular variants of multi-threaded exec, resulting in the
> > > corresponding cpu clock stopping.  So this does represent a real fix.
> > > 
> > > However using a cpu timer of another process to signal things in your
> > > process is rare, and the case is breaks is only in certain obscure
> > > variations of a multi-threaded exec.  Further no one has to my knowledge
> > > complained in over a decade.
> > > 
> > > If someone sees that fix as important, and something that needs to be
> > > backported, it will be easiest to backport my earlier cleanup patches
> > > in the same series.
> > 
> > For 5.6, 5.5, and 5.4 it was enough to take:
> > 
> > 	60f2ceaa8111 ("posix-cpu-timers: Remove unnecessary locking around cpu_clock_sample_group")
> > 
> > as a dependency. Based on the commit message there it should be safe so
> > I did just that.
> 
> Ignore that, I've dropped it for now.

THanks, I agree, this should just be left alone for now.

greg k-h
