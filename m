Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A99227A4B
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 10:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgGUIOz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Jul 2020 04:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgGUIOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 04:14:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E90CC0619D7
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 01:14:54 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1jxnQH-0000Ep-8p; Tue, 21 Jul 2020 10:14:49 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1jxnQG-0002ML-Aj; Tue, 21 Jul 2020 10:14:48 +0200
Message-ID: <110980fea9c24ee449487b5d28822dccf7962494.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] media: coda: Add more H264 levels for CODA960
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Robert Beckett <bob.beckett@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org
Date:   Tue, 21 Jul 2020 10:14:48 +0200
In-Reply-To: <4fee7fb9ded19cb9dab58561396e6f30393e42fa.camel@collabora.com>
References: <20200717034923.219524-1-ezequiel@collabora.com>
         <20200717034923.219524-2-ezequiel@collabora.com>
         <05184a7c923c7e2aacca9da2bafe338ff5a7c16d.camel@pengutronix.de>
         <4fee7fb9ded19cb9dab58561396e6f30393e42fa.camel@collabora.com>
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

Hi,

[adding Stanimir for some insight, venus also has a decoder h.264 level
control]

On Mon, 2020-07-20 at 12:09 -0400, Nicolas Dufresne wrote:
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
[...]
> 
> So do you have an opinion on the way forward ? Personally I like the
> idea of giving the list of level_idc that won't cause the parser to
> reject it, and leave it to the user to validate the
> Resolution/Framerate seperatly, we have the V4L2 API for that. Let me
> know, as we'll use that for V2.

My opinion was that for decoders the possible values of the
V4L2_CID_MPEG_VIDEO_H264_LEVEL control should reflect the h.264 levels
that the decoder can actually decode in real-time. Otherwise we are
effectively ignoring the MaxMBPS and MaxBR properties of the level,
which makes the control useless for negotiation.

But I am beginning to think that I am wrong. The level control is set to
the level of the stream after parsing the stream header, so arguably it
must be possible to set it to anything that can be decoded at all, real-
time or not.

Further, the documentation says nothing about this. It doesn't even
mention decoders:
                                                                     
  ``V4L2_CID_MPEG_VIDEO_H264_LEVEL``
      (enum)

  enum v4l2_mpeg_video_h264_level -
      The level information for the H264 video elementary stream.
      Applicable to the H264 encoder. Possible values are:

  [...]

So at the moment I would tend towards expanding the list of supported
formats to 4.2, even though we can't decoder > 4.0 in real-time on
i.MX6.

Should we add a note to the V4L2_CID_MPEG_VIDEO_H264_LEVEL documentation
that this is applicable to H264 decoders as well, set by the decoder
after parsing the SPS, and that the list of levels this control can be
set to does not guarantee real-time capability at each level?

regards
Philipp
