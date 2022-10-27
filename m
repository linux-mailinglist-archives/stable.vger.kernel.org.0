Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7B860F112
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 09:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiJ0HYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 03:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbiJ0HYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 03:24:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329DC14FD00;
        Thu, 27 Oct 2022 00:24:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3E2D621B5;
        Thu, 27 Oct 2022 07:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA96C433D6;
        Thu, 27 Oct 2022 07:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666855443;
        bh=QKx/bBlbgDcgSnVkyP7W7hHWyRc89cVTFvdz2kOrV9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pU5/NuVQCFs8T2qSP/1Kov3xQBxe55kB9LhgPo89SoqDm7XgDcJSHKWxvTumXmMXu
         W/8WaeVe7y2vdufbXTaLASh8RiPsHPJKip8frXGHKUQlEkbytwKOtMCdDHCwQwokMO
         jVgQ/5areQyskDP2FmXhQHiHach3AEYVdYDyyanI=
Date:   Thu, 27 Oct 2022 09:24:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Maria Yu <quic_aiquny@quicinc.com>
Cc:     linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: core: Make p->state in order in
 pinctrl_commit_state
Message-ID: <Y1oyEMYRK8R0dOs1@kroah.com>
References: <20221027065110.9395-1-quic_aiquny@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027065110.9395-1-quic_aiquny@quicinc.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 02:51:10PM +0800, Maria Yu wrote:
> We've got a dump that current cpu is in pinctrl_commit_state, the
> old_state != p->state while the stack is still in the process of
> pinmux_disable_setting. So it means even if the current p->state is
> changed in new state, the settings are not yet up-to-date enabled
> complete yet.
> 
> Currently p->state in different value to synchronize the
> pinctrl_commit_state behaviors. The p->state will have transaction like
> old_state -> NULL -> new_state. When in old_state, it will try to
> disable all the all state settings. And when after new state settings
> enabled, p->state will changed to the new state after that. So use
> smp_mb to synchronize the p->state variable and the settings in order.
> ---
>  drivers/pinctrl/core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index 9e57f4c62e60..cd917a5b1a0a 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -1256,6 +1256,7 @@ static int pinctrl_commit_state(struct pinctrl *p, struct pinctrl_state *state)
>  		}
>  	}
>  
> +	smp_mb();
>  	p->state = NULL;
>  
>  	/* Apply all the settings for the new state - pinmux first */
> @@ -1305,6 +1306,7 @@ static int pinctrl_commit_state(struct pinctrl *p, struct pinctrl_state *state)
>  			pinctrl_link_add(setting->pctldev, p->dev);
>  	}
>  
> +	smp_mb();
>  	p->state = state;
>  
>  	return 0;
> -- 
> 2.17.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
