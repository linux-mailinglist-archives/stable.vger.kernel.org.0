Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D4F3FE01D
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 18:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245478AbhIAQlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 12:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245406AbhIAQlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 12:41:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7F126108E;
        Wed,  1 Sep 2021 16:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630514428;
        bh=FR9i7gvAhPWX0ryUMejF81JTrmWtBca9FbRWF1GJJFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R2VG3od3qw6XFglrSzcuIOPRMvzouRUuRs6W7FJ34SewHafIvYiCnT3d3jDT1O5LS
         rk+cpHJN5IL/IP+qcPhBdaNYN0kWwGbY4Y3Kt/d1tqYx4SIoEAwt78F2uPoPig374Q
         o94SdB14MZ5j+J4yen8ZQgUxZXux2tEhlGA2CmqQ=
Date:   Wed, 1 Sep 2021 18:40:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+01985d7909f9468f013c@syzkaller.appspotmail.com,
        Alexey Gladkov <legion@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 036/103] ucounts: Increase ucounts reference counter
 before the security hook
Message-ID: <YS+s+XL0xXKGwh9a@kroah.com>
References: <20210901122300.503008474@linuxfoundation.org>
 <20210901122301.773759848@linuxfoundation.org>
 <87v93k4bl6.fsf@disp2133>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v93k4bl6.fsf@disp2133>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 09:25:25AM -0500, Eric W. Biederman wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > From: Alexey Gladkov <legion@kernel.org>
> >
> > [ Upstream commit bbb6d0f3e1feb43d663af089c7dedb23be6a04fb ]
> >
> > We need to increment the ucounts reference counter befor security_prepare_creds()
> > because this function may fail and abort_creds() will try to decrement
> > this reference.
> 
> Has the conversion of the rlimits to ucounts been backported?
> 
> Semantically the code is an improvement but I don't know of any cases
> where it makes enough of a real-world difference to make it worth
> backporting the code.
> 
> Certainly the ucount/rlimit conversions do not meet the historical
> criteria for backports.  AKA simple obviously correct patches.
> 
> The fact we have been applying fixes for the entire v5.14 stabilization
> period is a testament to the code not quite being obviously correct.
> 
> Without backports the code only affects v5.14 so I have not been
> including a Cc stable on any of the commits.
> 
> So color me very puzzled about what is going on here.

Sasha picked this for some reason, but if you think it should be
dropped, we can easily do so.

thanks,

greg k-h
