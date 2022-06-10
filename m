Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A1F545CC5
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 09:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243912AbiFJHD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 03:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244334AbiFJHD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 03:03:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D68C320C0E;
        Fri, 10 Jun 2022 00:03:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 194F6B82C01;
        Fri, 10 Jun 2022 07:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FE1C34114;
        Fri, 10 Jun 2022 07:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654844632;
        bh=0jlkKf2s0caH8OvKLKXE1cL1pY8S6j9klqHId/wUOMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ry7nXPgqFTviWovAv6SJiTN9X2eyDob/Dmlk7C/Ts2VZh3JXhXB8YdcgkNa+mMu3y
         6G98/vXHN+NFPdkr5yyl3MWCpXyF1byrK/famTi28HsPfUSPda6ENm9Vh9yQLLrhMu
         SNO9IHSrUb73gewYB4kUNazMbMxPHP/UiUEBtySY=
Date:   Fri, 10 Jun 2022 09:03:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jared Kangas <kangas.jd@gmail.com>
Cc:     vaibhav.sr@gmail.com, elder@kernel.org,
        greybus-dev@lists.linaro.org, johan@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-staging@lists.linux.dev, mgreer@animalcreek.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2] staging: greybus: audio: fix loop cursor use after
 iteration
Message-ID: <YqLs1YlUrlLy8B3x@kroah.com>
References: <20220609214517.85661-1-kangas.jd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609214517.85661-1-kangas.jd@gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 09, 2022 at 02:45:18PM -0700, Jared Kangas wrote:
> gbaudio_dapm_free_controls() iterates over widgets using the
> list_for_each_entry*() family of macros from <linux/list.h>, which
> leaves the loop cursor pointing to a meaningless structure if it
> completes a traversal of the list. The cursor was set to NULL at the end
> of the loop body, but would be overwritten by the final loop cursor
> update.
> 
> Because of this behavior, the widget could be non-null after the loop
> even if the widget wasn't found, and the cleanup logic would treat the
> pointer as a valid widget to free.
> 
> To fix this, introduce a temporary variable to act as the loop cursor
> and copy it to a variable that can be accessed after the loop finishes.
> Due to not removing any list elements, use list_for_each_entry() instead
> of list_for_each_entry_safe() in the revised loop.
> 
> This was detected with the help of Coccinelle.
> 
> Fixes: 510e340efe0c ("staging: greybus: audio: Add helper APIs for dynamic audio modules")
> Cc: stable@vger.kernel.org
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Jared Kangas <kangas.jd@gmail.com>
> ---
> 
> Changes since v1:
>  * Removed safe list iteration as suggested by Johan Hovold <johan@kernel.org>
>  * Updated patch changelog to explain the list iteration change
>  * Added tags to changelog based on feedback (Cc:, Fixes:, Reviewed-by:)
> 
>  drivers/staging/greybus/audio_helper.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/greybus/audio_helper.c b/drivers/staging/greybus/audio_helper.c
> index 843760675876..05e91e6bc2a0 100644
> --- a/drivers/staging/greybus/audio_helper.c
> +++ b/drivers/staging/greybus/audio_helper.c
> @@ -115,7 +115,7 @@ int gbaudio_dapm_free_controls(struct snd_soc_dapm_context *dapm,
>  			       int num)
>  {
>  	int i;
> -	struct snd_soc_dapm_widget *w, *next_w;
> +	struct snd_soc_dapm_widget *w, *tmp_w;
>  #ifdef CONFIG_DEBUG_FS
>  	struct dentry *parent = dapm->debugfs_dapm;
>  	struct dentry *debugfs_w = NULL;
> @@ -124,13 +124,13 @@ int gbaudio_dapm_free_controls(struct snd_soc_dapm_context *dapm,
>  	mutex_lock(&dapm->card->dapm_mutex);
>  	for (i = 0; i < num; i++) {
>  		/* below logic can be optimized to identify widget pointer */
> -		list_for_each_entry_safe(w, next_w, &dapm->card->widgets,
> -					 list) {
> -			if (w->dapm != dapm)
> -				continue;
> -			if (!strcmp(w->name, widget->name))
> +		w = NULL;
> +		list_for_each_entry(tmp_w, &dapm->card->widgets, list) {
> +			if (tmp_w->dapm == dapm &&
> +			    !strcmp(tmp_w->name, widget->name)) {
> +				w = tmp_w;
>  				break;
> -			w = NULL;
> +			}
>  		}
>  		if (!w) {
>  			dev_err(dapm->dev, "%s: widget not found\n",
> -- 
> 2.34.3
> 
> 


Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch did not apply to any known trees that Greg is in control
  of.  Possibly this is because you made it against Linus's tree, not
  the linux-next tree, which is where all of the development for the
  next version of the kernel is at.  Please refresh your patch against
  the linux-next tree, or even better yet, the development tree
  specified in the MAINTAINERS file for the subsystem you are submitting
  a patch for, and resend it.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
