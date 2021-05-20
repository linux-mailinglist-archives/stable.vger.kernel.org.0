Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3542338B0AC
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 15:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237492AbhETOBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 10:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243499AbhETN7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 09:59:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C24D60FF3;
        Thu, 20 May 2021 13:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621519107;
        bh=9Z9KtTy2XJzfMy3Np+yfMnnpZx1rqHwlJ+eViM6aKGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zzZKKHy8Rvb2U6+fIVhMVR4d5FQY3bliHouy3pSAQ81rdLSMQgPZMcZUsRyciMnB5
         ZbBk+zb+O85Z8nqUfoyYz6XrYMRXjrvGIt6tKvhYx8g0KCsREhI4GBhbgxJ1HtDdSt
         fCZrWgZP/7jZ9IhI2OGk+7Au4bnWZ387ujj8o7iI=
Date:   Thu, 20 May 2021 15:58:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        kernel test robot <oliver.sang@intel.com>,
        stable <stable@vger.kernel.org>,
        linux-nvidia@lists.surfsouth.com, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        igormtorrente@gmail.com, fero@drama.obuda.kando.hu
Subject: Re: [PATCH] video: hgafb: correctly handle card detect failure
 during probe
Message-ID: <YKZrAVk85IjNYVHs@kroah.com>
References: <20210516192714.25823-1-mail@anirudhrb.com>
 <YKZm17dj4R1c2ns/@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKZm17dj4R1c2ns/@anirudhrb.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 07:10:39PM +0530, Anirudh Rayabharam wrote:
> On Mon, May 17, 2021 at 12:57:14AM +0530, Anirudh Rayabharam wrote:
> > The return value of hga_card_detect() is not properly handled causing
> > the probe to succeed even though hga_card_detect() failed. Since probe
> > succeeds, hgafb_open() can be called which will end up operating on an
> > unmapped hga_vram. This results in an out-of-bounds access as reported
> > by kernel test robot [1].
> > 
> > To fix this, correctly detect failure of hga_card_detect() by checking
> > for a non-zero error code.
> > 
> > [1]: https://lore.kernel.org/lkml/20210516150019.GB25903@xsang-OptiPlex-9020/
> > 
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Fixes: dc13cac4862c ("video: hgafb: fix potential NULL pointer dereference")
> 
> Greg, this is one of the UMN fixes we did. So, do you want to take this
> patch into your tree?

Yes, will queue it up in a few days after Linus takes the current pull
request I sent him for this.

thanks,

greg k-h
