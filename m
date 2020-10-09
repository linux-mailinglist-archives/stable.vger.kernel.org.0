Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096A82885E2
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 11:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731537AbgJIJWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 05:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731262AbgJIJWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 05:22:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF27C20782;
        Fri,  9 Oct 2020 09:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602235370;
        bh=9QDbQhMPmGQEhEsMut7dl1bPrUJtCAztPvmny1cCtMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AFe+vqsB3QPkMjrCCaRz9Q4xFhFIVVNGBHQDq1oKY3HO0BlgLsTHZG7Kisx9QL9PV
         Lm8FML7/l5jjyWi8yGKq+SJFyKul92+40Ik9P2sm/Wnzmg3iomhBBcCTwM7eCTnqDG
         6EQEOhrtJMvQOpxT8t4HyI6J30/V80gCyLNGFHP8=
Date:   Fri, 9 Oct 2020 11:23:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Stable backport request for fixing the issue of not being able
 to create a new pid_ns
Message-ID: <20201009092336.GA415570@kroah.com>
References: <20201008130021.79829-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008130021.79829-1-wenyang@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 08, 2020 at 09:00:21PM +0800, Wen Yang wrote:
> After the process exits, the following three dentries still refer to the pid:
> /proc/<pid>
> /proc/<pid>/ns
> /proc/<pid>/ns/pid
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=208613
> 
> According to the commit f333c700c610 ("pidns: Add a limit on the number of
> pid namespaces"), if the pid cannot be released, it may result in the
> inability to create a new pid_ns.
> 
> Please backport the following patches to the kernel stable trees (from 4.9.y
> to 5.6.y):
> 7bc3e6e55acf ("proc: Use a list of inodes to flush from proc")
> 26dbc60f385f ("proc: Generalize proc_sys_prune_dcache into proc_prune_siblings_dcache")
> f90f3cafe8d5 ("proc: Use d_invalidate in proc_prune_siblings_dcache")
> 
> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

How well did you test these backports?  I see at least one fix for them
that you missed, odds are there might have been more.  Please verify
that the above list of patches _really_ is what you want to have
applied, and that you have tested it properly.

thanks,

greg k-h
