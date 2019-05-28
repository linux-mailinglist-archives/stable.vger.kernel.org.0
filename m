Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB292BFAE
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 08:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfE1Gve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 02:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfE1Gve (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 02:51:34 -0400
Received: from localhost (unknown [77.241.229.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0889D2070D;
        Tue, 28 May 2019 06:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559026293;
        bh=jaVR2fAWQIGLBancWOip8VxvqvVyJP0u6xW6NyHAXkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pm7DDqDu69zW5XSkEkV9y+GyQHWsK7tpfW3PcPkGUxZFJHinryNrAMtESKatkl2Se
         ufwb4qEhVgIjsLkXYAn0k5dyXlDVY1dfYjsFkXtg6oVOMzqeAG4eRxM7cMYDXLF89y
         2S7IjLuwzR2YzqUQUkU2euy0L7953BiACnOteVaE=
Date:   Tue, 28 May 2019 08:51:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Todd Kjos <tkjos@android.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] binder: fix race between munmap() and direct reclaim
Message-ID: <20190528065131.GA2623@kroah.com>
References: <1558991372.2631.10.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1558991372.2631.10.camel@codethink.co.uk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 27, 2019 at 10:09:32PM +0100, Ben Hutchings wrote:
> There are commits in the 4.14, 4.19 and 5.0 stable branches that claim
> to be backports of:
> 
> commit 26528be6720bb40bc8844e97ee73a37e530e9c5e
> Author: Todd Kjos <tkjos@android.com>
> Date:   Thu Feb 14 15:22:57 2019 -0800
> 
>     binder: fix handling of misaligned binder object
> 
> However the source changes actually match:
> 
> commit 5cec2d2e5839f9c0fec319c523a911e0a7fd299f
> Author: Todd Kjos <tkjos@android.com>
> Date:   Fri Mar 1 15:06:06 2019 -0800
> 
>     binder: fix race between munmap() and direct reclaim
> 
> So far as I can see, the former fixes a bug only introduced in 5.1 and
> the latter fixes an older bug, so the changes are correct and only the
> metadata is not.
> 
> Similar mix-ups have happened before and I'm a little disturbed that
> this keeps happening.  In any case, you may want to revert and re-apply 
> with correct metadata.

Note, these backports came directly from Todd, so he can provide more
information about them.  Todd, did something get messed up on your end
and do we need to include another patch to fix this up?

thanks,

greg k-h
