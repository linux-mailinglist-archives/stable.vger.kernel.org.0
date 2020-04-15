Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E696A1AAEC6
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 18:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394210AbgDOQwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 12:52:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390653AbgDOQwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 12:52:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 548F420737;
        Wed, 15 Apr 2020 16:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586969536;
        bh=IA2ugHTzrgmVCXMBr8Wfpjqba7y/WPCHoDYJ23qe2L0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eVGmDfe/nvi6nOid0xazq68WV29BipvWVxEcoFaS9SzW5Gyn/+Sk0X4VTuW/d0rUb
         2+quNpUfBtDlQ8FEfgFBLCA1sxnjKku06qF6bMCLQVa/B8Qwq1CX383FXUERX1tOre
         PmdSMkPmXErJm98KdlCMay5vS4ogyp4wD20O2CC0=
Date:   Wed, 15 Apr 2020 18:52:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches to apply to stable releases
Message-ID: <20200415165214.GB3654762@kroah.com>
References: <20200415003148.GA114493@roeck-us.net>
 <20200415101542.GD2568572@kroah.com>
 <6d358d6a-3b7b-25c6-7990-5b36dd4c2d0b@roeck-us.net>
 <20200415144919.GA3646864@kroah.com>
 <20200415151356.GA260479@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415151356.GA260479@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 08:13:56AM -0700, Guenter Roeck wrote:
> On Wed, Apr 15, 2020 at 04:49:19PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Apr 15, 2020 at 07:21:44AM -0700, Guenter Roeck wrote:
> > > >> Upstream commit cc41f11a21a5 ("scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug")
> > > >>     Fixes: c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")
> > > >>     in linux-4.14.y: 3748694f1b91
> > > >>     Applies to:
> > > >>         v4.14.y
> > > > 
> > > > This also belongs to 4.19.y, 5.4.y, 5.5.y, and 5.6.y as it is cc:
> > > > stable.  But it doesn't backport cleanly to all, so I need a working
> > > > backport in order to be able to take it...
> > > > 
> > > I tracked this one down. The offending patch (c666d3be99c0) was applied
> > > to v4.16 and to v4.14.y. The script takes that as clue to request a backport;
> > > it assumes that the normal stable processs (whatever you and Sasha run to
> > > identify patches to apply) takes care of more recent releases, and doesn't
> > > look into those. This is intentional. We can change it, but I don't really
> > > want to duplicate your and Sasha's work.
> > > 
> > > Oops, and I completely forgot about 5.5 and 5.6. The script doesn't tell
> > > me (and neither about 4.9) because there is no such Chrome OS release,
> > > so I have to check those manually.
> > > 
> > > Either case, the patch applies cleanly to 4.19.y and later for me.
> > > Did you see conflicts, or build problems, when trying to apply it ?
> > 
> > When trying to patch 4.19.y:
> > 	checking file drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > 	Hunk #1 succeeded at 9919 (offset 11 lines).
> > 	Hunk #2 FAILED at 9992.
> > 	1 out of 2 hunks FAILED
> > 
> 
> Interesting. Both "git cherry-pick" and "git am" (I don't even need
> "git am -3") on top of v4.19.115 work fine for me. But, yes, trying
> to apply the patch using the patch command does indeed fail with this
> error. Wonder what git does differently when running "git am".

Odd, let me dig into that, I can do a 'cherry-pick' and then export it
as a patch, I've had to do that before...

thanks,

greg k-h
