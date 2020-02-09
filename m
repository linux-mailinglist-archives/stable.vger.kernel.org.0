Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E45156CC0
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 22:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgBIVcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 16:32:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:37976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgBIVcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 16:32:22 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8EE720726;
        Sun,  9 Feb 2020 21:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581283941;
        bh=PHFLodw6tR6uQNFlTPe1idJuv34ACCxHthnTYX7IOnA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s9f/nvfMGGb9zo60e0AtXIlSsa81xnl6k/rk7hFOlG93D2I1yzFNNhhkS8BwCkzDA
         KhH8oile7NZ9LXGqM2ND8nmrg9uH3TkWYfORIZiF1aG+pvrNdOcBlwwgZ3yGlJNItG
         RVCOdQyPHsANKwFORH65NaruevQQZPthMCrR4Hds=
Date:   Sun, 9 Feb 2020 16:32:20 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        frankja@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: s390: do not clobber registers
 during guest reset/store" failed to apply to 4.14-stable tree
Message-ID: <20200209213220.GF3584@sasha-vm>
References: <1581251855208101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581251855208101@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 01:37:35PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 55680890ea78be0df5e1384989f1be835043c084 Mon Sep 17 00:00:00 2001
>From: Christian Borntraeger <borntraeger@de.ibm.com>
>Date: Fri, 31 Jan 2020 05:02:00 -0500
>Subject: [PATCH] KVM: s390: do not clobber registers during guest reset/store
> status
>
>The initial CPU reset clobbers the userspace fpc and the store status
>ioctl clobbers the guest acrs + fpr.  As these calls are only done via
>ioctl (and not via vcpu_run), no CPU context is loaded, so we can (and
>must) act directly on the sync regs, not on the thread context.
>
>Cc: stable@kernel.org
>Fixes: e1788bb995be ("KVM: s390: handle floating point registers in the run ioctl not in vcpu_put/load")
>Fixes: 31d8b8d41a7e ("KVM: s390: handle access registers in the run ioctl not in vcpu_put/load")
>Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>Reviewed-by: David Hildenbrand <david@redhat.com>
>Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>Link: https://lore.kernel.org/r/20200131100205.74720-2-frankja@linux.ibm.com
>Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

This was a context conflict because we don't have b9224cd7381a ("KVM:
s390: introduce defines for control registers") on 4.14. I've fixed it
and queued it up on 4.14.

-- 
Thanks,
Sasha
