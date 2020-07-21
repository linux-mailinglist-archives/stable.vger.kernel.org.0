Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8E3227D30
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 12:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgGUKiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 06:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgGUKiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 06:38:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32C7C20714;
        Tue, 21 Jul 2020 10:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595327889;
        bh=1fQCmMzOPgh0C9Gmc9FWCXe+1f7NlmMKPVCg1anLdZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ahWrMj0qHP0niUAMCYp72yU0BtT17yGtmLLQCNNjWBBOCqUo6RD758nTV+BucYuCb
         /nrq5WTuqDxphdgfiNG/UdwmJ4frY+arN2e7ahbCT11G8KSYRrlM+sSrQ3bnwleHlJ
         ODnBZQ6GmhGpLRrPid7xen7U/chbScdxYZ9Fp/Qc=
Date:   Tue, 21 Jul 2020 12:38:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 041/133] Revert "usb/ohci-platform: Fix a warning
 when hibernating"
Message-ID: <20200721103818.GA1676612@kroah.com>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152805.704517976@linuxfoundation.org>
 <20200720210722.GA11552@amd>
 <20200721012943.GA406581@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721012943.GA406581@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 09:29:43PM -0400, Sasha Levin wrote:
> On Mon, Jul 20, 2020 at 11:07:22PM +0200, Pavel Machek wrote:
> > Hi!
> > On Mon 2020-07-20 17:36:28, Greg Kroah-Hartman wrote:
> > > This reverts commit c83258a757687ffccce37ed73dba56cc6d4b8a1b.
> > > 
> > > Eugeniu Rosca writes:
> > > 
> > > On Thu, Jul 09, 2020 at 09:00:23AM +0200, Eugeniu Rosca wrote:
> > > >After integrating v4.14.186 commit 5410d158ca2a50 ("usb/ehci-platform:
> > > >Set PM runtime as active on resume") into downstream v4.14.x, we started
> > > >to consistently experience below panic [1] on every second s2ram of
> > > >R-Car H3 Salvator-X Renesas reference board.
> > > >
> > > >After some investigations, we concluded the following:
> > > > - the issue does not exist in vanilla v5.8-rc4+
> > > > - [bisecting shows that] the panic on v4.14.186 is caused by the lack
> > > >   of v5.6-rc1 commit 987351e1ea7772 ("phy: core: Add consumer device
> > > >   link support"). Getting evidence for that is easy. Reverting
> > > >   987351e1ea7772 in vanilla leads to a similar backtrace [2].
> > > >
> > > >Questions:
> > > > - Backporting 987351e1ea7772 ("phy: core: Add consumer device
> > > >   link support") to v4.14.187 looks challenging enough, so probably not
> > > >   worth it. Anybody to contradict this?
> > 
> > I'm not sure about v4.14.187, but backport to v4.19 is quite simple
> > (just ignore single non-existing file) and passes basic testing.
> > 
> > Would that be better solution for 4.19 and newer?
> 
> If Eugeniu could confirm that doing so on 4.19+ works for him, sure.

For now let's revert this.

thanks,

greg k-h
