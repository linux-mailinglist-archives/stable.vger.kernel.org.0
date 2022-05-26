Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B857534ECA
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 14:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiEZMFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 08:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiEZMFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 08:05:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E311D02A2;
        Thu, 26 May 2022 05:05:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC21560C52;
        Thu, 26 May 2022 12:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3182C385A9;
        Thu, 26 May 2022 12:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653566739;
        bh=EZ83Wu0JIwui5tEnq9zsFh1J1HyLzUwNJ/Dy+pO3xvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fPMbA5axeabY/ZFxS5rXuKPt7XWp+0mcWg2WC6lVFuvYINemHq5i+oKy9KK0Ni1em
         1DwXq0tblKIBK/yrgHoHB0Z6wZ8DflmvuNsHdkMm7/nKr4u6ItwVgpZ0/KZGLEUTXF
         bffFTjnx5WVhBb8RP8cOYiMmQq95qAN71k7EofXU=
Date:   Thu, 26 May 2022 14:05:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Denis Efremov <efremov@linux.com>
Cc:     Larry.Finger@lwfinger.net, phil@philpotter.co.uk,
        dan.carpenter@oracle.com, straube.linux@gmail.com,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v5.10] staging: rtl8723bs: prevent ->Ssid overflow in
 rtw_wx_set_scan()
Message-ID: <Yo9tEA6AXBg9CV8y@kroah.com>
References: <YoZk3YLEDYKGG5xe@kroah.com>
 <20220520035730.5533-1-efremov@linux.com>
 <YounkTGwmcQns3vy@kroah.com>
 <22589460-930c-b307-acf0-2a49f5f5261f@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22589460-930c-b307-acf0-2a49f5f5261f@linux.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 09:41:09PM +0400, Denis Efremov wrote:
> Hi,
> 
> On 5/23/22 19:26, Greg KH wrote:
> > On Fri, May 20, 2022 at 07:57:30AM +0400, Denis Efremov (Oracle) wrote:
> >> This code has a check to prevent read overflow but it needs another
> >> check to prevent writing beyond the end of the ->Ssid[] array.
> >>
> >> Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
> >> Cc: stable <stable@vger.kernel.org>
> >> Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
> >> ---
> >>  drivers/staging/rtl8723bs/os_dep/ioctl_linux.c | 6 ++++--
> >>  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > And only 5.10 needs this?  What about all other kernel branches?
> > 
> 
> >From 5.10, 5.4, 4.19, to 4.14.
> 
> There is a small spaces conflict in 5.4-4.14 kernels because of
> c77761d660a6 staging: rtl8723bs: Fix spacing issues
> 
> I sent another patch to handle it.

Thanks, all now queued up.

greg k-h
