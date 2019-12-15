Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D9011FA63
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 19:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfLOS1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 13:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfLOS1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 13:27:08 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B5F1206E0;
        Sun, 15 Dec 2019 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576434427;
        bh=i+67C7dBjaT98qfPSZOYM/GpPhISDIP8eHuAFjclcZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cbpDo7F0WvUo1eGrPRmmmf3h/Yj1Z6eBRlWxu05HD2Ynv2HyJPqmmCTcAd4UWILDf
         +ibpAcR5n3lzR/XXNJUCWh18uGQ9pTwIgMjRdESw1zEugj8oe7MamYSH30YusxOdap
         e8Rw8Sy18b5J87P7WX6oHPB2pGZqLH03tRHJoJ9A=
Date:   Sun, 15 Dec 2019 13:27:06 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     Meng.Li@windriver.com, bp@suse.de, james.morse@arm.com,
        linux-edac@vger.kernel.org, mchehab@kernel.org,
        rrichter@marvell.com, stable@vger.kernel.org,
        thor.thayer@linux.intel.com, tony.luck@intel.com
Subject: Re: FAILED: patch "[PATCH] EDAC/altera: Use fast register IO for S10
 IRQs" failed to apply to 4.19-stable tree
Message-ID: <20191215182706.GL18043@sasha-vm>
References: <1576407196157167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1576407196157167@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 11:53:16AM +0100, gregkh@linuxfoundation.org wrote:
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
>From 56d9e7bd3fa0f105b6670021d167744bc50ae4fe Mon Sep 17 00:00:00 2001
>From: Meng Li <Meng.Li@windriver.com>
>Date: Thu, 21 Nov 2019 12:30:46 -0600
>Subject: [PATCH] EDAC/altera: Use fast register IO for S10 IRQs
>
>When an IRQ occurs, regmap_{read,write,...}() is invoked in atomic
>context. Regmap must indicate register IO is fast so that a spinlock is
>used instead of a mutex to avoid sleeping in atomic context:
>
>  lock_acquire
>  __mutex_lock
>  mutex_lock_nested
>  regmap_lock_mutex
>  regmap_write
>  a10_eccmgr_irq_unmask
>  unmask_irq.part.0
>  irq_enable
>  __irq_startup
>  irq_startup
>  __setup_irq
>  request_threaded_irq
>  devm_request_threaded_irq
>  altr_sdram_probe
>
>Mark it so.
>
> [ bp: Massage. ]
>
>Fixes: 3dab6bd52687 ("EDAC, altera: Add support for Stratix10 SDRAM EDAC")
>Reported-by: Meng Li <Meng.Li@windriver.com>
>Signed-off-by: Meng Li <Meng.Li@windriver.com>
>Signed-off-by: Thor Thayer <thor.thayer@linux.intel.com>
>Signed-off-by: Borislav Petkov <bp@suse.de>
>Cc: James Morse <james.morse@arm.com>
>Cc: linux-edac <linux-edac@vger.kernel.org>
>Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>Cc: Robert Richter <rrichter@marvell.com>
>Cc: stable <stable@vger.kernel.org>
>Cc: Tony Luck <tony.luck@intel.com>
>Link: https://lkml.kernel.org/r/1574361048-17572-2-git-send-email-thor.thayer@linux.intel.com

Adjusted context and queued for 4.19.

-- 
Thanks,
Sasha
