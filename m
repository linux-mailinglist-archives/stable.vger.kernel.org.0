Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE09D1EA7C2
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 18:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgFAQYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 12:24:09 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:16510 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgFAQYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 12:24:08 -0400
Received: from localhost (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 051GLiQ5031960;
        Mon, 1 Jun 2020 09:21:45 -0700
Date:   Mon, 1 Jun 2020 21:51:44 +0530
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     hch@lst.de, sagi@grimberg.me, stable@vger.kernel.org,
        nirranjan@chelsio.com, bharat@chelsio.com
Subject: Re: nvme blk_update_request IO error is seen on stable kernel 5.4.41.
Message-ID: <20200601162143.GA917@chelsio.com>
References: <20200521140642.GA4724@chelsio.com>
 <20200526102542.GA2772976@kroah.com>
 <20200528074426.GA20353@chelsio.com>
 <20200528083403.GB2920930@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200528083403.GB2920930@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thursday, May 05/28/20, 2020 at 10:34:03 +0200, Greg KH wrote:
> On Thu, May 28, 2020 at 01:14:31PM +0530, Dakshaja Uppalapati wrote:
> > On Tuesday, May 05/26/20, 2020 at 12:25:42 +0200, Greg KH wrote:
> > > On Thu, May 21, 2020 at 07:36:43PM +0530, Dakshaja Uppalapati wrote:
> > > > Hi all,
> > > > 
> > > > Issue which is reported in https://lore.kernel.org/linux-nvme/CH2PR12MB40050ACF
> > > > 2C0DC7439355ED3FDD270@CH2PR12MB4005.namprd12.prod.outlook.com/T/#r8cfc80b26f0cd
> > > > 1cde41879a68fd6a71186e9594c is also seen on stable kernel 5.4.41. 
> > > 
> > > What issue is that?  Your url is wrapped and can not work here :(
> > 
> > Sorry for that, when I tried to format the disk discovered from target machine
> > the below error is seen in dmesg.
> > 
> > dmesg:
> > 	[ 1844.868480] blk_update_request: I/O error, dev nvme0c0n1, sector 0 
> > 	op 0x3:(DISCARD) flags 0x4000800 phys_seg 1 prio class 0
> > 
> > The above issue is seen from kernel-5.5-rc1 onwards.
> > 
> > > 
> > > > In upstream issue is fixed with commit b716e6889c95f64b.
> > > 
> > > Is this a regression or support for something new that has never worked
> > > before?
> > > 
> > 
> > This is a regression, bisects points to the commit 530436c4 and fixed with
> > commit b716e688 in upstream.
> > 
> > Now same issue is seen with stable kernel-5.4.41, 530436c4 is part of it.
> 
> So why don't we just revert 530436c45ef2 ("nvme: Discard workaround for
> non-conformant devices") from the stable trees?  Will that fix the issue
> for you instead of the much-larger set of backports you are proposing?
> 
> Also, is this an issue for you in the 4.19 releases?  The above
> mentioned patch showed up in 4.19.92 and 5.4.7.
> 

Yes, on 4.19 stable kernel too issue is seen. By reverting 530436c45ef2 issue
is not seen on both 4.19 and 5.4 stable kernels. Do you want me to send the
reverted patch?

> > > > For stable 5.4 kernel it doesn’t apply clean and needs pulling in the following
> > > > commits. 
> > > > 
> > > > commit 2cb6963a16e9e114486decf591af7cb2d69cb154
> > > > Author: Christoph Hellwig <hch@lst.de>
> > > > Date:   Wed Oct 23 10:35:41 2019 -0600
> > > > 
> > > > commit 6f86f2c9d94d55c4d3a6f1ffbc2e1115b5cb38a8
> > > > Author: Christoph Hellwig <hch@lst.de>
> > > > Date:   Wed Oct 23 10:35:42 2019 -0600
> > > > 
> > > > commit 59ef0eaa7741c3543f98220cc132c61bf0230bce
> > > > Author: Christoph Hellwig <hch@lst.de>
> > > > Date:   Wed Oct 23 10:35:43 2019 -0600
> > > > 
> > > > commit e9061c397839eea34207668bfedce0a6c18c5015
> > > > Author: Christoph Hellwig <hch@lst.de>
> > > > Date:   Wed Oct 23 10:35:44 2019 -0600
> > > > 
> > > > commit b716e6889c95f64ba32af492461f6cc9341f3f05
> > > > Author: Sagi Grimberg <sagi@grimberg.me>
> > > > Date:   Sun Jan 26 23:23:28 2020 -0800
> > > > 
> > > > I tried a patch by including only necessary parts of the commits e9061c397839, 
> > > > 59ef0eaa7741 and b716e6889c95. PFA.
> > > > 
> > > > With the attached patch, issue is not seen.
> > > > 
> > > > Please let me know on how to fix it in stable, can all above 5 changes be 
> > > > cleanly pushed  or if  attached shorter version can be pushed?
> > > 
> > > Do all of the above patches apply cleanly?  Do they need to be
> > > backported?  Have you tested that?  Do you have such a series of patches
> > > so we can compare them?
> > > 
> > 
> > Yes I have tested, all the patches applied cleanly and attached all the patches
> > for your reference. They all can be pulled into 5.4 stable without any issues.
> > 
> > 530436c4 -- culprit commit
> > 2cb6963a -- dependent commit
> > 6f86f2c9 -- dependent commit
> > 59ef0eaa -- dependent commit
> > e9061c39 -- dependent commit
> > be3f3114 -- dependent commit
> > b716e688 -- fix commit
> > 
> > > The patch below is not in any format that I can take it in.  ALso, 95%
> > > of the times we take a patch that is different from what is upstream
> > > will have bugs and problems over time because of that.  So I always want
> > > to take the original upstream patches instead if at all possible.
> > > 
> > > So I need a lot more information here in order to try to determine this,
> > > sorry.
> > > 
> > 
> > Thanks
> > Dakshaja
> 
> > diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
> > index 831a062d27cb..3665b45d6515 100644
> > --- a/drivers/nvme/target/admin-cmd.c
> > +++ b/drivers/nvme/target/admin-cmd.c
> 
> <snip>
> 
> I still don't understand what the patch here is, as you don't really
> provide any information about it in a format I am used to seeing.  Can
> you redo it in the documented style of submitting a normal patch to the
> kernel tree so that might help explain things?
> 
> thanks,
> 
> greg k-h

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="revert_530436c4.patch"

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f0e0af3aa..d658c5093 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -612,14 +612,8 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	struct nvme_dsm_range *range;
 	struct bio *bio;
 
-	/*
-	 * Some devices do not consider the DSM 'Number of Ranges' field when
-	 * determining how much data to DMA. Always allocate memory for maximum
-	 * number of segments to prevent device reading beyond end of buffer.
-	 */
-	static const size_t alloc_size = sizeof(*range) * NVME_DSM_MAX_RANGES;
-
-	range = kzalloc(alloc_size, GFP_ATOMIC | __GFP_NOWARN);
+	range = kmalloc_array(segments, sizeof(*range),
+				GFP_ATOMIC | __GFP_NOWARN);
 	if (!range) {
 		/*
 		 * If we fail allocation our range, fallback to the controller
@@ -659,7 +653,7 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 
 	req->special_vec.bv_page = virt_to_page(range);
 	req->special_vec.bv_offset = offset_in_page(range);
-	req->special_vec.bv_len = alloc_size;
+	req->special_vec.bv_len = sizeof(*range) * segments;
 	req->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
 	return BLK_STS_OK;

--y0ulUmNC+osPPQO6--
