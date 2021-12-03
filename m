Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E518B4674D8
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 11:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379934AbhLCKdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 05:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379913AbhLCKcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 05:32:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE180C061759;
        Fri,  3 Dec 2021 02:29:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B28EECE2595;
        Fri,  3 Dec 2021 10:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E9BC53FD1;
        Fri,  3 Dec 2021 10:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638527363;
        bh=2aTe9OD0sbvi4LQYZJMiS/c/nCst/rZuoFn1NalolJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L9lxR3z2Xlv5OFIxdpZjF7EfSgYc1tA0y8SoPqaVyx2KSu912PqF69c4E8l4w1XBE
         qFYWhsmeYPYNN3nS0MjMeJtVcgKftmdiNmBUAegyEapTlTW3AbcoBKIDCA1+Pv7N76
         3xLpzKxgNaW/XfZtS3J600V3YSzOWsiZ2tdb5CvQpj88Ex+dwsJPHK1zR0e/IeyspN
         by4oBBusuXMrop6llhkbiKslOhqEl8XPo1/rTxqG2S/XNbnfB3Tu1DcvVdHQSrCORQ
         uRUlqbEEOeJ3Mry3zJUV8QiKME/Qaf94qJsm5/LNcYicujjUGeoaseLACstXFscVep
         eG5WhYWthF6jw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mt5oR-00024M-Um; Fri, 03 Dec 2021 11:29:08 +0100
Date:   Fri, 3 Dec 2021 11:29:07 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] media: uvcvideo: fix division by zero at stream start
Message-ID: <Yanxc/229JFkuP/v@hovoldconsulting.com>
References: <20211026095511.26673-1-johan@kernel.org>
 <163524570516.1184428.14632987312253060787@Monstersaurus>
 <YXfjSJ+fm+LV/m+M@pendragon.ideasonboard.com>
 <YXfvXzgnvPVqwqZs@hovoldconsulting.com>
 <YXh4NqnpzOnPiA5/@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXh4NqnpzOnPiA5/@pendragon.ideasonboard.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurent,

On Wed, Oct 27, 2021 at 12:50:46AM +0300, Laurent Pinchart wrote:
> Hi Johan,
> 
> On Tue, Oct 26, 2021 at 02:06:55PM +0200, Johan Hovold wrote:
> > On Tue, Oct 26, 2021 at 02:15:20PM +0300, Laurent Pinchart wrote:
> > > On Tue, Oct 26, 2021 at 11:55:05AM +0100, Kieran Bingham wrote:
> > > > Quoting Johan Hovold (2021-10-26 10:55:11)
> > > > > Add the missing bulk-endpoint max-packet sanity check to probe() to
> > > > > avoid division by zero in uvc_alloc_urb_buffers() in case a malicious
> > > > > device has broken descriptors (or when doing descriptor fuzz testing).
> > > > > 
> > > > > Note that USB core will reject URBs submitted for endpoints with zero
> > > > > wMaxPacketSize but that drivers doing packet-size calculations still
> > > > > need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
> > > > > endpoint descriptors with maxpacket=0")).
> > > > > 
> > > > > Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
> > > > > Cc: stable@vger.kernel.org      # 2.6.26
> > > > > Signed-off-by: Johan Hovold <johan@kernel.org>

> > Note however the copy-paste error in the commit message mentioning
> > probe(), which is indeed where this would typically be handled.
> > 
> > Do you want me to resend or can you change
> > 
> > 	s/probe()/uvc_video_start_transfer()/
> > 
> > in the commit message when applying if you think this is acceptable as
> > is?
> 
> I can fix this when applying.
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I noticed that this one hasn't showed up in linux-next yet. Do you still
have it in your queue or do you want me to resend?

Johan
