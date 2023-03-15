Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5529C6BAA36
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjCOIAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjCOIAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:00:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B287664CB;
        Wed, 15 Mar 2023 01:00:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B401B81D15;
        Wed, 15 Mar 2023 08:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE66C4339C;
        Wed, 15 Mar 2023 08:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678867206;
        bh=BzqI7TJKuPq5OfgoAzmOR0BgNz/zKLwx/7co11+aX/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MrRshSkmxeJ+rABZnaXYISThL/Z46Rkoksyby9/gs/qaTwxpPI6VlPXGYCtkOt83x
         /yKGtkQgHRx89oLJbcekm4H4iauNB/ZvgTHKQbZpez2m7Wql0Jd4tNbv3C/AnwjOX5
         Ak8hiZ0b6g6FoYByrZuwPKNnNTbxuAyS72fZx8kg=
Date:   Wed, 15 Mar 2023 09:00:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc:     stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.4/5.10 1/1] RDMA/i40iw: Fix potential
 NULL-ptr-dereference
Message-ID: <ZBF7A87Ph+O2y7KY@kroah.com>
References: <20230314134456.3557-1-n.zhandarovich@fintech.ru>
 <20230314134456.3557-2-n.zhandarovich@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314134456.3557-2-n.zhandarovich@fintech.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 14, 2023 at 06:44:56AM -0700, Nikita Zhandarovich wrote:
> From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
> 
> commit 5d9745cead1f121974322b94ceadfb4d1e67960e upstream.
> 
> in_dev_get() can return NULL which will cause a failure once idev is
> dereferenced in in_dev_for_each_ifa_rtnl(). This patch adds a
> check for NULL value in idev beforehand.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Changes made to the original patch during backporting:
> Apply patch to drivers/infiniband/hw/i40iw/i40iw_cm.c instead of
> drivers/infiniband/hw/irdma/cm.c due to the fact that kernel versions
> 5.10 and below use i40iw driver, not irdma.
> 
> Fixes: f27b4746f378 ("i40iw: add connection management code")
> Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
> Link: https://lore.kernel.org/r/20230126185230.62464-1-n.zhandarovich@fintech.ru
> ---
>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> index 3053c345a5a3..e1236ac502f2 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> @@ -1776,6 +1776,8 @@ static enum i40iw_status_code i40iw_add_mqh_4(
>  			const struct in_ifaddr *ifa;
>  
>  			idev = in_dev_get(dev);
> +			if (!idev)
> +				continue;
>  
>  			in_dev_for_each_ifa_rtnl(ifa, idev) {
>  				i40iw_debug(&iwdev->sc_dev,

As this isn't anything that can be triggered by a normal system
operation, I'm going to drop it from the review queue.  Unless you have
a reproducer that can cause this to happen from userspace?

thanks,

greg k-h
