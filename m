Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBD6434B36
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 14:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhJTMfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 08:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230168AbhJTMfF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 08:35:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37C7A60F57;
        Wed, 20 Oct 2021 12:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634733170;
        bh=dFn+jTdLLyp2tS25P2DzRAmAECFjBC+RanyBlBG5KVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ym7WPF0PcD+sIJ2/NlMH8sthMlViUab7AZYeota5uQ9f/JJN6hDxWvkua3nTaELL3
         eTcdYDpQPpnPO2Uiw7h06NwnXuOu0wJEkeYgPhNLPUAZZ5eaVNF71CsoQBUdE2FPBQ
         pzZbZ2gnQx535QAMD5i94WPVLryiMzfM6+PMVcYA=
Date:   Wed, 20 Oct 2021 14:32:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH stable-4.14.y] btrfs: always wait on ordered extents at
 fsync time
Message-ID: <YXAMcAnZ13E/Lmmq@kroah.com>
References: <4fb0d755f4265d71b2a0d314232e53b22067fb0b.1634624427.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fb0d755f4265d71b2a0d314232e53b22067fb0b.1634624427.git.anand.jain@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 19, 2021 at 06:38:20PM +0800, Anand Jain wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Commit b5e6c3e170b77025b5f6174258c7ad71eed2d4de upstream.
> 
> There's a priority inversion that exists currently with btrfs fsync.  In
> some cases we will collect outstanding ordered extents onto a list and
> only wait on them at the very last second.  However this "very last
> second" falls inside of a transaction handle, so if we are in a lower
> priority cgroup we can end up holding the transaction open for longer
> than needed, so if a high priority cgroup is also trying to fsync()
> it'll see latency.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/file.c | 56 ++++---------------------------------------------
>  1 file changed, 4 insertions(+), 52 deletions(-)

Now applied, thanks.

greg k-h
