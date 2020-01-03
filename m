Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05AA012FA23
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 17:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgACQMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 11:12:09 -0500
Received: from gofer.mess.org ([88.97.38.141]:37751 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbgACQMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 11:12:09 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 2EA1411A001; Fri,  3 Jan 2020 16:12:07 +0000 (GMT)
Date:   Fri, 3 Jan 2020 16:12:07 +0000
From:   Sean Young <sean@mess.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 106/434] media: flexcop-usb: fix NULL-ptr deref in
 flexcop_usb_transfer_init()
Message-ID: <20200103161207.GA3082@gofer.mess.org>
References: <20191229172702.393141737@linuxfoundation.org>
 <20191229172708.658173957@linuxfoundation.org>
 <20200103150242.GC17614@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103150242.GC17614@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 04:02:42PM +0100, Johan Hovold wrote:
> On Sun, Dec 29, 2019 at 06:22:39PM +0100, Greg Kroah-Hartman wrote:
> > From: Yang Yingliang <yangyingliang@huawei.com>
> > 
> > [ Upstream commit 649cd16c438f51d4cd777e71ca1f47f6e0c5e65d ]
> > 
> > If usb_set_interface() failed, iface->cur_altsetting will
> > not be assigned and it will be used in flexcop_usb_transfer_init()
> > It may lead a NULL pointer dereference.
> > 
> > Check usb_set_interface() return value in flexcop_usb_init()
> > and return failed to avoid using this NULL pointer.
> > 
> > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > Signed-off-by: Sean Young <sean@mess.org>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This commit is bogus and should be dropped from all stable queues.
> 
> Contrary to what the commit message claims, iface->cur_altsetting will
> never be NULL so there's no risk for a NULL-pointer dereference here.

Yes, you are right, I can't find any path through which cur_altsetting
will be set to NULL. The commit message is wrong. I am sorry for letting
this slip through.

Thank you for pointing this out.

> Even though the change itself is benign, we shouldn't spread this
> confusion further.

usb_set_interface() can fail for a number of reasons, and we should not
continue if it fails. So, the commit message is misleading but the
change itself is still valid.

Not sure what the right procedure is now though.

Thanks

Sean

> > ---
> >  drivers/media/usb/b2c2/flexcop-usb.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
> > index 1a801dc286f8..d1331f828108 100644
> > --- a/drivers/media/usb/b2c2/flexcop-usb.c
> > +++ b/drivers/media/usb/b2c2/flexcop-usb.c
> > @@ -504,7 +504,13 @@ urb_error:
> >  static int flexcop_usb_init(struct flexcop_usb *fc_usb)
> >  {
> >  	/* use the alternate setting with the larges buffer */
> > -	usb_set_interface(fc_usb->udev,0,1);
> > +	int ret = usb_set_interface(fc_usb->udev, 0, 1);
> > +
> > +	if (ret) {
> > +		err("set interface failed.");
> > +		return ret;
> > +	}
> > +
> >  	switch (fc_usb->udev->speed) {
> >  	case USB_SPEED_LOW:
> >  		err("cannot handle USB speed because it is too slow.");
> 
> Johan
