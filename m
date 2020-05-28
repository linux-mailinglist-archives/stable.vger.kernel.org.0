Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24621E5ADE
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 10:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgE1IeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 04:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgE1IeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 04:34:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B75B82075F;
        Thu, 28 May 2020 08:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590654846;
        bh=2n2KR8Qu1EwChVUjgq0Xj+qUwi/2wScHAgpKAH3rn+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KNP5mJ8Q/ZstW1KtAQCmr1Ks2eHN6r4VZerMOZrbUHeBhszAPteGPC8NtBzYnGa4G
         gU0/D082giDX+JPGE9ARw+uLZ7VLRvJFLPSg2u5XyHsnNqSSi4dvv175T/babveNVR
         ln5yq7MPGpeleYdfZtf0WSReo29YPOLNHYKKYj2c=
Date:   Thu, 28 May 2020 10:34:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dakshaja Uppalapati <dakshaja@chelsio.com>
Cc:     hch@lst.de, sagi@grimberg.me, stable@vger.kernel.org,
        nirranjan@chelsio.com, bharat@chelsio.com
Subject: Re: nvme blk_update_request IO error is seen on stable kernel 5.4.41.
Message-ID: <20200528083403.GB2920930@kroah.com>
References: <20200521140642.GA4724@chelsio.com>
 <20200526102542.GA2772976@kroah.com>
 <20200528074426.GA20353@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200528074426.GA20353@chelsio.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 28, 2020 at 01:14:31PM +0530, Dakshaja Uppalapati wrote:
> On Tuesday, May 05/26/20, 2020 at 12:25:42 +0200, Greg KH wrote:
> > On Thu, May 21, 2020 at 07:36:43PM +0530, Dakshaja Uppalapati wrote:
> > > Hi all,
> > > 
> > > Issue which is reported in https://lore.kernel.org/linux-nvme/CH2PR12MB40050ACF
> > > 2C0DC7439355ED3FDD270@CH2PR12MB4005.namprd12.prod.outlook.com/T/#r8cfc80b26f0cd
> > > 1cde41879a68fd6a71186e9594c is also seen on stable kernel 5.4.41. 
> > 
> > What issue is that?  Your url is wrapped and can not work here :(
> 
> Sorry for that, when I tried to format the disk discovered from target machine
> the below error is seen in dmesg.
> 
> dmesg:
> 	[ 1844.868480] blk_update_request: I/O error, dev nvme0c0n1, sector 0 
> 	op 0x3:(DISCARD) flags 0x4000800 phys_seg 1 prio class 0
> 
> The above issue is seen from kernel-5.5-rc1 onwards.
> 
> > 
> > > In upstream issue is fixed with commit b716e6889c95f64b.
> > 
> > Is this a regression or support for something new that has never worked
> > before?
> > 
> 
> This is a regression, bisects points to the commit 530436c4 and fixed with
> commit b716e688 in upstream.
> 
> Now same issue is seen with stable kernel-5.4.41, 530436c4 is part of it.

So why don't we just revert 530436c45ef2 ("nvme: Discard workaround for
non-conformant devices") from the stable trees?  Will that fix the issue
for you instead of the much-larger set of backports you are proposing?

Also, is this an issue for you in the 4.19 releases?  The above
mentioned patch showed up in 4.19.92 and 5.4.7.

> > > For stable 5.4 kernel it doesn’t apply clean and needs pulling in the following
> > > commits. 
> > > 
> > > commit 2cb6963a16e9e114486decf591af7cb2d69cb154
> > > Author: Christoph Hellwig <hch@lst.de>
> > > Date:   Wed Oct 23 10:35:41 2019 -0600
> > > 
> > > commit 6f86f2c9d94d55c4d3a6f1ffbc2e1115b5cb38a8
> > > Author: Christoph Hellwig <hch@lst.de>
> > > Date:   Wed Oct 23 10:35:42 2019 -0600
> > > 
> > > commit 59ef0eaa7741c3543f98220cc132c61bf0230bce
> > > Author: Christoph Hellwig <hch@lst.de>
> > > Date:   Wed Oct 23 10:35:43 2019 -0600
> > > 
> > > commit e9061c397839eea34207668bfedce0a6c18c5015
> > > Author: Christoph Hellwig <hch@lst.de>
> > > Date:   Wed Oct 23 10:35:44 2019 -0600
> > > 
> > > commit b716e6889c95f64ba32af492461f6cc9341f3f05
> > > Author: Sagi Grimberg <sagi@grimberg.me>
> > > Date:   Sun Jan 26 23:23:28 2020 -0800
> > > 
> > > I tried a patch by including only necessary parts of the commits e9061c397839, 
> > > 59ef0eaa7741 and b716e6889c95. PFA.
> > > 
> > > With the attached patch, issue is not seen.
> > > 
> > > Please let me know on how to fix it in stable, can all above 5 changes be 
> > > cleanly pushed  or if  attached shorter version can be pushed?
> > 
> > Do all of the above patches apply cleanly?  Do they need to be
> > backported?  Have you tested that?  Do you have such a series of patches
> > so we can compare them?
> > 
> 
> Yes I have tested, all the patches applied cleanly and attached all the patches
> for your reference. They all can be pulled into 5.4 stable without any issues.
> 
> 530436c4 -- culprit commit
> 2cb6963a -- dependent commit
> 6f86f2c9 -- dependent commit
> 59ef0eaa -- dependent commit
> e9061c39 -- dependent commit
> be3f3114 -- dependent commit
> b716e688 -- fix commit
> 
> > The patch below is not in any format that I can take it in.  ALso, 95%
> > of the times we take a patch that is different from what is upstream
> > will have bugs and problems over time because of that.  So I always want
> > to take the original upstream patches instead if at all possible.
> > 
> > So I need a lot more information here in order to try to determine this,
> > sorry.
> > 
> 
> Thanks
> Dakshaja

> diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
> index 831a062d27cb..3665b45d6515 100644
> --- a/drivers/nvme/target/admin-cmd.c
> +++ b/drivers/nvme/target/admin-cmd.c

<snip>

I still don't understand what the patch here is, as you don't really
provide any information about it in a format I am used to seeing.  Can
you redo it in the documented style of submitting a normal patch to the
kernel tree so that might help explain things?

thanks,

greg k-h
