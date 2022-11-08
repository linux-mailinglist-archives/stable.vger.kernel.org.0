Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64AE46215F4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbiKHORJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbiKHORD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:17:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA739686B1;
        Tue,  8 Nov 2022 06:17:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 941A9B81ADB;
        Tue,  8 Nov 2022 14:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D493AC433D6;
        Tue,  8 Nov 2022 14:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667917020;
        bh=SkB5aLz1qjfg7V47DCksPUeqsYxcIM9XVs+tPQyecP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=upUiGcqot+U553MthzNmGvuEi1FlvfUlbEtFYyvSOocWPWBtChFpAJE8GMSHoL/fJ
         Q5Uv9udNJwoGxAoS54KqUuZwXUVVfU/pRL0tQg8zMpIDQ45eAC4j7dfjZ76Dv4OCdV
         LML5vfuJMUuapNOSm38Bu1qDnVsAREtVoNMLWn2M=
Date:   Tue, 8 Nov 2022 14:51:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, lhenriques@suse.de,
        jlayton@kernel.org, mchangir@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] ceph: avoid putting the realm twice when decoding
 snaps fails
Message-ID: <Y2pe7evnz0fw1FZh@kroah.com>
References: <20221108134633.557928-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108134633.557928-1-xiubli@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 09:46:33PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When decoding the snaps fails it maybe leaving the 'first_realm'
> and 'realm' pointing to the same snaprealm memory. And then it'll
> put it twice and could cause random use-after-free, BUG_ON, etc
> issues.
> 
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/57686
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/snap.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 9bceed2ebda3..f5b0fa1ff705 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -775,6 +775,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>  
>  	dout("%s deletion=%d\n", __func__, deletion);
>  more:
> +	realm = NULL;
>  	rebuild_snapcs = 0;
>  	ceph_decode_need(&p, e, sizeof(*ri), bad);
>  	ri = p;
> -- 
> 2.31.1
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

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
