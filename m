Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFE6664771
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 18:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbjAJRbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 12:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbjAJRbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 12:31:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C989F1AA39
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:31:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 893EFB818E0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 17:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC95C433EF;
        Tue, 10 Jan 2023 17:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673371859;
        bh=HTp/zKi4Lj1zeSQuHt4KfduJhpxTioc97zvwCLT6QxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OVL59XPLrfbn26arnjQnMwUHpAekWwc54P7OZDVpnST7J+OhQ7veGxCIggLaFMoXs
         hiQtuHAzCGa0+/FkbyPO4XvbKl9FDp+ESRZM66leEeS6ATVhGbDFSfqahh+2+O5Bma
         KfjGVD7Brd7CY3H3PHgPbR6yiKY4uJ0B5b4knWK8=
Date:   Tue, 10 Jan 2023 18:30:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jocelyn Falempe <jfalempe@redhat.com>
Cc:     stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4
Message-ID: <Y72g0M2uHdcrG3E3@kroah.com>
References: <167284297425244@kroah.com>
 <20230104162729.424575-1-jfalempe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104162729.424575-1-jfalempe@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 05:27:29PM +0100, Jocelyn Falempe wrote:
> commit b389286d0234e1edbaf62ed8bc0892a568c33662 upstream.
> 
> For G200_SE_A, PLL M setting is wrong, which leads to blank screen,
> or "signal out of range" on VGA display.
> previous code had "m |= 0x80" which was changed to
> m |= ((pixpllcn & BIT(8)) >> 1);
> 
> Tested on G200_SE_A rev 42
> 
> This line of code was moved to another file with
> commit 877507bb954e ("drm/mgag200: Provide per-device callbacks for
> PIXPLLC") but can be easily backported before this commit.
> 
> v2: * put BIT(7) First to respect MSB-to-LSB (Thomas)
>     * Add a comment to explain that this bit must be set (Thomas)
> 
> backported to v6.0.17, it also applies cleanly to v5.15.86
> 
> Fixes: 2dd040946ecf ("drm/mgag200: Store values (not bits) in struct mgag200_pll_values")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> Link: https://patchwork.freedesktop.org/patch/msgid/20221013132810.521945-1-jfalempe@redhat.com
> ---
>  drivers/gpu/drm/mgag200/mgag200_pll.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Now queued up, thanks.

greg k-h
