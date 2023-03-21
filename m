Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2C46C3260
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 14:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjCUNNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 09:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjCUNNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 09:13:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576EAA5E2;
        Tue, 21 Mar 2023 06:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 948D5B81670;
        Tue, 21 Mar 2023 13:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D874C433EF;
        Tue, 21 Mar 2023 13:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679404392;
        bh=Ie0I6DspmqUGmFzLY8M9p06FQQUjb9WBd6Z2Y5RxFMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WCELKUAO4DmRhWUevMaHTsfdWUOjmOwX6QDGRTGx8cr2tDflzYANu1EphfFEiuacN
         73IJBFv8dFoFgJspV1c2kimtV/h9RslHEeXTHNU71iV2EBgXhherzoHszVgFNDN0Y+
         SQEdUjvv4ttww2/mSl2jf4bmNKcGUD/3FSuCmYCoXHhZK3ojjR3yc8cHxkZ2MdqGDw
         6zp/6BorvlCFtxWIlglrzjZLZjn8khx+muMaJjNKTzhW6I/CZ5/1CJX4uQLO80aQO2
         T6Wec1E+zo0rJmtBFFf3unDCUrY/YYGRwClwRdqzpnsbNM7/shgpSK1BcTieLe2ZLh
         4e8zFbiwUOlmw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pebox-000683-A5; Tue, 21 Mar 2023 14:14:36 +0100
Date:   Tue, 21 Mar 2023 14:14:35 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/meson: fix missing component unbind on bind errors
Message-ID: <ZBmtu4klxYwQyN7R@hovoldconsulting.com>
References: <20230306103533.4915-1-johan+linaro@kernel.org>
 <CAFBinCBsC+P=zvh6RF3UKiPnferUYU0QZvZfnn1oS5xWX-65Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFBinCBsC+P=zvh6RF3UKiPnferUYU0QZvZfnn1oS5xWX-65Jw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 09, 2023 at 10:41:18PM +0100, Martin Blumenstingl wrote:

> On Mon, Mar 6, 2023 at 11:35 AM Johan Hovold <johan+linaro@kernel.org> wrote:
> [...]
> > @@ -325,23 +325,23 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
> >
> >         ret = meson_encoder_hdmi_init(priv);

> I'm wondering if component_bind_all() can be moved further down.
> Right now it's between meson_encoder_cvbs_init() and
> meson_encoder_hdmi_init(). So it seems that encoders don't rely on
> component registration.

Perhaps it can, but that would be a separate change (unless there is
something inherently wrong with the current initialisation order).
 
> Unfortunately I am also not familiar with this and I'm hoping that
> Neil can comment on this.

Any comments on this one, Neil?

Johan
