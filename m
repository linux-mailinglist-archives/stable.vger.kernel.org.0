Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB057608A91
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiJVJBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbiJVJA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6B02D6569
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 01:16:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3803160AE3
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 08:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A0FC433C1;
        Sat, 22 Oct 2022 08:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426532;
        bh=2ljg+XbB845ystKaMxzUcKy1jQe6HlfTeRlQy8QVKro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H01cRwW4xzQXQf/MqtuWjc1iHCX+xUpTnrrGX3PCO6DW7Q0BFxUpUskOpVbWteVaB
         +T06ThvssEtnPq+yhpDBX2suJU7GmkU1J7pMyreElBn9yOKdl7QQmJraPK8YixYhoa
         GDKj2A/tQWbFn7sNv1jn6rdiPKmn+rZCnkr4zVtM=
Date:   Sat, 22 Oct 2022 09:41:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Werner Sembach <wse@tuxedocomputers.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] ACPI: video: Force backlight native for more TongFang
 devices
Message-ID: <Y1OexcswgzRKj8BF@kroah.com>
References: <20221019153059.127812-1-wse@tuxedocomputers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019153059.127812-1-wse@tuxedocomputers.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 05:30:59PM +0200, Werner Sembach wrote:
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
> The upstream commit "ACPI: video: Make backlight class device registration
> a separate step (v2)" changes the logic in a way that these quirks are not
> required anymore, but kernel <= 6.0 still need these.

Please properly reference an upstream commit the way the documentation
asks you to (you forgot the sha1 number), and also you need to really
really really document why the upstream commit does not work here.

And you need to cc: all of the developers and maintainers on the
original commit and get them to agree that this is the acceptable change
to take, as it is not upstream and it needs their approval.

Please fix up and resend it letting everyone know what is happening
here.

thanks,

greg k-h
