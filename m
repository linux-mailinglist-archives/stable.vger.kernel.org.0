Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3DC604A5D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 17:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiJSPEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 11:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiJSPDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 11:03:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9AF161FE6
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 07:58:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24FCF618B4
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 14:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD53C433C1;
        Wed, 19 Oct 2022 14:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666191432;
        bh=zHSmA9ohxSbBWYoIRsQzTeHDZKkXbPzCOoJb/lC13lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jfChoJSQ5XKzpP2fPcANSQsywXDRvOgBNfxu108hnTkSOgS2V7otKdilp2z+4k1Jb
         mSZJKqp+jo+51mGGHQDXrqIAUB2D1qnQOXXrp0HpmNlw45VhgS3Dh9Yh/zttQ/WvkC
         UZnDpCeln7bRfxUngPJtZS1BOuM+e1wsHdasITNs=
Date:   Wed, 19 Oct 2022 16:57:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Werner Sembach <wse@tuxedocomputers.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ACPI: video: Force backlight native for more TongFang
 devices
Message-ID: <Y1AQRaEvqmVWHusI@kroah.com>
References: <20221019140142.17558-1-wse@tuxedocomputers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019140142.17558-1-wse@tuxedocomputers.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 04:01:42PM +0200, Werner Sembach wrote:
> commit 3dbc80a3e4c55c4a5b89ef207bed7b7de36157b4 upstream.

That is not this commit at all :(

> The upstream commit "ACPI: video: Make backlight class device registration
> a separate step (v2)" changes the logic in a way that these quirks are not
> required anymore, but kernel <= 6.0 still need these.
> 
> The TongFang GKxNRxx, GMxNGxx, GMxZGxx, and GMxRGxx / TUXEDO
> Stellaris/Polaris Gen 1-4, have the same problem as the Clevo NL5xRU and
> NL5xNU / TUXEDO Aura 15 Gen1 and Gen2:
> They have a working native and video interface for screen backlight.
> However the default detection mechanism first registers the video interface
> before unregistering it again and switching to the native interface during
> boot. This results in a dangling SBIOS request for backlight change for
> some reason, causing the backlight to switch to ~2% once per boot on the
> first power cord connect or disconnect event. Setting the native interface
> explicitly circumvents this buggy behaviour by avoiding the unregistering
> process.
> 
> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
> ---
>  drivers/acpi/video_detect.c | 64 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
