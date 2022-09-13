Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F445B68AC
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 09:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiIMHbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 03:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiIMHbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 03:31:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB2958B4B;
        Tue, 13 Sep 2022 00:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB420B80E20;
        Tue, 13 Sep 2022 07:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931EBC433C1;
        Tue, 13 Sep 2022 07:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663054274;
        bh=vilETUvw2g1sd91EdUM1pQ5GKS9RICQuFAfvW/iSAq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vBogiI3O3oHQ7kMwgYuvOS6HuFwJ8FODKbCq/8DRFwDqy8O4jzb4OpiZSJotm0VR6
         czck5pd5BSOlTLoD0X3QvVa9lHZfBD/vA/OgBMCupFbYUPsWS5JfcK/hutyTtg4+UK
         PCbM8RakfylK0fVfmI2z+uOQKRmjVJxlNIP3ekUrS+MP3WISwEfYtlHgbCQyGyNbON
         T9OPYWUK+ZggSPyiVzEkZDGogVrPPH9f5G36q/C0Qo8TadbNCvT0PG7Bjrd+vmMji9
         zZEXIwmPVt/TgLVzvK38QzTjHougDI0aOCA1nCFUiheV1RYha+KUWlCxtUFfbPVPmG
         LTel/kiDN0M7w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oY0O1-0000s7-3p; Tue, 13 Sep 2022 09:31:13 +0200
Date:   Tue, 13 Sep 2022 09:31:13 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Rob Clark <robdclark@gmail.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Sean Paul <sean@poorly.run>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/7] drm/msm: fix use-after-free on probe deferral
Message-ID: <YyAxwQmN9SDrWa7n@hovoldconsulting.com>
References: <20220912154046.12900-1-johan+linaro@kernel.org>
 <20220912154046.12900-2-johan+linaro@kernel.org>
 <518564a8-5206-80cc-8306-50296de43abf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518564a8-5206-80cc-8306-50296de43abf@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 12, 2022 at 08:52:44PM +0300, Dmitry Baryshkov wrote:
> On 12/09/2022 18:40, Johan Hovold wrote:
> > The bridge counter was never reset when tearing down the DRM device so
> > that stale pointers to deallocated structures would be accessed on the
> > next tear down (e.g. after a second late bind deferral).
> > 
> > Given enough bridges and a few probe deferrals this could currently also
> > lead to data beyond the bridge array being corrupted.
> > 
> > Fixes: d28ea556267c ("drm/msm: properly add and remove internal bridges")
> > Cc: stable@vger.kernel.org      # 5.19
> 
> Fixes: a3376e3ec81c ("drm/msm: convert to drm_bridge")
> Cc: stable@vger.kernel.org # 3.12

The use after free was introduced in 5.19, and the next patch takes care
of the possible overflow of the bridges array that has been around since
3.12.

But sure, this oversight has been there since 3.12. I'll reconsider
adding the other Fixes tag. The stable team struggles with context
changes apparently so not sure it's worth backporting, though.

> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> 
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > ---
> >   drivers/gpu/drm/msm/msm_drv.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
> > index 391d86b54ded..d254fe2507ec 100644
> > --- a/drivers/gpu/drm/msm/msm_drv.c
> > +++ b/drivers/gpu/drm/msm/msm_drv.c
> > @@ -241,6 +241,7 @@ static int msm_drm_uninit(struct device *dev)
> >   
> >   	for (i = 0; i < priv->num_bridges; i++)
> >   		drm_bridge_remove(priv->bridges[i]);
> > +	priv->num_bridges = 0;
> >   
> >   	pm_runtime_get_sync(dev);
> >   	msm_irq_uninstall(ddev);

Johan
