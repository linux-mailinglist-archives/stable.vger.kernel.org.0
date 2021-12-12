Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928CE471A89
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 14:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhLLN4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 08:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbhLLN4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 08:56:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D3AC061714
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 05:56:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FA10B80CDF
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 13:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9B9C341CA;
        Sun, 12 Dec 2021 13:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639317380;
        bh=SCTmZBaq673p/wtEaKU9XZ1HKc/61VrjwPGU4wIcWUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B5JB+vaFUDPXzd4TfVoS7JuVu9PdKjPUnmP4lTQP0d7WqqhRD+VEH1r8vjHKGKzzq
         ppS+thHWHeNg8GBSliI1bP+be/Hc+YhslV4E7Fxr8qG8XRqSYvJr/8rhGVejE5wfp7
         XkulbQOxJ7hx/C8c11H6qC0AxO/CGjfLUFqctYls=
Date:   Sun, 12 Dec 2021 14:56:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Louis Amas <louis.amas@eho.link>
Cc:     stable@vger.kernel.org, kuba@kernel.org,
        Emmanuel Deloget <emmanuel.deloget@eho.link>,
        Marcin Wojtas <mw@semihalf.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH v5 net 1/1] net: mvpp2: fix XDP rx queues registering
Message-ID: <YbX/gXr+iV2sGoIO@kroah.com>
References: <20211210171620.679625-1-louis.amas@eho.link>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210171620.679625-1-louis.amas@eho.link>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 10, 2021 at 06:16:20PM +0100, Louis Amas wrote:
> commit a50e659b2a1be14784e80f8492aab177e67c53a2 upstream
> 
> The registration of XDP queue information is incorrect because the
> RX queue id we use is invalid. When port->id == 0 it appears to works
> as expected yet it's no longer the case when port->id != 0.
> 
> The problem arised while using a recent kernel version on the
> MACCHIATOBin. This board has several ports:
>  * eth0 and eth1 are 10Gbps interfaces ; both ports has port->id == 0;
>  * eth2 is a 1Gbps interface with port->id != 0.
> 
> Code from xdp-tutorial (more specifically advanced03-AF_XDP) was used
> to test packet capture and injection on all these interfaces. The XDP
> kernel was simplified to:
> 
> 	SEC("xdp_sock")
> 	int xdp_sock_prog(struct xdp_md *ctx)
> 	{
> 		int index = ctx->rx_queue_index;
> 
> 		/* A set entry here means that the correspnding queue_id
> 		* has an active AF_XDP socket bound to it. */
> 		if (bpf_map_lookup_elem(&xsks_map, &index))
> 			return bpf_redirect_map(&xsks_map, index, 0);
> 
> 		return XDP_PASS;
> 	}
> 
> Starting the program using:
> 
> 	./af_xdp_user -d DEV
> 
> Gives the following result:
> 
>  * eth0 : ok
>  * eth1 : ok
>  * eth2 : no capture, no injection
> 
> Investigating the issue shows that XDP rx queues for eth2 are wrong:
> XDP expects their id to be in the range [0..3] but we found them to be
> in the range [32..35].
> 
> Trying to force rx queue ids using:
> 
> 	./af_xdp_user -d eth2 -Q 32
> 
> fails as expected (we shall not have more than 4 queues).
> 
> When we register the XDP rx queue information (using
> xdp_rxq_info_reg() in function mvpp2_rxq_init()) we tell it to use
> rxq->id as the queue id. This value is computed as:
> 
> 	rxq->id = port->id * max_rxq_count + queue_id
> 
> where max_rxq_count depends on the device version. In the MACCHIATOBin
> case, this value is 32, meaning that rx queues on eth2 are numbered
> from 32 to 35 - there are four of them.
> 
> Clearly, this is not the per-port queue id that XDP is expecting:
> it wants a value in the range [0..3]. It shall directly use queue_id
> which is stored in rxq->logic_rxq -- so let's use that value instead.
> 
> rxq->id is left untouched ; its value is indeed valid but it should
> not be used in this context.
> 
> This is consistent with the remaining part of the code in
> mvpp2_rxq_init().
> 
> With this change, packet capture is working as expected on all the
> MACCHIATOBin ports.
> 
> Fixes: b27db2274ba8 ("mvpp2: use page_pool allocator")
> Signed-off-by: Louis Amas <louis.amas@eho.link>
> Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
> Reviewed-by: Marcin Wojtas <mw@semihalf.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
> 
> Patch history
> 
> v1 : original submission [1]
> v2 : commit message rework (no change in the patch) [2]
> v3 : commit message rework (no change in the patch) + added Acked-by [3]
> v4 : fix mail corruption by malevolent SMTP + rebase on net/master
> v5 : (this version) add tags back

Now queued up, thanks.

greg k-h
