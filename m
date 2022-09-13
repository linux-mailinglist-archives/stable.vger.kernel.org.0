Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31355B68F2
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 09:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiIMHt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 03:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiIMHtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 03:49:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1B34D4FD;
        Tue, 13 Sep 2022 00:49:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4E2E61343;
        Tue, 13 Sep 2022 07:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086DDC433D6;
        Tue, 13 Sep 2022 07:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663055358;
        bh=vbEK8a1FZJSD5mb8h3IpS0iL7BqomgfGkSEDht4TmC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W934uYq12yOZ9dEj+er+bqOSj1YRQThqDyVjAjfDVD3Y2cgWhUTADn3/0+8q8/CgX
         aazhOib/w1fOb3C9kgj1i9hB7uzENBI8fWqq0nr9jCHr6Nz8KCIsPrughCznpjkSUd
         gTICcoleBzr7H3UTE5J0MOgJC0KOVn6i27PD+cBFETJ+vpqlJLboZztMSfoXLJq7jh
         GLYdtJ56+q//HKYvSlgHsQyn3cHvBc7PdNHzfHhBTO3FaneG4nJuhyJgar/AeZhVLp
         bWOkK4LtIB2U7S6gtjIqeGK+WjMUpF+SDh4Nph84GEm90agbMYZdkVZkcB4qg71Euo
         yzfCUSvCB+Reg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oY0fT-0000yR-Rl; Tue, 13 Sep 2022 09:49:16 +0200
Date:   Tue, 13 Sep 2022 09:49:15 +0200
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
Subject: Re: [PATCH 2/7] drm/msm: fix memory corruption with too many bridges
Message-ID: <YyA1+xbgF+Gnm37S@hovoldconsulting.com>
References: <20220912154046.12900-1-johan+linaro@kernel.org>
 <20220912154046.12900-3-johan+linaro@kernel.org>
 <1f2dbfae-a29a-d654-0ad6-10125c6b6e0b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f2dbfae-a29a-d654-0ad6-10125c6b6e0b@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 12, 2022 at 08:55:55PM +0300, Dmitry Baryshkov wrote:
> On 12/09/2022 18:40, Johan Hovold wrote:
> > Add the missing sanity checks on the bridge counter to avoid corrupting
> > data beyond the fixed-sized bridge array in case there are ever more
> > than eight bridges.
> > 
> > a3376e3ec81c ("drm/msm: convert to drm_bridge")
> > ab5b0107ccf3 ("drm/msm: Initial add eDP support in msm drm driver (v5)")
> > a689554ba6ed ("drm/msm: Initial add DSI connector support")
> 
> Most probably you've missed the Fixes: here.

Indeed, thanks for catching that.

> > Fixes: 8a3b4c17f863 ("drm/msm/dp: employ bridge mechanism for display enable and disable")
> > Cc: stable@vger.kernel.org	# 3.12
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > ---
> >   drivers/gpu/drm/msm/dp/dp_display.c | 6 ++++++
> >   drivers/gpu/drm/msm/dsi/dsi.c       | 6 ++++++
> >   drivers/gpu/drm/msm/hdmi/hdmi.c     | 5 +++++
> 
> Could you please split this into respective dp/dsi/hdmi patches. This 
> will assist both the review and the stable team.

Yeah, you're right, that should help the stable team if nothing else.

> Otherwise LGTM.

Johan
