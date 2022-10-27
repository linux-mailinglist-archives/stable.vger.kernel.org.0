Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C317560F51B
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiJ0K3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235460AbiJ0K26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:28:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7620150F8C
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 03:28:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5102462245
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCC6C433D6;
        Thu, 27 Oct 2022 10:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666866517;
        bh=6uiB2SJffohuOIXzxYfmLWP77UijtbrQhW0KcGlhnQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MKGgpM0Lc8PqJRYv/KDCRpda3evNSsGJWn1v94zR+6uUb3wK3wLk1FKrj0lrzTyia
         xK8yOJXe+eCBfnqI7CTaIYfYPJmBpfbNw9ZdIAcW+TtSu/k1IilUlBMZNFWylgC5tx
         ajXhCdAjr8ph43dWpQzwLKyP4Lf/TvTyQybl2trs=
Date:   Thu, 27 Oct 2022 12:28:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Werner Sembach <wse@tuxedocomputers.com>
Cc:     stable@vger.kernel.org, hdegoede@redhat.com, daniel@ffwll.ch,
        airlied@redhat.com, lenb@kernel.org, rafael.j.wysocki@intel.com
Subject: Re: [PATCH v3] ACPI: video: Force backlight native for more TongFang
 devices
Message-ID: <Y1pdUYkQhifhVUBO@kroah.com>
References: <20221026152246.24990-1-wse@tuxedocomputers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026152246.24990-1-wse@tuxedocomputers.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 05:22:46PM +0200, Werner Sembach wrote:
> commit 3dbc80a3e4c55c4a5b89ef207bed7b7de36157b4 upstream.
> 
> This commit is very different from the upstream commit! It fixes the same
> issue by adding more quirks, rather then the general fix from the 6.1
> kernel, because the general fix from the 6.1 kernel is part of a larger
> refactoring of the backlight code which is not suitable for the stable
> series.
> 
> As described in "ACPI: video: Drop NL5x?U, PF4NU1F and PF5?U??
> acpi_backlight=native quirks" (10212754a0d2) the upstream commit "ACPI:
> video: Make backlight class device registration a separate step (v2)"
> (3dbc80a3e4c5) makes these quirks unnecessary. However as mentioned in this
> bugtracker ticket https://bugzilla.kernel.org/show_bug.cgi?id=215683#c17
> the upstream fix is part of a larger patchset that is overall too complex
> for stable.
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
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
> ---
>  drivers/acpi/video_detect.c | 64 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)

Now queued up, thanks.

greg k-h
