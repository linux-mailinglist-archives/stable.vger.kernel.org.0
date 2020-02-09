Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADDE156C03
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 19:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgBISTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 13:19:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727427AbgBISTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 13:19:19 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B6AE20715;
        Sun,  9 Feb 2020 18:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581272359;
        bh=P/WZrOdRJNZ17aogMuHV4OMW03xsFMdRZPPA5w4rGrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WRZdHZDf5c/6HMm6xDDwhXXlMSyOyZeZK8i5X/NTjqT0NxjY9Hg25iQ+hCTAsNmxv
         RVcYWv6iV9PEFcE5zES7Zd7dPNJSNzs1SX/tLJscHnzKnFRwnRtcytX9zfsgKovVs1
         rYF+eOP/awU3CHubrfwpENDBWST0l8Tew6kEQng4=
Date:   Sun, 9 Feb 2020 13:19:18 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] media: cec: check 'transmit_in_progress',
 not 'transmitting'" failed to apply to 5.5-stable tree
Message-ID: <20200209181918.GO3584@sasha-vm>
References: <158124888510314@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158124888510314@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:48:05PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
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
>From d51224b73d18d207912f15ad4eb7a4b456682729 Mon Sep 17 00:00:00 2001
>From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>Date: Wed, 11 Dec 2019 12:47:57 +0100
>Subject: [PATCH] media: cec: check 'transmit_in_progress', not 'transmitting'
>
>Currently wait_event_interruptible_timeout is called in cec_thread_func()
>when adap->transmitting is set. But if the adapter is unconfigured
>while transmitting, then adap->transmitting is set to NULL. But the
>hardware is still actually transmitting the message, and that's
>indicated by adap->transmit_in_progress and we should wait until that
>is finished or times out before transmitting new messages.
>
>As the original commit says: adap->transmitting is the userspace view,
>adap->transmit_in_progress reflects the hardware state.
>
>However, if adap->transmitting is NULL and adap->transmit_in_progress
>is true, then wait_event_interruptible is called (no timeout), which
>can get stuck indefinitely if the CEC driver is flaky and never marks
>the transmit-in-progress as 'done'.
>
>So test against transmit_in_progress when deciding whether to use
>the timeout variant or not, instead of testing against adap->transmitting.
>
>Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>Fixes: 32804fcb612b ("media: cec: keep track of outstanding transmits")
>Cc: <stable@vger.kernel.org>      # for v4.19 and up
>Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Duplicate commit:

ac479b51f3f4 ("media: cec: check 'transmit_in_progress', not 'transmitting'")
d51224b73d18 ("media: cec: check 'transmit_in_progress', not 'transmitting'")

-- 
Thanks,
Sasha
