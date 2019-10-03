Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7614CA072
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 16:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfJCOgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 10:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbfJCOgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 10:36:32 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92E6220865;
        Thu,  3 Oct 2019 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570113391;
        bh=o0YYkagzBckmNkwAm8JJ/PF9Ay9gVxv32oeYnR18sUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UN7TeOT6ETVYN5sqlNJuzO4LC3QSoyZnGs+xY7F8gxhWzzdvmruyC57MBBC8csvkR
         OM38f+Ec6MvP7aM/8lIIjitL1um1zRv8Qu0Z43YL9pXag+8tee4VZLgbqx9OCerFQ6
         A2Xf1f5BgXu/qUr0o/9wRtH3Vbog1FK0feA72v4s=
Date:   Thu, 3 Oct 2019 10:36:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     pihsun@chromium.org, enric.balletbo@collabora.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] platform/chrome: cros_ec_rpmsg: Fix race
 with host command" failed to apply to 5.3-stable tree
Message-ID: <20191003143630.GC17454@sasha-vm>
References: <157010460554182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157010460554182@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 02:10:05PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
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
>From 71cddb7097e2b0feb855d7fd7d59afd12cbee4bb Mon Sep 17 00:00:00 2001
>From: Pi-Hsun Shih <pihsun@chromium.org>
>Date: Wed, 4 Sep 2019 14:26:13 +0800
>Subject: [PATCH] platform/chrome: cros_ec_rpmsg: Fix race with host command
> when probe failed
>
>Since the rpmsg_endpoint is created before probe is called, it's
>possible that a host event is received during cros_ec_register, and
>there would be some pending work in the host_event_work workqueue while
>cros_ec_register is called.
>
>If cros_ec_register fails, when the leftover work in host_event_work
>run, the ec_dev from the drvdata of the rpdev could be already set to
>NULL, causing kernel crash when trying to run cros_ec_get_next_event.
>
>Fix this by creating the rpmsg_endpoint by ourself, and when
>cros_ec_register fails (or on remove), destroy the endpoint first (to
>make sure there's no more new calls to cros_ec_rpmsg_callback), and then
>cancel all works in the host_event_work workqueue.
>
>Cc: stable@vger.kernel.org
>Fixes: 2de89fd98958 ("platform/chrome: cros_ec: Add EC host command support using rpmsg")
>Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>
>Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>

I've worked around the changes introduced by 7aa703bb88243 ("mfd /
platform: cros_ec: Handle chained ECs as platform devices"). Queued for
5.3 and 5.2.

-- 
Thanks,
Sasha
