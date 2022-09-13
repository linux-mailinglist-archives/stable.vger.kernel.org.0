Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCBC5B6881
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 09:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiIMHSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 03:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiIMHS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 03:18:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B08B4BD30;
        Tue, 13 Sep 2022 00:18:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EF8AB80DC2;
        Tue, 13 Sep 2022 07:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9A0C433B5;
        Tue, 13 Sep 2022 07:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663053499;
        bh=FC9a9cUyZ6tKHf4RlLIdqtcJUM8pTZqYprxyD5qXv7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S3A9nfZgG47jTHHLHmXmbPEuZC2AludnQHnTqUXcqG150oeHp4MzYpHZ5QEnaEe+J
         hOMFjatPLS5ji11A3qfoG1B5R7Mh6j4u2oHbpctM5uFWbijuq8ECMmmsDzUBwCEvol
         zppyt6HorKW/b5mwvMgdzcIkGK90dajcR97tB/oxo/AF21knSWrJToJ12WRTN0DQy/
         BnMGbc+AdwBBmBQLJFLVFRYO6WpA/ihe1nSbBbJIvdjykxVoKcI7rXQDGd66XXWEES
         4fXU9zP4Ez9pI4X1G0hr4ejXDyMBZP4cMZjoo+OTrLAqSbfAnb5x1U1UjxLuACw3YB
         a2f9UKGgifaGQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oY0BV-0000lx-1z; Tue, 13 Sep 2022 09:18:17 +0200
Date:   Tue, 13 Sep 2022 09:18:17 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
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
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Subject: Re: [PATCH 4/7] drm/msm/dp: fix aux-bus EP lifetime
Message-ID: <YyAuuTlDoLAntrO6@hovoldconsulting.com>
References: <20220912154046.12900-1-johan+linaro@kernel.org>
 <20220912154046.12900-5-johan+linaro@kernel.org>
 <e60f0053-3801-bf33-5841-69f16215fa00@linaro.org>
 <CAD=FV=U8_bjPm3NEOWqzehrx0xFV4U771nTuhhOiM9gKDVCo5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=U8_bjPm3NEOWqzehrx0xFV4U771nTuhhOiM9gKDVCo5g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 07:35:15AM +0100, Doug Anderson wrote:
> Hi,
> 
> On Mon, Sep 12, 2022 at 7:10 PM Dmitry Baryshkov
> <dmitry.baryshkov@linaro.org> wrote:
> >
> > On 12/09/2022 18:40, Johan Hovold wrote:
> > > Device-managed resources allocated post component bind must be tied to
> > > the lifetime of the aggregate DRM device or they will not necessarily be
> > > released when binding of the aggregate device is deferred.
> > >
> > > This can lead resource leaks or failure to bind the aggregate device
> > > when binding is later retried and a second attempt to allocate the
> > > resources is made.
> > >
> > > For the DP aux-bus, an attempt to populate the bus a second time will
> > > simply fail ("DP AUX EP device already populated").
> > >
> > > Fix this by amending the DP aux interface and tying the lifetime of the
> > > EP device to the DRM device rather than DP controller platform device.
> >
> > Doug, could you please take a look?
> >
> > For me this is another reminder/pressure point that we should populate
> > the AUX BUS from the probe(), before binding the components together.
> 
> Aside from the kernel robot complaints, I'm not necessarily convinced.
> I think we know that the AUX DP stuff in MSM-DP is fragile right now
> and Qualcomm has promised to clean it up. This really feels like a
> band-aid and is really a sign that we're populating the AUX DP bus in
> the wrong place in Qualcomm's code. As you said, if we moved this to
> probe(), which is the plan in the promised cleanup, then it wouldn't
> be a problem.

Right, but that appears to be non-trivial judging from the discussions
you had back when the offending patch was merged:

	https://lore.kernel.org/lkml/CAD=FV=X+QvjwoT2zGP82KW4kD0oMUY6ZgCizSikNX_Uj8dNDqA@mail.gmail.com/t/#u

> As far as I know Qualcomm has queued this cleanup behind their current
> PSR work (though it's never been clear why both can't be worked on at
> the same time) and the PSR work was stalled because they couldn't
> figure out what caused the glitching I reported. It's still on my nag
> list that I bring up with them every week...
> 
> In any case, if a band-aid is urgent, maybe you could just call
> of_dp_aux_populate_bus() directly in Qualcomm code and you could add
> your own devm_add_action_or_reset() on the DRM device.

Yeah, that's probably better. I apparently missed a bunch of users of
devm_of_dp_aux_populate_ep_devices() after searching for
devm_of_dp_aux_populate_bus() instead. Judging from a quick glance all
of these populate the bus at probe, so Qualcomm indeed appears to be
the odd bird here.

But the bug is real, in mainline and needs to be fixed, so rolling a
custom devm action indeed should to be the right thing to do here (if
only to have a smaller fix).

Johan
