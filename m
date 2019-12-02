Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E9910ED77
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 17:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfLBQtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 11:49:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbfLBQtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 11:49:11 -0500
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC45620833;
        Mon,  2 Dec 2019 16:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575305350;
        bh=dl7YPTjiSsDGSMM4fgriTyrms1OqhUdtc/Xq3QqyzSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J/xBUQMeuHZLwmelT36sfTlY7e/n6R+NyVcr5A5Zzz6op56R7pxyZO/vSZoXf9lZW
         mhbDy2wpSUZWs6Cd4muiFRvfmQ4fNm547uEE8DDqD0jU2hRu7L6m/qa1jaK2KvnR4W
         EUiJdDyMnlIG50SNc6ss9zpMuhWL+Rh5uG7snQX0=
Date:   Tue, 3 Dec 2019 01:49:03 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        stable@vger.kernel.org, Ingo Brunberg <ingo_brunberg@web.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH] nvme: Namepace identification descriptor list is optional
Message-ID: <20191202164903.GA21650@redsun51.ssa.fujisawa.hgst.com>
References: <20191202155611.21549-1-kbusch@kernel.org>
 <20191202161545.GA7434@lst.de>
 <20191202162256.GA21631@redsun51.ssa.fujisawa.hgst.com>
 <10e6520d-bc8c-94ff-00c4-32a727131b89@intel.com>
 <20191202162905.GA7683@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202162905.GA7683@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 05:29:05PM +0100, Christoph Hellwig wrote:
> On Mon, Dec 02, 2019 at 09:27:14AM -0700, Nadolski, Edmund wrote:
> >> I don't have such a controller, but many apparently do. The regression
> >> was reported here:
> >>
> >> http://lists.infradead.org/pipermail/linux-nvme/2019-December/028223.html
> >>
> >> And of course it's the SMI controller ...
> >
> > Does 5.4 show the exact error code?  Perhaps we should selectively allow 
> > just for that case?
> 
> They'll find other ways to f***ck up.  Looks like at least the controller
> in the bug report also doesn't have an subnqn and the nguid/eui64 are
> bogus.

Indeed, they will find creative ways to break it.

Customer or OEM requirments are poorly written, like "Must report NVMe
version 1.3". Nobody bothers to mention that it must also be compliant
to that version, or even realize they never cared for those features in
the first place.

Compliance testing like from UNH should have caught this before shipping
with such a device, but it's a cheap device, so maybe they skip that step.

>  I wonder if we actually do users a favour by allowing that..

I think it's too late now. We did successfully use such namespaces
before 5.4, even if they're fundamentally broken.

Johannes also commented *not* to consider these errors when this
identification was originally implemented, so either he knew vendors
screwed this up, or had the forethought to know they would.
