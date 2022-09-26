Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C203E5EAD90
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiIZRF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiIZRFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:05:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84945285;
        Mon, 26 Sep 2022 09:08:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4296AB80AE6;
        Mon, 26 Sep 2022 16:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BEDC433C1;
        Mon, 26 Sep 2022 16:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664208516;
        bh=fXfxc6TThtN6R0aValrqgfLYhMHz+jsHRMWsyysHKcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sTkkzq8TsQm58Uqstew5WUz717zu9BSCjtpfQPKvus2H3oFze5XK3jfAiu6+T3USU
         0G5HCK6alKm9DPym1vSiWC8/1Kwq8keZsKMqrRYEes8TAHXYY0FipvMkknpQvW8spu
         KMlSIlw7GrERCoUGf8WAm0irQurcyljq9c4flJr8=
Date:   Mon, 26 Sep 2022 18:08:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 10/30] mips/pic32/pic32mzda: Fix refcount leak bugs
Message-ID: <YzHOgvFqsn6wu2eO@kroah.com>
References: <20220926100736.153157100@linuxfoundation.org>
 <20220926100736.537955607@linuxfoundation.org>
 <20220926104042.GD8978@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926104042.GD8978@amd>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 12:40:42PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit eb9e9bc4fa5fb489c92ec588b3fb35f042ba6d86 ]
> > 
> > of_find_matching_node(), of_find_compatible_node() and
> > of_find_node_by_path() will return node pointers with refcout
> > incremented. We should call of_node_put() when they are not
> > used anymore.
> 
> True. But we absolutely should not call put when we still use the
> reference.
> 
> > +++ b/arch/mips/pic32/pic32mzda/init.c
> > @@ -131,13 +131,18 @@ static int __init pic32_of_prepare_platform_data(struct of_dev_auxdata *lookup)
> >  		np = of_find_compatible_node(NULL, NULL, lookup->compatible);
> >  		if (np) {
> >  			lookup->name = (char *)np->name;
> > -			if (lookup->phys_addr)
> > +			if (lookup->phys_addr) {
> > +				of_node_put(np);
> >  				continue;
> > +			}
> >  			if (!of_address_to_resource(np, 0, &res))
> >  				lookup->phys_addr = res.start;
> > +			of_node_put(np);
> >  		}
> >  	}
> 
> As we stored np->name in lookup, we should not be putting that node,
> we are still using it.

Now dropped, thanks.

greg k-h
