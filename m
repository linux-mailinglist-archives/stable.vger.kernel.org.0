Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF29240DC16
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 16:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237935AbhIPOCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 10:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235843AbhIPOCK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 10:02:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 383A461244;
        Thu, 16 Sep 2021 14:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631800849;
        bh=jwJbQIBIqNOLSAaFpgPlcQdpkvQwG+9Xs+Tn8H65bgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EPIANSn0pRJztpDkuN3cBmNMXLZ1d8YdN09eGZ4SXf3qc8NcJJIebXx4A7HQ4IlFU
         8vds/IGpQ2Cl6UXxFWxhvBJrvLtPJPhUy4P6i2KFKJ5s9wXQULYbcNSVFnbmEGfCGs
         cgzt9hC4kPg85DCAH7ZFSbZa/5cvFEtNXoYVKl6M=
Date:   Thu, 16 Sep 2021 16:00:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5.10] fanotify: limit number of event merge attempts
Message-ID: <YUNOD/z1tfYDFEQX@kroah.com>
References: <20210915182008.1369659-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915182008.1369659-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 09:20:08PM +0300, Amir Goldstein wrote:
> commit b8cd0ee8cda68a888a317991c1e918a8cba1a568 upstream.
> 
> Event merges are expensive when event queue size is large, so limit the
> linear search to 128 merge tests.
> 
> [Stable backport notes] The following statement from upstream commit is
> irrelevant for backport:
> -
> -In combination with 128 size hash table, there is a potential to merge
> -with up to 16K events in the hashed queue.
> -
> [Stable backport notes] The problem is as old as fanotify and described
> in the linked cover letter "Performance improvement for fanotify merge".
> This backported patch fixes the performance issue at the cost of merging
> fewer potential events.  Fixing the performance issue is more important
> than preserving the "event merge" behavior, which was not predictable in
> any way that applications could rely on.
> 
> Link: https://lore.kernel.org/r/20210304104826.3993892-6-amir73il@gmail.com
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/linux-fsdevel/20210202162010.305971-1-amir73il@gmail.com/
> Link: https://lore.kernel.org/linux-fsdevel/20210915163334.GD6166@quack2.suse.cz/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/notify/fanotify/fanotify.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Now queued up, thanks.

greg k-h
