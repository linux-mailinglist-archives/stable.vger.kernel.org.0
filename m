Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7CA204276
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 23:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbgFVVOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 17:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730295AbgFVVOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 17:14:01 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 516DB20732;
        Mon, 22 Jun 2020 21:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592860440;
        bh=BTMTU6+d6zyO2mrqFhhcTukkcFGGDpZVyM+0bVsFv/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vyNiyUVxQttpvwmyP8rVSpCIn9+R7kt+3pAgm4ImKiL41Wl3Q45vw3sHqwCh3Rjz6
         fzXbY2qLqhxuN3lfkYrChik8QxdqevGY58bNDQ8y0hZmdFjs0E80tT8eL7CYVh5jfs
         FV13Jk/7gsxLx93sDPOt44aulb5amXLWSAiiJENQ=
Date:   Mon, 22 Jun 2020 17:13:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lyude@redhat.com, sean@poorly.run, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/dp_mst: Increase ACT retry timeout to
 3s" failed to apply to 5.7-stable tree
Message-ID: <20200622211359.GK1931@sasha-vm>
References: <1592849129208156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1592849129208156@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 08:05:29PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.7-stable tree.
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
>From 873a95e0d59ac06901ae261dda0b7165ffd002b8 Mon Sep 17 00:00:00 2001
>From: Lyude Paul <lyude@redhat.com>
>Date: Fri, 3 Apr 2020 15:47:15 -0400
>Subject: [PATCH] drm/dp_mst: Increase ACT retry timeout to 3s
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>Currently we only poll for an ACT up to 30 times, with a busy-wait delay
>of 100µs between each attempt - giving us a timeout of 2900µs. While
>this might seem sensible, it would appear that in certain scenarios it
>can take dramatically longer then that for us to receive an ACT. On one
>of the EVGA MST hubs that I have available, I observed said hub
>sometimes taking longer then a second before signalling the ACT. These
>delays mostly seem to occur when previous sideband messages we've sent
>are NAKd by the hub, however it wouldn't be particularly surprising if
>it's possible to reproduce times like this simply by introducing branch
>devices with large LCTs since payload allocations have to take effect on
>every downstream device up to the payload's target.
>
>So, instead of just retrying 30 times we poll for the ACT for up to 3ms,
>and additionally use usleep_range() to avoid a very long and rude
>busy-wait. Note that the previous retry count of 30 appears to have been
>arbitrarily chosen, as I can't find any mention of a recommended timeout
>or retry count for ACTs in the DisplayPort 2.0 specification. This also
>goes for the range we were previously using for udelay(), although I
>suspect that was just copied from the recommended delay for link
>training on SST devices.
>
>Changes since v1:
>* Use readx_poll_timeout() instead of open-coding timeout loop - Sean
>  Paul
>Changes since v2:
>* Increase poll interval to 200us - Sean Paul
>* Print status in hex when we timeout waiting for ACT - Sean Paul
>
>Signed-off-by: Lyude Paul <lyude@redhat.com>
>Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0.6)")
>Cc: Sean Paul <sean@poorly.run>
>Cc: <stable@vger.kernel.org> # v3.17+
>Reviewed-by: Sean Paul <sean@poorly.run>
>Link: https://patchwork.freedesktop.org/patch/msgid/20200406221253.1307209-4-lyude@redhat.com

Conflict with the kdocs change from 17e03aa8cc16 ("drm/dp_mst: Improve kdocs
for drm_dp_check_act_status()"). I've fixed it up and queued for all branches.

-- 
Thanks,
Sasha
