Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E468533A3A
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 11:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbiEYJrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 05:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236293AbiEYJrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 05:47:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E39CE36
        for <stable@vger.kernel.org>; Wed, 25 May 2022 02:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653472024; x=1685008024;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BEgDx6uz/Gvh9osITOGKBEWVE8dUL1Lym8uYwUT4Qsc=;
  b=VWIrPHZAwXUXgox8wsrBQuNJ1qZkOeGAz4VggMLVmmbPaV1pW9Y+tovx
   oSsbWZCZZJ4gkf9Wz5WDNuHronxRdeK3NpkI6cmL3QvT+r8LZOMdTLTX4
   LH++hanFplJfLd/44WaxdkjVUEvS3T5dwxJFPcddufp3Y86jcxEJteM9M
   qf66J5o43VEielFRZXhe3xhfzLd64FhINo3naCTqkVo+LCqTuj/ucFSFB
   gY/Ek2ea4arT5/8owWb2sTJXFByjQf9CmKSoHJSPHDhwfFydshw1bxgRt
   CsBAdkqJgM26L6WEHayeQ8G8zY2YueweVS2iLSq5f+sIfpHZObo1MfDYv
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="273880696"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="273880696"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 02:46:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="745609045"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 25 May 2022 02:46:53 -0700
Date:   Wed, 25 May 2022 11:46:52 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org, bjorn@kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Shaw <jeffrey.b.shaw@intel.com>
Subject: Re: [PATCH 5.15] ice: fix crash at allocation failure
Message-ID: <Yo37DLxvEAf2aYGB@boxer>
References: <20220525071953.27755-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525071953.27755-1-magnus.karlsson@gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 25, 2022 at 09:19:53AM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a crash in the zero-copy driver that occurs when it fails to
> allocate buffers from user-space. This crash can easily be triggered
> by a malicious program that does not provide any buffers in the fill
> ring for the kernel to use.
> 
> Note that this bug does not exist in upstream since the batched buffer
> allocation interface got introduced in 5.16 and replaced this code.
> 
> Reported-by: Jeff Shaw <jeffrey.b.shaw@intel.com>
> Tested-by: Jeff Shaw <jeffrey.b.shaw@intel.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index 2b1873061912..5581747947e5 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -378,7 +378,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
>  
>  	do {
>  		*xdp = xsk_buff_alloc(rx_ring->xsk_pool);
> -		if (!xdp) {
> +		if (!*xdp) {
>  			ok = false;
>  			break;
>  		}
> 
> base-commit: 9f43e3ac7e662f352f829077723fa0b92ccaded1
> -- 
> 2.34.1
> 
