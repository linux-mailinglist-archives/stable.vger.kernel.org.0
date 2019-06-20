Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5984CA49
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 11:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbfFTJI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 05:08:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:42028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725875AbfFTJI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 05:08:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 515E1ACAE;
        Thu, 20 Jun 2019 09:08:28 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 01F7C1E434D; Thu, 20 Jun 2019 11:08:27 +0200 (CEST)
Date:   Thu, 20 Jun 2019 11:08:27 +0200
From:   Jan Kara <jack@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+10007d66ca02b08f0e60@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.1 35/70] loop: Don't change loop device under
 exclusive opener
Message-ID: <20190620090827.GJ13630@quack2.suse.cz>
References: <20190608113950.8033-1-sashal@kernel.org>
 <20190608113950.8033-35-sashal@kernel.org>
 <20190610090013.GF12765@quack2.suse.cz>
 <20190619201136.GD2226@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619201136.GD2226@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 19-06-19 16:11:36, Sasha Levin wrote:
> On Mon, Jun 10, 2019 at 11:00:13AM +0200, Jan Kara wrote:
> > On Sat 08-06-19 07:39:14, Sasha Levin wrote:
> > > From: Jan Kara <jack@suse.cz>
> > > 
> > > [ Upstream commit 33ec3e53e7b1869d7851e59e126bdb0fe0bd1982 ]
> > 
> > Please don't push this to stable kernels because...
> 
> I've dropped this, but...

OK, thanks.

> > > [Deliberately chosen not to CC stable as a user with priviledges to
> > > trigger this race has other means of taking the system down and this
> > > has a potential of breaking some weird userspace setup]
> > 
> > ... of this. Thanks!
> 
> Can't this be triggered by an "innocent" user, rather as part of an
> attack? Why can't this race happen during regular usage?

Well, the problem happens when mount happens on loop device when someone
modifies the backing file of the loop device. So for this to be
triggerable, you have to have control over assignment of backing files to
loop devices (you have to be owner of these loop devices to be able to do
this - pretty much means root in most setups) and be able to trigger mount
on this device. If you have these capabilities, there are much more
efficient ways to gain full administrator priviledges on the system,
deadlocking the kernel is thus the least of your worries.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
