Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9796D4538
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjDCNEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbjDCNEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:04:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E3D3A9B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:04:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58E9CB819EB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 13:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC6EC433D2;
        Mon,  3 Apr 2023 13:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680527090;
        bh=6ftVDDlMi7etAy/PAS65k9z6l3qVaweygkMixTsRwp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BXADRBppdX24QoLgJc4lyZWid0g3tWaq04tCoisj4F7j/SjOpIvfMKPBZPLAnOTNT
         rs/B0e4LtYb8waB0qvSF5rhAYlZN8uzeor1lP8e1t6s8hYqumCP3SfXNPfjHeHe+cV
         3twRs6U0SINg4A1R0Vg+dFkKwpmcleFudKhFoezE=
Date:   Mon, 3 Apr 2023 15:04:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        martin.blumenstingl@googlemail.com,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: stable-rc: queue/4.19: drivers/gpu/drm/meson/meson_drv.c:316:17:
 error: 'struct meson_drm' has no member named 'afbcd'
Message-ID: <2023040338-vanity-giving-9b22@gregkh>
References: <CA+G9fYu_4iKLXTn1pSgUfAJTVLduT+XUMvs6w4E_DCpofRGD4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu_4iKLXTn1pSgUfAJTVLduT+XUMvs6w4E_DCpofRGD4Q@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 03:54:57PM +0530, Naresh Kamboju wrote:
> Following build errors noticed on stable-rc queue/4.19.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> 
> Supecting commit:
>   drm/meson: Fix error handling when afbcd.ops->init fails
>   [ Upstream commit fa747d75f65d1b1cbc3f4691fa67b695e8a399c8 ]
> 
> Build log:
> ---------
> drivers/gpu/drm/meson/meson_drv.c: In function 'meson_drv_bind_master':
> drivers/gpu/drm/meson/meson_drv.c:316:17: error: 'struct meson_drm'
> has no member named 'afbcd'
>   316 |         if (priv->afbcd.ops)
>       |                 ^~
> drivers/gpu/drm/meson/meson_drv.c:317:21: error: 'struct meson_drm'
> has no member named 'afbcd'
>   317 |                 priv->afbcd.ops->exit(priv);
>       |                     ^~
> make[5]: *** [scripts/Makefile.build:303:
> drivers/gpu/drm/meson/meson_drv.o] Error 1
> 
> details link,
> https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_4.19/build/v4.19.279-77-gb60454c8d9bc/testrun/16027306/suite/build/test/gcc-11-defconfig-lkftconfig/log
> https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_4.19/build/v4.19.279-77-gb60454c8d9bc/testrun/16027306/suite/build/test/gcc-11-defconfig-lkftconfig/history/
> 
> 

Thanks, also dropped from the 5.4.y queue.

greg k-h
