Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A6E2E78A0
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 13:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgL3Mpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 07:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgL3Mpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 07:45:35 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB09C061799;
        Wed, 30 Dec 2020 04:44:55 -0800 (PST)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A7FE62A3;
        Wed, 30 Dec 2020 13:44:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1609332292;
        bh=N+MD8mxlPXnOnzIDjroQAQZ5KolfEPGJfCr+iUEPOlA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uevXKJ2rNoCc5LwVn+NT8iESWfmswY4JXvrb8p+P0T+NKsZ4Fyvis9PlnYw8LHftc
         bK0xt+tnlWOjCVv/OD1x3AHFYtVcf68ck3I1NDorJd+xRKnJn8EmcPwrs/SMSh5hvH
         zG1VeUqxfQM4D/QHl6mJhiBKfhzSwNvb/NF+Ftsc=
Date:   Wed, 30 Dec 2020 14:44:41 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH 5.10 527/717] media: ipu3-cio2: Validate mbus format in
 setting subdev format
Message-ID: <X+x2OakYZ5GGCxuS@pendragon.ideasonboard.com>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125046.214023397@linuxfoundation.org>
 <20201230122508.GA12190@duo.ucw.cz>
 <CAHp75VdFT-SUUj2LiPTs1_RJ-n97OiyQ2pF0jVbHsARkDshfwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHp75VdFT-SUUj2LiPTs1_RJ-n97OiyQ2pF0jVbHsARkDshfwA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 02:32:46PM +0200, Andy Shevchenko wrote:
> On Wed, Dec 30, 2020 at 2:25 PM Pavel Machek wrote:
> 
> > > commit a86cf9b29e8b12811cf53c4970eefe0c1d290476 upstream.
> > >
> > > Validate media bus code, width and height when setting the subdev format.
> > >
> > > This effectively reworks how setting subdev format is implemented in the
> > > driver.
> >
> > Something is wrong here:
> >
> > > +     fmt->format.code = formats[0].mbus_code;
> > > +     for (i = 0; i < ARRAY_SIZE(formats); i++) {
> 
> Looks like 'i = 1' should be...
> 
> > > +             if (formats[i].mbus_code == fmt->format.code) {

More likely

			if (formats[i].mbus_code == mbus_code) {

I think.

Pavel, would you like to submit a patch ?

> > > +                     fmt->format.code = mbus_code;
> > > +                     break;
> > > +             }
> >
> > This does not make sense. Loop will always exit during the first
> > iteration, making the whole loop crazy/redundant.

-- 
Regards,

Laurent Pinchart
