Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE5252D42C
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 15:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237732AbiESNkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 09:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiESNka (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 09:40:30 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F975A5019;
        Thu, 19 May 2022 06:40:29 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 107)
        id 7916F68BEB; Thu, 19 May 2022 15:40:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
Received: from blackhole (p5b0d840b.dip0.t-ipconnect.de [91.13.132.11])
        by verein.lst.de (Postfix) with ESMTPSA id 6467768AA6;
        Thu, 19 May 2022 15:39:58 +0200 (CEST)
Date:   Thu, 19 May 2022 15:39:52 +0200
From:   Torsten Duwe <duwe@lst.de>
To:     Vasily Khoruzhick <anarsoul@gmail.com>
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Thierry Reding <treding@nvidia.com>,
        Lyude Paul <lyude@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Geyer <harald@ccbib.org>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/bridge: fix anx6345 power up sequence
Message-ID: <20220519153952.7c6c412b@blackhole>
In-Reply-To: <CA+E=qVcNasK=q8o0g1teqK3+cD3aywy+1bgtTJC4VvaZvfZtGA@mail.gmail.com>
References: <20220417181538.57fa1303@blackhole>
        <CA+E=qVeX2aU0hiDMxLXzVk-YiMsqKKFKpm=cc=72joMhZmNV1g@mail.gmail.com>
        <CA+E=qVdEtx8wVbcrMQYGB1ur1ykvNRp1L174mVSMkB0zeOPYNQ@mail.gmail.com>
        <20220428175759.13f75c21@blackhole.lan>
        <CA+E=qVcNasK=q8o0g1teqK3+cD3aywy+1bgtTJC4VvaZvfZtGA@mail.gmail.com>
Organization: LST e.V.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 18 May 2022 09:53:58 -0700
Vasily Khoruzhick <anarsoul@gmail.com> wrote:

> On Thu, Apr 28, 2022 at 8:58 AM Torsten Duwe <duwe@lst.de> wrote:

> > power on the eDP bridge? Could there be any leftovers from that
> > mechanism? I use a hacked-up U-Boot with a procedure similar to the
> > kernel driver as fixed by this change.

I was asking because I recall an ugly hack in some ATF code to power up
the chip correctly. Did you patch ATF, and maybe call functions of it
at runtime?

> >
> > But the main question is: does this patch in any way worsen the
> > situation on the pinebook?
> 
> I don't think it worsens anything, but according to the datasheet the
> change makes no sense. Could you try increasing T2 instead of changing
> the power sequence?

According to the datasheet, there is also T3, I realise now. The
diagram talks about "System Clock", but both Teres and Pinebook have a
passive resonator circuit there. Correct me if I'm wrong, but without
chip power, there is little to resonate. What if that driving clock
circuit is powered by Vdd25? Maybe the earlier provision of 2V5 is
enough for Teres' Q4, but Pinebook X4 takes even longer? The start-up
times can be in the range of milliseconds.

	Torsten
