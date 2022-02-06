Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB454AAF56
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 14:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbiBFNIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 08:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbiBFNIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 08:08:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599B1C043183;
        Sun,  6 Feb 2022 05:08:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CA0FB80DDE;
        Sun,  6 Feb 2022 13:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B5EC340E9;
        Sun,  6 Feb 2022 13:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644152929;
        bh=NJwkVx1BYFnujt35nsRPmcUotkHAK6EbP1163UXtC0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CSDu70HSCHuZva1Acikr0WcV4zSg8lzDkItBBbQOJjdqCFe0+OiND8guHb0HqBsAc
         +YoxOi0HwY75+02hhPNg9qNmutm08R0/5CrtUYML8Np0hpGctYtClTRmI+yfazpKE0
         Pjb6Wn5U2Wra8Zwwh/su9VBBwvwEXyTTOPXiynW0=
Date:   Sun, 6 Feb 2022 14:07:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mateusz =?utf-8?Q?Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Cc:     stable@vger.kernel.org, linux-rtc@vger.kernel.org,
        Riwen Lu <luriwen@kylinos.cn>, Eric Wong <e@80x24.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH] rtc: cmos: Evaluate century appropriate
Message-ID: <Yf/IBKDwdb3fIgHR@kroah.com>
References: <20220205221139.5557-1-mat.jonczyk@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220205221139.5557-1-mat.jonczyk@o2.pl>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 05, 2022 at 11:11:39PM +0100, Mateusz Jończyk wrote:
> From: Riwen Lu <luriwen@kylinos.cn>
> 
> commit ff164ae39b82ee483b24579c8e22a13a8ce5bd04 upstream.
> 
> There's limiting the year to 2069. When setting the rtc year to 2070,
> reading it returns 1970. Evaluate century starting from 19 to count the
> correct year.
> 
> $ sudo date -s 20700106
> Mon 06 Jan 2070 12:00:00 AM CST
> $ sudo hwclock -w
> $ sudo hwclock -r
> 1970-01-06 12:00:49.604968+08:00
> 
> Fixes: 2a4daadd4d3e5071 ("rtc: cmos: ignore bogus century byte")
> 
> Signed-off-by: Riwen Lu <luriwen@kylinos.cn>
> Acked-by: Eric Wong <e@80x24.org>
> Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Link: https://lore.kernel.org/r/20220106084609.1223688-1-luriwen@kylinos.cn
> Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl> # preparation for stable
> ---
>  drivers/rtc/rtc-mc146818-lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Hello,
> 
> I have prepared this patch for inclusion into stable. Run-tested on top
> of 5.16.7 and 4.9.299, works as intended.

Now queued up, thanks.

greg k-h
