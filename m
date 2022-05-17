Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D0D529ED3
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 12:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243197AbiEQKIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 06:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343788AbiEQKGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 06:06:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F35F12A8D;
        Tue, 17 May 2022 03:06:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A443B817DF;
        Tue, 17 May 2022 10:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AE9C34113;
        Tue, 17 May 2022 10:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652781992;
        bh=HhKKBm3wiaE0xpknwdH7ZBGXkWj2DptvFeir39Hw/ek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F4nSFNRTu0P8ATljrJdxEj6spDFOWhsmBg7TkrTDh2dqNptrLPUH7PzVSw+aVXFm8
         0tPHPUBt/fc5Ue24QZByFrUBjiqMeuMx/eLrQHt5bMIT18zYXfATHho/FluGkpmYfU
         lEl1JaLzl7F1l7D07G+6GoGhkDuL5q1uj1UYXfkk=
Date:   Tue, 17 May 2022 12:06:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yuanjun Gong <ruc_gongyuanjun@163.com>
Cc:     Evan Quan <evan.quan@amd.com>, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] drm/amd/pm: fix a potential gpu_metrics_table memory
 leak
Message-ID: <YoNzo5QonLeg9CYh@kroah.com>
References: <20220517095746.7537-1-ruc_gongyuanjun@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517095746.7537-1-ruc_gongyuanjun@163.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 17, 2022 at 05:57:46PM +0800, Yuanjun Gong wrote:
> From: Gong Yuanjun <ruc_gongyuanjun@163.com>
> 
> gpu_metrics_table is allocated in yellow_carp_init_smc_tables() but
> not freed in yellow_carp_fini_smc_tables().
> 
> Signed-off-by: Gong Yuanjun <ruc_gongyuanjun@163.com>
> ---
>  drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
> index e2d099409123..c66c39ccf19c 100644
> --- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
> +++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
> @@ -190,6 +190,9 @@ static int yellow_carp_fini_smc_tables(struct smu_context *smu)
>  	kfree(smu_table->watermarks_table);
>  	smu_table->watermarks_table = NULL;
>  
> +	kfree(smu_table->gpu_metrics_table);
> +	smu_table->gpu_metrics_table = NULL;
> +
>  	return 0;
>  }
>  
> -- 
> 2.17.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
