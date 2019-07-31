Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD647BDA8
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbfGaJsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728795AbfGaJsC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:48:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D0A120665;
        Wed, 31 Jul 2019 09:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564566482;
        bh=1GdSku8tfblxX3WeTfY7xPb8cvgV04pC3fRqv17slYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bMAoS2Vfq360hMsK7C/zbKrcSIXseNEFawk0FRRQ0aQ5fvqiANyh3XjwrUU/G17Nc
         s22pPS9mmxInhKdTRb8+ekyFaJx5CUNlJwnf0Q6mK1u3vjb66YTT/zhu/Ve0dr04AR
         UtEQspFfpFXWv6bwc9fuqD2fqzCF35kjDRvSTljk=
Date:   Wed, 31 Jul 2019 11:47:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Todd Kjos <tkjos@android.com>
Cc:     tkjos@google.com, arve@android.com, maco@google.com,
        stable@vger.kernel.org, joel@joelfernandes.org,
        kernel-team@android.com
Subject: Re: [PATCH 4.14,4.19] binder: fix possible UAF when freeing buffer
Message-ID: <20190731094759.GI18269@kroah.com>
References: <20190729221606.243098-1-tkjos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729221606.243098-1-tkjos@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 03:16:06PM -0700, Todd Kjos wrote:
> From: Todd Kjos <tkjos@android.com>
> 
> commit a370003cc301d4361bae20c9ef615f89bf8d1e8a upstream
> 
> There is a race between the binder driver cleaning
> up a completed transaction via binder_free_transaction()
> and a user calling binder_ioctl(BC_FREE_BUFFER) to
> release a buffer. It doesn't matter which is first but
> they need to be protected against running concurrently
> which can result in a UAF.
> 
> Signed-off-by: Todd Kjos <tkjos@google.com>
> Cc: stable <stable@vger.kernel.org> # 4.14 4.19
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/android/binder.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)

Thanks for the backport, now queued up.

greg k-h
