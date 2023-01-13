Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AAD668FBC
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 08:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbjAMH5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 02:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbjAMH5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 02:57:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DE843E52;
        Thu, 12 Jan 2023 23:57:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EA69B82082;
        Fri, 13 Jan 2023 07:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6BFC433EF;
        Fri, 13 Jan 2023 07:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673596650;
        bh=juHaHBh9x6cKYqj2AXbOmzUdy7K0OtqpTmvN7ThLO/Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OocD74CLJ9vF7YkOzEO6xQAASzo57PlPsnuYNXBkjvKhl8SaAbloH4/LZ73o++jtV
         pd9Ft8oF+/jKLNUT1D6VODVjvFG5RpznhV/8E1oN/1L5/81si/qOVDfq0mJTjVk3kw
         Jv6YhxatEAh3SSrNgND5uL+Ez3bX5KWcm+NdW4XbeaGbxXtt/eDvMwDmPxaF0SJ0+5
         Bkk330NhUZ7kAOQiqH2NHYPxWYAtFuSolzLv3WVoV5hfp3bGSrSgAEo+lnf7UPUCzj
         W5qA5NmQLVkL9HO1KwYWDO3/b5W12m5HutAVoPxphGWQQFHLjFoylGY5uM58AmPJ8D
         hxxwF+0iy3xgg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pGEwV-00066j-HK; Fri, 13 Jan 2023 08:57:40 +0100
Date:   Fri, 13 Jan 2023 08:57:39 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 5.15.y 2/4] phy: qcom-qmp-combo: fix memleak on probe
 deferral
Message-ID: <Y8EO8w9Smn4NAox6@hovoldconsulting.com>
References: <20230113005405.3992011-1-swboyd@chromium.org>
 <20230113005405.3992011-3-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113005405.3992011-3-swboyd@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 04:54:03PM -0800, Stephen Boyd wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> commit 2de8a325b1084330ae500380cc27edc39f488c30 upstream.
> 
> Switch to using the device-managed of_iomap helper to avoid leaking
> memory on probe deferral and driver unbind.
> 
> Note that this helper checks for already reserved regions and may fail
> if there are multiple devices claiming the same memory.

This bit turned out to catch some buggy bindings and dts, so if you want
to backport this one then the corresponding fixes for that would be
needed as well.

That includes

	a5d6b1ac56cb ("phy: qcom-qmp-usb: fix memleak on probe deferral")

and some dts fixes which likely already have been backported.

It may even be preferred to keep to just skip this patch and keep those
small memory leaks on probe deferral to not risk any regressions in
stable.

> Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220916102340.11520-5-johan+linaro@kernel.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Johan
