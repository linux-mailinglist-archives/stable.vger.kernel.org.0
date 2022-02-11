Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3427B4B24F6
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 12:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbiBKL42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 06:56:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349758AbiBKL41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 06:56:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB11EAE
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 03:56:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3970B829BA
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 11:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08B4C340E9;
        Fri, 11 Feb 2022 11:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644580583;
        bh=nav4caowV6YbnFMmRuZWSVAvHgMfAYHA9P5TSOg89U4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kmTaWITBtVkNGYOgwGUEg3J3M1LFmJEHbGOiTzUX6bRDjfTkIzC8h/3CVgGPn9eRl
         ALsEzMZC9/MPk9sNP+t55p4dipegE7tXgxo8Y2X4af47vmJ+qxc1SBQ5DZnVuNgGTQ
         eDprF2HVCJ9fFLhtrWCL9SOorXsizXS0nlrIL6B0=
Date:   Fri, 11 Feb 2022 12:56:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guillaume Bertholon <guillaume.bertholon@ens.fr>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9] ALSA: line6: Fix misplaced backport of "Fix wrong
 altsetting for LINE6_PODHD500_1"
Message-ID: <YgZO5FjjMbmyJdDk@kroah.com>
References: <1644337875-22219-1-git-send-email-guillaume.bertholon@ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1644337875-22219-1-git-send-email-guillaume.bertholon@ens.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 08, 2022 at 05:31:15PM +0100, Guillaume Bertholon wrote:
> The upstream commit 70256b42caaf ("ALSA: line6: Fix wrong altsetting for
> LINE6_PODHD500_1") changed the .altsetting field of the LINE6_PODHD500_1
> entry in podhd_properties_table from 1 to 0.
> 
> However, its backported version in stable (commit ec565611f930 ("ALSA:
> line6: Fix wrong altsetting for LINE6_PODHD500_1")) change the
> .altsetting field of the LINE6_PODHD500_0 entry instead.
> 
> This patch resets the altsetting of LINE6_PODHD500_0 to 1, and sets the
> altsetting of LINE6_PODHD500_1 to 0, as wanted by the original fix.
> 
> Fixes: ec565611f930 ("ALSA: line6: Fix wrong altsetting for LINE6_PODHD500_1")
> Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
> ---
>  sound/usb/line6/podhd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/usb/line6/podhd.c b/sound/usb/line6/podhd.c
> index 7133c36..b3abc4c 100644
> --- a/sound/usb/line6/podhd.c
> +++ b/sound/usb/line6/podhd.c
> @@ -385,7 +385,7 @@ static const struct line6_properties podhd_properties_table[] = {
>  		.name = "POD HD500",
>  		.capabilities	= LINE6_CAP_PCM
>  				| LINE6_CAP_HWMON,
> -		.altsetting = 0,
> +		.altsetting = 1,
>  		.ep_ctrl_r = 0x81,
>  		.ep_ctrl_w = 0x01,
>  		.ep_audio_r = 0x86,
> @@ -396,7 +396,7 @@ static const struct line6_properties podhd_properties_table[] = {
>  		.name = "POD HD500",
>  		.capabilities	= LINE6_CAP_PCM
>  				| LINE6_CAP_HWMON,
> -		.altsetting = 1,
> +		.altsetting = 0,
>  		.ep_ctrl_r = 0x81,
>  		.ep_ctrl_w = 0x01,
>  		.ep_audio_r = 0x86,
> --
> 2.7.4
> 

All 3 fixes now applied, thanks!

greg k-h
