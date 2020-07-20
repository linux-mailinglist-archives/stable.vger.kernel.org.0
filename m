Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E8E225A37
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 10:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgGTIkj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Jul 2020 04:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgGTIkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 04:40:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43558C061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 01:40:39 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1jxRLf-0005P6-KK; Mon, 20 Jul 2020 10:40:35 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1jxRLf-0000s3-BC; Mon, 20 Jul 2020 10:40:35 +0200
Message-ID: <0e0bb486f4a95686b1385f978333a584a34db9b0.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] media: coda: Fix reported H264 profile
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Robert Beckett <bob.beckett@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org
Date:   Mon, 20 Jul 2020 10:40:35 +0200
In-Reply-To: <17189cd91b7412fdd102c2710d9e6aa8778aac23.camel@collabora.com>
References: <20200717034923.219524-1-ezequiel@collabora.com>
         <51175cb496644aaa5d5004630925ead4c6f0ddc7.camel@pengutronix.de>
         <17189cd91b7412fdd102c2710d9e6aa8778aac23.camel@collabora.com>
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

On Fri, 2020-07-17 at 11:56 -0400, Nicolas Dufresne wrote:
> Le vendredi 17 juillet 2020 à 10:14 +0200, Philipp Zabel a écrit :
> > On Fri, 2020-07-17 at 00:49 -0300, Ezequiel Garcia wrote:
> > > From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > > 
> > > The CODA960 manual states that ASO/FMO features of baseline are not
> > > supported, so for this reason this driver should only report
> > > constrained baseline support.
> > 
> > I know the encoder doesn't support this, but is this also true of the
> > decoder? The i.MX6DQ Reference Manual explicitly lists H.264/AVC decoder
> > support for both baseline profile and constrained base line profile.
> 
> Hmm, double checking, you are right this is documented in the encoding tools
> sections, not the decoding. But there is extra buffers that need to be passed
> for ASO/FMO to work, I greatly doubt you have ever tested it.

And you are correct, I don't think I use any test streams that have
ASO/FMO enabled.

> This is not supported by GStreamer parser, or FFMPEG parsers either.
> Again, we need to make sure in V2 that encoding and decoding
> capabilities are well seperated.
> 
> As for advertising ASO/FMO, I can leave it there, but be aware I won't be
> testing it. I can provide you links to streams if you care (they are publicly
> accessible throught the ITU conformance streams published by the ITU).

That would be welcome.

> But as for GStreamer and FFMPEG, this is not supported anyway.

Ok, how about changing the commit message to say that this is
unsupported for the encoder and untested for the decoder because there
is no userspace support?

regards
Philipp
