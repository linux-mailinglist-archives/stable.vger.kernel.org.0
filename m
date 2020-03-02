Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13558175F5E
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 17:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCBQTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 11:19:36 -0500
Received: from foss.arm.com ([217.140.110.172]:34872 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgCBQTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 11:19:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 771D72F;
        Mon,  2 Mar 2020 08:19:35 -0800 (PST)
Received: from C02TF0J2HF1T.cambridge.arm.com (C02TF0J2HF1T.cambridge.arm.com [10.1.38.135])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EFD083F534;
        Mon,  2 Mar 2020 08:19:31 -0800 (PST)
Date:   Mon, 2 Mar 2020 16:19:29 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Sasha Levin <sashal@kernel.org>, Shen Jing <jingx.shen@intel.com>,
        CC Hwang <cc.hwang@mediatek.com>,
        Peter Chen <peter.chen@nxp.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Jerry Zhang <zhangjerry@google.com>, andreyknvl@google.com,
        linux-usb@vger.kernel.org, Loda Chou <loda.chou@mediatek.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Miles Chen <miles.chen@mediatek.com>, eugenis@google.com,
        John Stultz <john.stultz@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] usb: gadget: f_fs: try to fix AIO issue under ARM 64
 bit TAGGED mode
Message-ID: <20200302161929.GA48767@C02TF0J2HF1T.cambridge.arm.com>
References: <1582627315-21123-1-git-send-email-macpaul.lin@mediatek.com>
 <1582718512-28923-1-git-send-email-macpaul.lin@mediatek.com>
 <20200228164848.GH4019108@arrakis.emea.arm.com>
 <1583032843.12083.24.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583032843.12083.24.camel@mtkswgap22>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 01, 2020 at 11:20:43AM +0800, Macpaul Lin wrote:
> On Fri, 2020-02-28 at 16:48 +0000, Catalin Marinas wrote:
> > On Wed, Feb 26, 2020 at 08:01:52PM +0800, Macpaul Lin wrote:
> > > diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> > > index ce1d023..192935f 100644
> > > --- a/drivers/usb/gadget/function/f_fs.c
> > > +++ b/drivers/usb/gadget/function/f_fs.c
> > > @@ -715,7 +715,20 @@ static void ffs_epfile_io_complete(struct usb_ep *_ep, struct usb_request *req)
> > >  
> > >  static ssize_t ffs_copy_to_iter(void *data, int data_len, struct iov_iter *iter)
> > >  {
> > > -	ssize_t ret = copy_to_iter(data, data_len, iter);
> > > +	ssize_t ret;
> > > +
> > > +#if defined(CONFIG_ARM64)
> > > +	/*
> > > +	 * Replace tagged address passed by user space application before
> > > +	 * copying.
> > > +	 */
> > > +	if (IS_ENABLED(CONFIG_ARM64_TAGGED_ADDR_ABI) &&
> > > +		(iter->type == ITER_IOVEC)) {
> > > +		*(unsigned long *)&iter->iov->iov_base =
> > > +			(unsigned long)untagged_addr(iter->iov->iov_base);
> > > +	}
> > > +#endif
> > > +	ret = copy_to_iter(data, data_len, iter);
> > >  	if (likely(ret == data_len))
> > >  		return ret;
> > 
> > I had forgotten that we discussed a similar case already a few months
> > ago (thanks to Evgenii for pointing out). Do you have this commit
> > applied to your tree: df325e05a682 ("arm64: Validate tagged addresses in
> > access_ok() called from kernel threads")?
> > 
> 
> Yes! We have that patch. I've also got Google's reply about referencing
> this patch in android kernel tree.
> https://android-review.googlesource.com/c/kernel/common/+/1186615
> 
> However, during my debugging process, I've dumped specific length (e.g.,
> 24 bytes for the first request) AIO request buffer address both in adbd
> and in __range_ok(). Then I've found __range_ok() still always return
> false on address begin with "0x3c". Since untagged_addr() already called
> in __range_ok(), to set "TIF_TAGGED_ADDR" with adbd's user space buffer
> should be the possible solution. Hence I've send the v3 patch.

ffs_copy_to_iter() is called from a workqueue (ffs_user_copy_worker()).
That's still in a kernel thread context but it doesn't have PF_KTHREAD
set, hence __range_ok() rejects the tagged address. Can you try the diff
below:

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 32fc8061aa76..2803143cad1f 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -68,7 +68,8 @@ static inline unsigned long __range_ok(const void __user *addr, unsigned long si
 	 * the user address before checking.
 	 */
 	if (IS_ENABLED(CONFIG_ARM64_TAGGED_ADDR_ABI) &&
-	    (current->flags & PF_KTHREAD || test_thread_flag(TIF_TAGGED_ADDR)))
+	    (current->flags & (PF_KTHREAD | PF_WQ_WORKER) ||
+	     test_thread_flag(TIF_TAGGED_ADDR)))
 		addr = untagged_addr(addr);
 
 	__chk_user_ptr(addr);
-
