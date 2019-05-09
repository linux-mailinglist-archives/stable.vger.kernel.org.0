Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A68DF18F82
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 19:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfEIRnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 13:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbfEIRnf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 13:43:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9144921019;
        Thu,  9 May 2019 17:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557423815;
        bh=0ndFKL0x9lN2uxvNteiYNaHLvhAIcUQeFsEGgp8Obts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UrygVydLU+JJ2guR9hdpoCOcg43Te31Eyxwov2sc9cE7C/G9OVbwoms0t88dLpmEL
         5JaYLVt5m9Mo9LJnzGbbhubz7DsMcYpKS+4X3pMWMV05WhoeG+TQWizCYARCad4So9
         2yq9GCZO37yhEVpKhZ9Tn9yQv2fD35HxAtf6wPYo=
Date:   Thu, 9 May 2019 19:43:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 3.16-4.9] timer/debug: Change /proc/timer_stats from 0644
 to 0600
Message-ID: <20190509174332.GB17342@kroah.com>
References: <20190507190404.ub43rr4iuvqfkbsq@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507190404.ub43rr4iuvqfkbsq@decadent.org.uk>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 08:04:04PM +0100, Ben Hutchings wrote:
> The timer_stats facility should filter and translate PIDs if opened
> from a non-initial PID namespace, to avoid leaking information about
> the wider system.  It should also not show kernel virtual addresses.
> Unfortunately it has now been removed upstream (as redundant)
> instead of being fixed.
> 
> For stable, fix the leak by restricting access to root only.  A
> similar change was already made for the /proc/timer_list file.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> --- a/kernel/time/timer_stats.c
> +++ b/kernel/time/timer_stats.c
> @@ -417,7 +417,7 @@ static int __init init_tstats_procfs(voi
>  {
>  	struct proc_dir_entry *pe;
>  
> -	pe = proc_create("timer_stats", 0644, NULL, &tstats_fops);
> +	pe = proc_create("timer_stats", 0600, NULL, &tstats_fops);
>  	if (!pe)
>  		return -ENOMEM;
>  	return 0;



Now queued up, thanks.

greg k-h
