Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F112E667283
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjALMsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjALMsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:48:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D2D4C735;
        Thu, 12 Jan 2023 04:47:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BDD6B81DD5;
        Thu, 12 Jan 2023 12:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837E4C433F1;
        Thu, 12 Jan 2023 12:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673527677;
        bh=7zZrtN8lmZKOOP4+fso5bw1M8rjneci9uxIRHPuWDgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=blPoptpCI5TVw04j6Uhfv3eMlNkUaOX5zUB2uS8oijYwVXOJP9UpjgZbfm+h4Utms
         pSR+QBlb2klOw1xHCe5LkrZsFcpd0DBiBzpP1Rcfdr6K816Fz0OJS2KBpsbm72BkD7
         MGb++JTPURweTALy/PkKhEGelWwvB8qYR6SFw7NE=
Date:   Thu, 12 Jan 2023 13:47:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dragos-Marian Panait <dragos.panait@windriver.com>
Cc:     stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kent Russell <kent.russell@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.10 1/1] drm/amdkfd: Check for null pointer after
 calling kmemdup
Message-ID: <Y8ABeXQLzWdoaGAY@kroah.com>
References: <20230104175633.1420151-1-dragos.panait@windriver.com>
 <20230104175633.1420151-2-dragos.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104175633.1420151-2-dragos.panait@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 07:56:33PM +0200, Dragos-Marian Panait wrote:
> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [ Upstream commit abfaf0eee97925905e742aa3b0b72e04a918fa9e ]
> 
> As the possible failure of the allocation, kmemdup() may return NULL
> pointer.
> Therefore, it should be better to check the 'props2' in order to prevent
> the dereference of NULL pointer.
> 
> Fixes: 3a87177eb141 ("drm/amdkfd: Add topology support for dGPUs")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
> ---
>  drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> index 86b4dadf772e..02e3c650ed1c 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> @@ -408,6 +408,9 @@ static int kfd_parse_subtype_iolink(struct crat_subtype_iolink *iolink,
>  			return -ENODEV;
>  		/* same everything but the other direction */
>  		props2 = kmemdup(props, sizeof(*props2), GFP_KERNEL);
> +		if (!props2)
> +			return -ENOMEM;

Not going to queue this up as this is a bogus CVE.
