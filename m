Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74044225A0F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 10:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgGTIbH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Jul 2020 04:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbgGTIbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 04:31:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A153FC061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 01:31:06 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1jxRCQ-0004GR-Fo; Mon, 20 Jul 2020 10:31:02 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1jxRCP-0000Bg-RP; Mon, 20 Jul 2020 10:31:01 +0200
Message-ID: <dd59520cfcfd4c93ad9cb54116f0234a706a0bd5.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] media: coda: Add more H264 levels for CODA960
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Robert Beckett <bob.beckett@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org
Date:   Mon, 20 Jul 2020 10:31:01 +0200
In-Reply-To: <f409d4ddad0a352ca7ec84699c94a64e5dbf0407.camel@collabora.com>
References: <20200717034923.219524-1-ezequiel@collabora.com>
         <20200717034923.219524-2-ezequiel@collabora.com>
         <05184a7c923c7e2aacca9da2bafe338ff5a7c16d.camel@pengutronix.de>
         <f409d4ddad0a352ca7ec84699c94a64e5dbf0407.camel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nicolas,

On Fri, 2020-07-17 at 11:50 -0400, Nicolas Dufresne wrote:
> Le vendredi 17 juillet 2020 à 09:48 +0200, Philipp Zabel a écrit :
> > Hi Ezequiel, Nicolas,
> > 
> > On Fri, 2020-07-17 at 00:49 -0300, Ezequiel Garcia wrote:
> > > From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > > 
> > > This add H264 level 4.1, 4.2 and 5.0 to the list of supported formats.
> > > While the hardware does not fully support these levels, it do support
> > > most of them.
> > 
> > Could you clarify this? As far as I understand the hardware supports
> > maximum frame size requirement for up to level 4.2 (8704 macroblocks),
> > but not 5.0, and at least the implementation on i.MX6 does not support
> > the max encoding speed requirements for levels 4.1 and higher.
> > 
> > I don't think the firmware ever produces any output with a level higher
> > than 4.0 either, so what is the purpose of pretending otherwise?

I didn't see the decoder change, ^ this was just referring to the
encoder level.

> The level is a combination of 3 contraints, frame size, raw bitrate and encoded
> bitrate. We have a streams here the decode just fine, that reaches 5.0 for the
> endoded bitrate, but is near 4.0 for everything else. This streams works just
> fine with the 960.

You are right that the decoder, depending on the individual stream, may
well be capable of playing back a higher level than officially
supported. It is just not guaranteed that any stream of that unsupported
level can play back smoothly.

I suppose on i.MX6 the bottleneck is more likely to be the macroblock
processing rate than the encoded bitrate, especially if the memory bus
is under load. I'm not sure we should increase the advertised level
unless we can reach required MB/s as well. That being said, there is a
kernel option in the i.MX6 vendor kernel that disables CPU and bus
frequency scaling, keeps the SoC voltage high, and overclocks the VPU to
352 MHz. So there might be some headroom left to actually support this.

> I think the risk with this patch is that it now allow a stream to
> underperform in raw bitrate, but that can be controlled otherwise by
> the frame interval, so there is no need to limit it through levels.
> I could be wrong.
>
> But in public domain [0], Chips&Media seems to claim 4.2 decode, 4.0 encode. So
> yes, claiming 5.0 is off track, we will reduce this to 4.2 in v2.
> 
> [0] https://www.chipsnmedia.com/fullhd

I'm not sure the CODA960 VPU on i.MX6 at 264 MHz is as capable as the
CODA966 mentioned on their website.

> Considering how buggy and inconcistent this is going to be in decoder drivers,
> I'm tempted to just drop that restriction in GStreamer v4l2 decoders (was added
> by Philippe Normand from Igalia). Specially the bitrate limits, since it is
> quite clear from testing that this limits is only related to real-time
> performance, and that offline decoding should still be possible. Meanwhile, the
> driver should still advertise 4.1 and 4.2 decoding. But we should check the
> decoding/encoding levels are actually not the same, that I haven't checked, the
> code is a bit ... kindly said ... hairy.

I think negotiation is important for sources that can provide multiple
levels, to choose the right level for the decoder. If there is a given
stream with a fixed level, it might indeed be better to not fail
negotiation (maybe have a warning instead) and just hope for the best,
as for some streams it might just work.

regards
Philipp
