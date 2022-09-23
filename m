Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B5C5E73D0
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 08:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiIWGRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 02:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiIWGRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 02:17:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0E512387A;
        Thu, 22 Sep 2022 23:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3CD2B821C2;
        Fri, 23 Sep 2022 06:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923D2C433D6;
        Fri, 23 Sep 2022 06:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663913843;
        bh=087222Xy8pZjxNKwBirqYA3XIzVV/4i7Mss3vpSpd14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JWIwwHV/RaIiU6aBqkf7d1JFcWRbDborvpLhn3FVp0PRRXG/Ofa8dYm9RTBoMHfMx
         KbV2rEc7i7fUrlTOCJ5CtIynqpFMnkVUjp6hjHhZRtiFI9wlEtLYsbG7x8WALnduAz
         wGQpsJUKd5Gd1j3aZoJf/HPbJpTfR7meZCsOdBM5gs8e+d5xf1Kb5ZzUv2NCTRrXWq
         NimW7ZebHGANSFgKT4lEFWpoedoa01T9VVg8KIHDcXX/sL2Q0Pkni/0oFw1xWqbu5n
         B8bWTYdit0IMdjyJA5OIFtqQ3RC5CsUzu9tNzs9O8SyKJewh5pH9EPvvufNCR222Pp
         g9Vw4qFwOo+VQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1obc06-0006GM-An; Fri, 23 Sep 2022 08:17:26 +0200
Date:   Fri, 23 Sep 2022 08:17:26 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kuogee Hsieh <quic_khsieh@quicinc.com>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Sean Paul <sean@poorly.run>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 08/10] drm/msm/hdmi: fix IRQ lifetime
Message-ID: <Yy1Pdr6gxGR1O+o2@hovoldconsulting.com>
References: <20220913085320.8577-1-johan+linaro@kernel.org>
 <20220913085320.8577-9-johan+linaro@kernel.org>
 <9e223c13-15e2-de5e-e1e1-0dbbe629a0a1@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e223c13-15e2-de5e-e1e1-0dbbe629a0a1@quicinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 12:55:03PM -0700, Kuogee Hsieh wrote:
> 
> On 9/13/2022 1:53 AM, Johan Hovold wrote:
> > Device-managed resources allocated post component bind must be tied to
> > the lifetime of the aggregate DRM device or they will not necessarily be
> > released when binding of the aggregate device is deferred.
> >
> > This is specifically true for the HDMI IRQ, which will otherwise remain
> > requested so that the next bind attempt fails when requesting the IRQ a
> > second time.
> >
> > Fix this by tying the device-managed lifetime of the HDMI IRQ to the DRM
> > device so that it is released when bind fails.
> >
> > Fixes: 067fef372c73 ("drm/msm/hdmi: refactor bind/init")
> > Cc: stable@vger.kernel.org      # 3.19
> > Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> 
> > Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
> > Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>

I believe you meant:

Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>

here (i.e. without the '>' quotes). Otherwise the tooling may not pick
these up.

Thanks for reviewing and testing.

Johan
