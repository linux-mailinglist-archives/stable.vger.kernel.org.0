Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DCA3C3E12
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 18:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhGKQsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 12:48:13 -0400
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:61095 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhGKQsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 12:48:13 -0400
IronPort-SDR: zfzqZvBauRO7fZoSZqkHp75sZ8flIyaVDY+LYqSGOIIK9wxEWJ4ZtHg5ey6f4+CkHqNlVqpWWO
 y3FhaD7oDaYtPZFkRnfLnZwYHqbdUtrHdQ8NlJ0uQb1rYfZbkdMmBvzRyO2trnpQtvNqYN6s3d
 PzcnUalYfHqeC1YWDIAjHkT2LeRid7bqwlElpjSAiIDmkq/1HB62Jh4gjf5svMOTNgUBrnRO3c
 lLX5HcpDuYyXJOvpNv0wK7xQ57L/MMrXksnTGNQhspGgmFOmnoXX+zqQ3QSnTxpSRqXyAHA+ri
 EwU=
X-IronPort-AV: E=Sophos;i="5.84,231,1620720000"; 
   d="scan'208";a="63387415"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa3.mentor.iphmx.com with ESMTP; 11 Jul 2021 08:45:26 -0800
IronPort-SDR: DA7UUw46pOmUW53YgI1CRHoHoeJkmcy5JRxye7qDt7oyG8H+jD0JrT39cGgkk77/Gsc6PRuGZF
 HXIrMyJA4hmY1OpnF26Y2CH3OjCVRdEPOolKGGhtEZuN9lVQS6KFgARbFnRJdFSUN9x6FlG1Dt
 CKI8jo7Oc5iZUZJjRMU+z2+POLWdzMRp5n/I7qIheCyv7nQMsGsSEe/qwqdHjaMmrLILdEJ9fq
 84PNb7iRTPTI1h6GNDMtwKF23thJQ2WE2rVcs2HccISMXPI+qmvtQDI7eqXxGIRLlPnM9sEtWM
 uJA=
From:   Andrew Gabbasov <andrew_gabbasov@mentor.com>
To:     'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
CC:     Macpaul Lin <macpaul.lin@mediatek.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Felipe Balbi <balbi@kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eddie Hung <eddie.hung@mediatek.com>
References: <20210603171507.22514-1-andrew_gabbasov@mentor.com> <20210604110503.GA23002@vmlxhi-102.adit-jv.com> <CACCg+XO+D+2SWJq0C=_sWXj53L1fh-wra8dmCb3VQ4bYCZQryA@mail.gmail.com> <20210702184957.4479-1-andrew_gabbasov@mentor.com> <20210702184957.4479-2-andrew_gabbasov@mentor.com> <YOKvz2WzYuV0PaXD@kroah.com> <000001d77187$e9782dd0$bc688970$@mentor.com> <YOLiDSs/9+RzMKqE@kroah.com> <000001d7766a$a755ada0$f60108e0$@mentor.com> <20210711155130.16305-1-andrew_gabbasov@mentor.com> <YOsXQfWvIPXUydFv@kroah.com>
In-Reply-To: <YOsXQfWvIPXUydFv@kroah.com>
Subject: RE: [PATCH v4.14] usb: gadget: f_fs: Fix setting of device and driver data cross-references
Date:   Sun, 11 Jul 2021 19:44:41 +0300
Organization: Mentor Graphics Corporation
Message-ID: <000001d77674$0fd59b20$2f80d160$@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHXb3MiK5x8JbQzK0Wthg8LyVovu6sz6U+AgABMtp+ACcRkOv//85+AgAAZ4+A=
Content-Language: en-us
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: svr-ies-mbx-01.mgc.mentorg.com (139.181.222.1) To
 svr-ies-mbx-01.mgc.mentorg.com (139.181.222.1)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Sunday, July 11, 2021 7:07 PM
> To: Gabbasov, Andrew <Andrew_Gabbasov@mentor.com>
> Cc: Macpaul Lin <macpaul.lin@mediatek.com>; Eugeniu Rosca <erosca@de.adit-jv.com>; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; stable@vger.kernel.org; Felipe Balbi <balbi@kernel.org>; Eugeniu Rosca
> <roscaeugeniu@gmail.com>; Eddie Hung <eddie.hung@mediatek.com>
> Subject: Re: [PATCH v4.14] usb: gadget: f_fs: Fix setting of device and driver data cross-references
> 
> On Sun, Jul 11, 2021 at 10:51:30AM -0500, Andrew Gabbasov wrote:
> > commit ecfbd7b9054bddb12cea07fda41bb3a79a7b0149 upstream.
> >

[ skipped ]

> > Fixes: 4b187fceec3c ("usb: gadget: FunctionFS: add devices management code")
> > Fixes: 3262ad824307 ("usb: gadget: f_fs: Stop ffs_closed NULL pointer dereference")
> > Fixes: cdafb6d8b8da ("usb: gadget: f_fs: Fix use-after-free in ffs_free_inst")
> > Reported-by: Bhuvanesh Surachari <bhuvanesh_surachari@mentor.com>
> > Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > Reviewed-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>
> > Link: https://lore.kernel.org/r/20210603171507.22514-1-andrew_gabbasov@mentor.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > [agabbasov: Backported to earlier mount API, resolved context conflicts]
> > ---
> >  drivers/usb/gadget/function/f_fs.c | 67 ++++++++++++++----------------
> >  1 file changed, 32 insertions(+), 35 deletions(-)
> 
> I also need a 4.19 version of this commit, as you do not want to upgrade
> to a newer kernel and regress.  Can you also provide that?

If I correctly understand, this particular file has a very minor difference
between 4.14 and 4.19. So, this same patch for 4.14 can be just applied / cherry-picked
cleanly on top of latest stable 4.19.

Thanks!

Best regards,
Andrew

