Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63447223FEC
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 17:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgGQPuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 11:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgGQPuy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 11:50:54 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324BCC0619D2;
        Fri, 17 Jul 2020 08:50:54 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: nicolas)
        with ESMTPSA id EA4062A03FC
Message-ID: <f409d4ddad0a352ca7ec84699c94a64e5dbf0407.camel@collabora.com>
Subject: Re: [PATCH 2/2] media: coda: Add more H264 levels for CODA960
From:   Nicolas Dufresne <nicolas.dufresne@collabora.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Robert Beckett <bob.beckett@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org
Date:   Fri, 17 Jul 2020 11:50:38 -0400
In-Reply-To: <05184a7c923c7e2aacca9da2bafe338ff5a7c16d.camel@pengutronix.de>
References: <20200717034923.219524-1-ezequiel@collabora.com>
         <20200717034923.219524-2-ezequiel@collabora.com>
         <05184a7c923c7e2aacca9da2bafe338ff5a7c16d.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le vendredi 17 juillet 2020 à 09:48 +0200, Philipp Zabel a écrit :
> Hi Ezequiel, Nicolas,
> 
> On Fri, 2020-07-17 at 00:49 -0300, Ezequiel Garcia wrote:
> > From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > 
> > This add H264 level 4.1, 4.2 and 5.0 to the list of supported formats.
> > While the hardware does not fully support these levels, it do support
> > most of them.
> 
> Could you clarify this? As far as I understand the hardware supports
> maximum frame size requirement for up to level 4.2 (8704 macroblocks),
> but not 5.0, and at least the implementation on i.MX6 does not support
> the max encoding speed requirements for levels 4.1 and higher.
> 
> I don't think the firmware ever produces any output with a level higher
> than 4.0 either, so what is the purpose of pretending otherwise?

The level is a combination of 3 contraints, frame size, raw bitrate and encoded
bitrate. We have a streams here the decode just fine, that reaches 5.0 for the
endoded bitrate, but is near 4.0 for everything else. This streams works just
fine with the 960. I think the risk with this patch is that it now allow a
stream to underperform in raw bitrate, but that can be controlled otherwise by
the frame interval, so there is no need to limit it through levels.  I could be
wrong.

But in public domain [0], Chips&Media seems to claim 4.2 decode, 4.0 encode. So
yes, claiming 5.0 is off track, we will reduce this to 4.2 in v2.

[0] https://www.chipsnmedia.com/fullhd

Considering how buggy and inconcistent this is going to be in decoder drivers,
I'm tempted to just drop that restriction in GStreamer v4l2 decoders (was added
by Philippe Normand from Igalia). Specially the bitrate limits, since it is
quite clear from testing that this limits is only related to real-time
performance, and that offline decoding should still be possible. Meanwhile, the
driver should still advertise 4.1 and 4.2 decoding. But we should check the
decoding/encoding levels are actually not the same, that I haven't checked, the
code is a bit ... kindly said ... hairy.

> 
> regards
> Philipp

