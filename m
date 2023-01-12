Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7C76672A1
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjALMwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjALMwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:52:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83604EC8E;
        Thu, 12 Jan 2023 04:52:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 687AA60AC3;
        Thu, 12 Jan 2023 12:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C37FC433EF;
        Thu, 12 Jan 2023 12:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673527951;
        bh=y28Fp8xoZWZVm5zKdmGi0Ihx0GiHsk0YCVX29bnybjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gVVZ+BYzKXdi+W4nuI6DYf7ZadoindJpejIWncosE+Uv+CPmFi5+p6P2bQP1Nl3Bb
         2tXnG3n5M1l1gA5q/gZVIU+fVW2wJYsHZ1YHOPXWwHs74HxXND3vKqWVjQ5UJYQVpS
         /lNsf/k9GJCUiMVgE8KcxzSGLIfeTYispfrTv4Zs=
Date:   Thu, 12 Jan 2023 13:52:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, stable@vger.kernel.org,
        Saravana Kannan <saravanak@google.com>,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-4.14] driver core: Fix bus_type.match() error
 handling in __driver_attach()
Message-ID: <Y8ACjLc272RM0vSP@kroah.com>
References: <20230110021536.1347134-1-isaacmanjarres@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110021536.1347134-1-isaacmanjarres@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 09, 2023 at 06:15:36PM -0800, Isaac J. Manjarres wrote:
> commit 27c0d217340e47ec995557f61423ef415afba987 upstream.
> 
> When a driver registers with a bus, it will attempt to match with every
> device on the bus through the __driver_attach() function. Currently, if
> the bus_type.match() function encounters an error that is not
> -EPROBE_DEFER, __driver_attach() will return a negative error code, which
> causes the driver registration logic to stop trying to match with the
> remaining devices on the bus.
> 
> This behavior is not correct; a failure while matching a driver to a
> device does not mean that the driver won't be able to match and bind
> with other devices on the bus. Update the logic in __driver_attach()
> to reflect this.
> 
> Fixes: 656b8035b0ee ("ARM: 8524/1: driver cohandle -EPROBE_DEFER from bus_type.match()")
> Cc: stable@vger.kernel.org
> Cc: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
> ---
>  drivers/base/dd.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

All now queued up, thanks.

greg k-h
