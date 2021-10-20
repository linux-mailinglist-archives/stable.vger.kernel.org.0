Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60470434B3D
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 14:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJTMgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 08:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhJTMgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 08:36:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46CB661355;
        Wed, 20 Oct 2021 12:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634733273;
        bh=G4GUQ+w8NONm640Rrog7HaHzN/ybtN9Pv2COiQ93RkQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fGrBvlYr9IZtRLGQmQiEMsFtdIyD/6NxlfK+l4oPS0RaLufkHmFiIuFAlcDOQgc40
         xDbIMuX2Gl67LujWGPtxN5xidewqRUYcBpJLrw0iyjAgoLzkUmgzdSOLKPogWS22JN
         CMpos7DK/FOrKjGC34PMQ1to55XJXNYVBX6iGd/0=
Date:   Wed, 20 Oct 2021 14:34:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     stable@vger.kernel.org, jens.wiklander@linaro.org,
        sudeep.holla@arm.com
Subject: Re: [PATCH backport for 5.4] tee: optee: Fix missing devices
 unregister during optee_remove
Message-ID: <YXAM1xA86BWW6jKu@kroah.com>
References: <20211019094532.470845-1-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019094532.470845-1-sumit.garg@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 19, 2021 at 03:15:32PM +0530, Sumit Garg wrote:
> upstream commit 7f565d0ead26
> 
> When OP-TEE driver is built as a module, OP-TEE client devices
> registered on TEE bus during probe should be unregistered during
> optee_remove. So implement optee_unregister_devices() accordingly.
> 
> Fixes: c3fa24af9244 ("tee: optee: add TEE bus device enumeration support")
> Reported-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> [SG: backport to 5.4, dev name s/optee-ta/optee-clnt/]
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>  drivers/tee/optee/core.c          |  3 +++
>  drivers/tee/optee/device.c        | 22 ++++++++++++++++++++++
>  drivers/tee/optee/optee_private.h |  1 +
>  3 files changed, 26 insertions(+)

Doesn't this also need to go into 5.10 and 5.14?  We can not have people
upgrading and having regressions.

Can you provide backports for those trees too?  I can not take just this
one, sorry.

thanks,

greg k-h
