Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2667616BFF8
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 12:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgBYLwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 06:52:47 -0500
Received: from foss.arm.com ([217.140.110.172]:49668 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729976AbgBYLwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Feb 2020 06:52:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AF2A1063;
        Tue, 25 Feb 2020 03:52:46 -0800 (PST)
Received: from arrakis.emea.arm.com (arrakis.cambridge.arm.com [10.1.196.71])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E589E3F6CF;
        Tue, 25 Feb 2020 03:52:43 -0800 (PST)
Date:   Tue, 25 Feb 2020 11:52:41 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Shen Jing <jingx.shen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Jerry Zhang <zhangjerry@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        CC Hwang <cc.hwang@mediatek.com>,
        Loda Chou <loda.chou@mediatek.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org,
        andreyknvl@google.com
Subject: Re: [PATCH v3] usb: gadget: f_fs: try to fix AIO issue under ARM 64
 bit TAGGED mode
Message-ID: <20200225115241.GB2410978@arrakis.emea.arm.com>
References: <1582472947-22471-1-git-send-email-macpaul.lin@mediatek.com>
 <1582627315-21123-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582627315-21123-1-git-send-email-macpaul.lin@mediatek.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 25, 2020 at 06:41:55PM +0800, Macpaul Lin wrote:
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index ce1d023..728c260 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -35,6 +35,7 @@
>  #include <linux/mmu_context.h>
>  #include <linux/poll.h>
>  #include <linux/eventfd.h>
> +#include <linux/thread_info.h>
>  
>  #include "u_fs.h"
>  #include "u_f.h"
> @@ -826,6 +827,10 @@ static void ffs_user_copy_worker(struct work_struct *work)
>  	if (io_data->read && ret > 0) {
>  		mm_segment_t oldfs = get_fs();
>  
> +#if defined(CONFIG_ARM64)
> +		if (IS_ENABLED(CONFIG_ARM64_TAGGED_ADDR_ABI))
> +			set_thread_flag(TIF_TAGGED_ADDR);
> +#endif
>  		set_fs(USER_DS);
>  		use_mm(io_data->mm);
>  		ret = ffs_copy_to_iter(io_data->buf, ret, &io_data->data);

I really don't think that's the correct fix. The TIF_TAGGED_ADDR is a
per-thread property and not really compatible with use_mm(). We've had
tagged pointers in arm64 user-space since day 0 and access_ok() would
have prevented them, so this config is not something new. For some
reason, adb now passes them to the kernel (presumably because user-space
makes more use of them). If you have strong reasons not to fix it in
adb, the next best thing may be to untag the addresses in the usb gadget
driver.

-- 
Catalin
