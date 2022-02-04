Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3824A9436
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 07:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344894AbiBDG7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 01:59:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53370 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbiBDG7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 01:59:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B10261BE6;
        Fri,  4 Feb 2022 06:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A3DC004E1;
        Fri,  4 Feb 2022 06:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643957951;
        bh=Koi6Ulse5Mt1x9E/6G83EtttZvteqNiRxcv4XbKC0gQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iInIVnX53IjXnbRnc2NnzTmNPJjgRJRB+Y4whbOk40RJrRDWhBioUzK4+izrWEZ3J
         24Z03UEKuY05rcv328bgkCDgd5MoY6AajvufXAbr5DGzBwRXMfPXEOGLd0kmCFXQyl
         ASY1ydN3Jt89R6Vh14ji+XPjxiEkZ5lvll3ZH37E=
Date:   Fri, 4 Feb 2022 07:59:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+5ca851459ed04c778d1d@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH 4.14 2/2] can: bcm: fix UAF of bcm op
Message-ID: <YfzOtUK6H/3AAB/O@kroah.com>
References: <20220127180256.764665162@linuxfoundation.org>
 <20220127180256.840826051@linuxfoundation.org>
 <20220203204518.GA18824@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203204518.GA18824@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 03, 2022 at 09:45:18PM +0100, Pavel Machek wrote:
> Hi!
> 
> 
> > From: Ziyang Xuan <william.xuanziyang@huawei.com>
> > 
> > Stopping tasklet and hrtimer rely on the active state of tasklet and
> > hrtimer sequentially in bcm_remove_op(), the op object will be freed
> > if they are all unactive. Assume the hrtimer timeout is short, the
> > hrtimer cb has been excuted after tasklet conditional judgment which
> > must be false after last round tasklet_kill() and before condition
> > hrtimer_active(), it is false when execute to hrtimer_active(). Bug
> > is triggerd, because the stopping action is end and the op object
> > will be freed, but the tasklet is scheduled. The resources of the op
> > object will occur UAF bug.
> > 
> > Move hrtimer_cancel() behind tasklet_kill() and switch 'while () {...}'
> > to 'do {...} while ()' to fix the op UAF problem.
> 
> I don't see this commit in mainline or next kernels. What is going on
> here? Is it one of those "only needed in -stable" things? Or do we
> still need to fix it in the mainline?

Please see the stable list discussion of this commit for other branches,
it should answer your question.

thanks,

greg k-h
