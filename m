Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D75173D76
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 17:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgB1Qsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 11:48:54 -0500
Received: from foss.arm.com ([217.140.110.172]:41314 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgB1Qsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 11:48:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6113031B;
        Fri, 28 Feb 2020 08:48:53 -0800 (PST)
Received: from arrakis.emea.arm.com (arrakis.cambridge.arm.com [10.1.196.71])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5E293F73B;
        Fri, 28 Feb 2020 08:48:50 -0800 (PST)
Date:   Fri, 28 Feb 2020 16:48:48 +0000
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
        andreyknvl@google.com, Peter Chen <peter.chen@nxp.com>,
        Miles Chen <miles.chen@mediatek.com>, eugenis@google.com
Subject: Re: [PATCH v4] usb: gadget: f_fs: try to fix AIO issue under ARM 64
 bit TAGGED mode
Message-ID: <20200228164848.GH4019108@arrakis.emea.arm.com>
References: <1582627315-21123-1-git-send-email-macpaul.lin@mediatek.com>
 <1582718512-28923-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582718512-28923-1-git-send-email-macpaul.lin@mediatek.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 08:01:52PM +0800, Macpaul Lin wrote:
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index ce1d023..192935f 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -715,7 +715,20 @@ static void ffs_epfile_io_complete(struct usb_ep *_ep, struct usb_request *req)
>  
>  static ssize_t ffs_copy_to_iter(void *data, int data_len, struct iov_iter *iter)
>  {
> -	ssize_t ret = copy_to_iter(data, data_len, iter);
> +	ssize_t ret;
> +
> +#if defined(CONFIG_ARM64)
> +	/*
> +	 * Replace tagged address passed by user space application before
> +	 * copying.
> +	 */
> +	if (IS_ENABLED(CONFIG_ARM64_TAGGED_ADDR_ABI) &&
> +		(iter->type == ITER_IOVEC)) {
> +		*(unsigned long *)&iter->iov->iov_base =
> +			(unsigned long)untagged_addr(iter->iov->iov_base);
> +	}
> +#endif
> +	ret = copy_to_iter(data, data_len, iter);
>  	if (likely(ret == data_len))
>  		return ret;

I had forgotten that we discussed a similar case already a few months
ago (thanks to Evgenii for pointing out). Do you have this commit
applied to your tree: df325e05a682 ("arm64: Validate tagged addresses in
access_ok() called from kernel threads")?

-- 
Catalin
