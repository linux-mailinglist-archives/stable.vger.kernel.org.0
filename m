Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56555E61CC
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 10:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfJ0JVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 05:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfJ0JVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 05:21:50 -0400
Received: from localhost (smb-adpcdg1-03.hotspot.hub-one.net [213.174.99.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A179520679;
        Sun, 27 Oct 2019 09:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572168109;
        bh=0/pbKqpTr5lGUr4Xz6T30pfs11oEb6XnW2Q1fgajRM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jb84wkEIvVKDCJ6XYcYr+1faM1U7A1f/esJXdEcUZ/M15t+ETJ3tHlAPBkgyoBIa5
         FljSFBEesgYf2ZHG4DeHHchlfjtWMCzOYSdnp/1RrZAqvNb+LJSdINKVjxEFdIs94S
         ldVXk/A43DvNA5/wNP0FoYDJLv4ErUdWzCpYz7Ec=
Date:   Sun, 27 Oct 2019 05:21:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     maier@linux.ibm.com, bblock@linux.ibm.com, jremus@linux.ibm.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: zfcp: fix reaction on bit error
 threshold notification" failed to apply to 4.14-stable tree
Message-ID: <20191027092146.GC1560@sasha-vm>
References: <15721645544387@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15721645544387@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 09:22:34AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From 2190168aaea42c31bff7b9a967e7b045f07df095 Mon Sep 17 00:00:00 2001
>From: Steffen Maier <maier@linux.ibm.com>
>Date: Tue, 1 Oct 2019 12:49:49 +0200
>Subject: [PATCH] scsi: zfcp: fix reaction on bit error threshold notification
>
>On excessive bit errors for the FCP channel ingress fibre path, the channel
>notifies us.  Previously, we only emitted a kernel message and a trace
>record.  Since performance can become suboptimal with I/O timeouts due to
>bit errors, we now stop using an FCP device by default on channel
>notification so multipath on top can timely failover to other paths.  A new
>module parameter zfcp.ber_stop can be used to get zfcp old behavior.
>
>User explanation of new kernel message:
>
> * Description:
> * The FCP channel reported that its bit error threshold has been exceeded.
> * These errors might result from a problem with the physical components
> * of the local fibre link into the FCP channel.
> * The problem might be damage or malfunction of the cable or
> * cable connection between the FCP channel and
> * the adjacent fabric switch port or the point-to-point peer.
> * Find details about the errors in the HBA trace for the FCP device.
> * The zfcp device driver closed down the FCP device
> * to limit the performance impact from possible I/O command timeouts.
> * User action:
> * Check for problems on the local fibre link, ensure that fibre optics are
> * clean and functional, and all cables are properly plugged.
> * After the repair action, you can manually recover the FCP device by
> * writing "0" into its "failed" sysfs attribute.
> * If recovery through sysfs is not possible, set the CHPID of the device
> * offline and back online on the service element.
>
>Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>Cc: <stable@vger.kernel.org> #2.6.30+
>Link: https://lore.kernel.org/r/20191001104949.42810-1-maier@linux.ibm.com
>Reviewed-by: Jens Remus <jremus@linux.ibm.com>
>Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
>Signed-off-by: Steffen Maier <maier@linux.ibm.com>
>Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Just context conflicts because of missing 75492a51568b9 ("s390/scsi:
Convert timers to use timer_setup()"). I've fixed it up and queued for
4.14, 4.9, and 4.4.

-- 
Thanks,
Sasha
