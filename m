Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801F52E495
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 20:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfE2SgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 14:36:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfE2SgR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 14:36:17 -0400
Received: from localhost (unknown [207.225.69.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8C7A2407A;
        Wed, 29 May 2019 18:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559154976;
        bh=ZSeg4OjbfMq2wx1BLT4EqlDxwDjSEzNgc/igmTCCwgk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RsLzwjtOs6nWEmuKj5ArWepKW/mJclw0kLPSRFVtwaO5bRo3PPlcU9Fd1v5rbByTO
         hrkgaRP4pU+WLizdmmppB7RYVPwnqy1O7nE2Dz532QruQpQwmy8fKLaypifzt0GQpi
         UBGYzRMtmK/NYwSk7XBpx+Er/6lfmDrMOuXe2fMQ=
Date:   Wed, 29 May 2019 11:36:16 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Please revert "btrfs: Honour FITRIM range constraints during
 free space trim" from all stable trees
Message-ID: <20190529183616.GA9680@kroah.com>
References: <20190529112314.GY15290@suse.cz>
 <20190529113300.GB11952@kroah.com>
 <20190529165743.GA15290@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529165743.GA15290@suse.cz>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 06:57:43PM +0200, David Sterba wrote:
> On Wed, May 29, 2019 at 04:33:00AM -0700, Greg Kroah-Hartman wrote:
> > On Wed, May 29, 2019 at 01:23:14PM +0200, David Sterba wrote:
> > > Hi,
> > > 
> > > upon closer inspection we found a problem with the patch
> > > 
> > > "btrfs: Honour FITRIM range constraints during free space trim"
> > > 
> > > that has been merged to 5.1.4. This could happen with ranged FITRIM
> > > where the range is not 'honoured' as it was supposed to.
> > > 
> > > Please revert it and push in the next stable release so the buggy
> > > version is not in the wild for too long.
> > > 
> > > Affected trees:
> > > 
> > > 5.0.18
> > > 5.1.4
> > > 4.9.179
> > > 4.19.45
> > > 4.14.122
> > > 
> > > Master branch will have the revert too. Thanks.
> > 
> > What is the git commit id of the revert in Linus's tree?
> 
> Due to further changes in the code, a revert that will be in Linus'
> branch can't be backported and stable-specific patches would have to be
> provided anyway. There's a slight change in logic and handling of the
> trimmed ranges, the upstream revert removes code and updates calls to
> functions that are not in the stable branches.
> 
> So I'm going to send you patches for all the affected branches.
> 
> After analyzing the situation, the conclusion is that the patch should
> have never been tagged for stable.  The patch is in 5.2-rc ie. an
> unreleased kernel and the bug would be handled as a regression before
> 5.20 final.
> 
> The backport to stable happened before we knew that so the reverts are
> IMO the best solution we have now. I hope you understand that and sorry
> for the trouble.

No problem, reverts are all now queued up, thanks for doing them.

greg k-h
