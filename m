Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAE24D88F7
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 17:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242963AbiCNQWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 12:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241710AbiCNQWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 12:22:45 -0400
X-Greylist: delayed 392 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Mar 2022 09:21:35 PDT
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E915912A8A;
        Mon, 14 Mar 2022 09:21:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1647274883; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=mx2smIOGeo5ZjY9eOcc/bCGdqHmQUFR59CYhROKVr38Nz2LvTY2tlis1je8oqqd0yKOSOFIb3ccss3/zksRXDdKtAaOBo/XLyWQhKc0FI7PRZRUokt/E+aIaO2UpJtn/Jc9cWCIQjfKdC3m2Hs3FsvkoWmMtC9tuSTWyaiOAWL4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1647274883; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=exLHJy/o8u0v5+P+IbvaTX55kBTxm+CYnLzbshyskLQ=; 
        b=iu4CwdmaeduL2TpUU/4fmKpgv8MJPLw2fzJSYQWr8mAlm8rCvRkNK66DdfEJZm91T/tobqETRn5aHHl1E93mkmUiQO5P4CQ0lVuaGa/HncCx5cAnlJrVARbX7KtCYMeLLfEiPaSCv97zYhpzKcFmzP6e6C5OdAkU2OZ1jFJo+tY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1647274883;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
        bh=exLHJy/o8u0v5+P+IbvaTX55kBTxm+CYnLzbshyskLQ=;
        b=Kp+VnZ/0dusGp1M2OtccWhO6EKsLdjYBJFIL/BZh8jjtp9YNmAP+tnXWoYmaAUKN
        woajBDaQEecsACvn6Cbb+hH5wnmXnCikCQ98aMfwNtGyIiDPLHnWWG4AW0DC9hwsn8G
        aNrn8rPwsei/avKj+9tmYYtJK3Lht9mc2R/UUizw=
Received: from anirudhrb.com (49.207.221.223 [49.207.221.223]) by mx.zohomail.com
        with SMTPS id 1647274843303560.9949108171496; Mon, 14 Mar 2022 09:20:43 -0700 (PDT)
Date:   Mon, 14 Mar 2022 21:50:36 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com
Subject: Re: [PATCH 5.16 017/121] vhost: fix hung thread due to erroneous
 iotlb entries
Message-ID: <Yi9rVI7AhOnkBIx2@anirudhrb.com>
References: <20220314112744.120491875@linuxfoundation.org>
 <20220314112744.608703877@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314112744.608703877@linuxfoundation.org>
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 12:53:20PM +0100, Greg Kroah-Hartman wrote:
> From: Anirudh Rayabharam <mail@anirudhrb.com>
> 
> [ Upstream commit e2ae38cf3d91837a493cb2093c87700ff3cbe667 ]

This breaks batching of IOTLB messages. [1] fixes it but hasn't landed in
Linus' tree yet.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=linux-next&id=95932ab2ea07b79cdb33121e2f40ccda9e6a73b5

    - Anirudh.
> 
> In vhost_iotlb_add_range_ctx(), range size can overflow to 0 when
> start is 0 and last is ULONG_MAX. One instance where it can happen
> is when userspace sends an IOTLB message with iova=size=uaddr=0
> (vhost_process_iotlb_msg). So, an entry with size = 0, start = 0,
> last = ULONG_MAX ends up in the iotlb. Next time a packet is sent,
> iotlb_access_ok() loops indefinitely due to that erroneous entry.
> 
> 	Call Trace:
> 	 <TASK>
> 	 iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
> 	 vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
> 	 vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
> 	 vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
> 	 kthread+0x2e9/0x3a0 kernel/kthread.c:377
> 	 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 	 </TASK>
> 
> Reported by syzbot at:
> 	https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
> 
> To fix this, do two things:
> 
> 1. Return -EINVAL in vhost_chr_write_iter() when userspace asks to map
>    a range with size 0.
> 2. Fix vhost_iotlb_add_range_ctx() to handle the range [0, ULONG_MAX]
>    by splitting it into two entries.
> 
> Fixes: 0bbe30668d89e ("vhost: factor out IOTLB")
> Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> Link: https://lore.kernel.org/r/20220305095525.5145-1-mail@anirudhrb.com
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/vhost/iotlb.c | 11 +++++++++++
>  drivers/vhost/vhost.c |  5 +++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> index 670d56c879e5..40b098320b2a 100644
> --- a/drivers/vhost/iotlb.c
> +++ b/drivers/vhost/iotlb.c
> @@ -57,6 +57,17 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
>  	if (last < start)
>  		return -EFAULT;
>  
> +	/* If the range being mapped is [0, ULONG_MAX], split it into two entries
> +	 * otherwise its size would overflow u64.
> +	 */
> +	if (start == 0 && last == ULONG_MAX) {
> +		u64 mid = last / 2;
> +
> +		vhost_iotlb_add_range_ctx(iotlb, start, mid, addr, perm, opaque);
> +		addr += mid + 1;
> +		start = mid + 1;
> +	}
> +
>  	if (iotlb->limit &&
>  	    iotlb->nmaps == iotlb->limit &&
>  	    iotlb->flags & VHOST_IOTLB_FLAG_RETIRE) {
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..55475fd59fb7 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1170,6 +1170,11 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>  		goto done;
>  	}
>  
> +	if (msg.size == 0) {
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
>  	if (dev->msg_handler)
>  		ret = dev->msg_handler(dev, &msg);
>  	else
> -- 
> 2.34.1
> 
> 
> 
