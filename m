Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DC01B33F9
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 02:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgDVAd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 20:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDVAd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 20:33:57 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B8B02071C;
        Wed, 22 Apr 2020 00:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587515636;
        bh=TxqM84t+YiBhhonJ6CyoG7/IvvvXedW2Nyp8lwaFiKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C/DW+1hFeAsyjnZs8Ly7PqRvr82rDp3rmJAFkFvQstkDjDVvShT+Vo2e7rlvVujmm
         lWHTGSdKfEBp/BgTtT+wGbMAH8TsMKkH8NdATYkgNcPSSbp15SmoZrEYx2M/eT4sxd
         Lr9pM9SKV42xXipz57NUoyN72tqX6nFXZkQbvSwY=
Date:   Tue, 21 Apr 2020 20:33:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     Tianyu.Lan@microsoft.com, mikelley@microsoft.com,
        wei.liu@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/Hyper-V: Unload vmbus channel in hv
 panic callback" failed to apply to 4.19-stable tree
Message-ID: <20200422003355.GQ1809@sasha-vm>
References: <158748908722690@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158748908722690@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 07:11:27PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 74347a99e73ae00b8385f1209aaea193c670f901 Mon Sep 17 00:00:00 2001
>From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>Date: Mon, 6 Apr 2020 08:53:26 -0700
>Subject: [PATCH] x86/Hyper-V: Unload vmbus channel in hv panic callback
>
>When kdump is not configured, a Hyper-V VM might still respond to
>network traffic after a kernel panic when kernel parameter panic=0.
>The panic CPU goes into an infinite loop with interrupts enabled,
>and the VMbus driver interrupt handler still works because the
>VMbus connection is unloaded only in the kdump path.  The network
>responses make the other end of the connection think the VM is
>still functional even though it has panic'ed, which could affect any
>failover actions that should be taken.
>
>Fix this by unloading the VMbus connection during the panic process.
>vmbus_initiate_unload() could then be called twice (e.g., by
>hyperv_panic_event() and hv_crash_handler(), so reset the connection
>state in vmbus_initiate_unload() to ensure the unload is done only
>once.
>
>Fixes: 81b18bce48af ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
>Reviewed-by: Michael Kelley <mikelley@microsoft.com>
>Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>Link: https://lore.kernel.org/r/20200406155331.2105-2-Tianyu.Lan@microsoft.com
>Signed-off-by: Wei Liu <wei.liu@kernel.org>

I've dropped the suspend/resume bits as there's no support for that in
4.19.

-- 
Thanks,
Sasha
