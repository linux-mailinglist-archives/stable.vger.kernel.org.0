Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCEE812FADA
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 17:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgACQxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 11:53:13 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42238 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgACQxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 11:53:12 -0500
Received: by mail-lf1-f67.google.com with SMTP id y19so32221886lfl.9;
        Fri, 03 Jan 2020 08:53:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5l8bRIwslteZjFrSKXmUOscElYLV/kyb4b/frJ+TeAQ=;
        b=oIWPuCMjpBpkaKO6zr2Ejm5o4mrruy9knPNogC8T40qc51b2wKUneNtOWzHXd5Ju6u
         8deC/yBFrnxG1KZLChQvIo1QbG9q6xPHislwgRzXoqVN1w5bxHgI5QM3zvvCaOIgEFbh
         jQh+g+5m4msyVgGJmQqbRsBMctL5ho1xnDFFZV3p0vPFoChG/wyz/6eqNeniD3TZfP5q
         yxD51WWpIXX2wgejjIl6+158BrF1SGhLkKVLQOMMtQvXzVtDfk9GJgZPiHDEV8mbpGEj
         zn4hJtxIJNq5d065z7wQ7w0WiGn9FyJ5EvvmLCiRRCRrUa6GYCcfsVvYw1j6zkt0tPh2
         u9FA==
X-Gm-Message-State: APjAAAVsVYxX7mX1D2r5v2+bo04GqwscaaZevhEoURVEdV4gxFhl+ohj
        yiKrb9HfNJwwo271u/R+8XsaAtcu
X-Google-Smtp-Source: APXvYqwECgYe7GGDZW6oaGj+nlFttEJR4gE9B56WNRbDI4QdFrOaQQZSLe5+f+4Xc4bJ1I1xiR7cpQ==
X-Received: by 2002:a19:4b87:: with SMTP id y129mr53516908lfa.32.1578070390717;
        Fri, 03 Jan 2020 08:53:10 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id s22sm24854956ljm.41.2020.01.03.08.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 08:53:10 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1inQCG-0000Qd-6q; Fri, 03 Jan 2020 17:53:12 +0100
Date:   Fri, 3 Jan 2020 17:53:12 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Sean Young <sean@mess.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 106/434] media: flexcop-usb: fix NULL-ptr deref in
 flexcop_usb_transfer_init()
Message-ID: <20200103165312.GD17614@localhost>
References: <20191229172702.393141737@linuxfoundation.org>
 <20191229172708.658173957@linuxfoundation.org>
 <20200103150242.GC17614@localhost>
 <20200103161207.GA3082@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103161207.GA3082@gofer.mess.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 04:12:07PM +0000, Sean Young wrote:
> On Fri, Jan 03, 2020 at 04:02:42PM +0100, Johan Hovold wrote:
> > On Sun, Dec 29, 2019 at 06:22:39PM +0100, Greg Kroah-Hartman wrote:
> > > From: Yang Yingliang <yangyingliang@huawei.com>
> > > 
> > > [ Upstream commit 649cd16c438f51d4cd777e71ca1f47f6e0c5e65d ]
> > > 
> > > If usb_set_interface() failed, iface->cur_altsetting will
> > > not be assigned and it will be used in flexcop_usb_transfer_init()
> > > It may lead a NULL pointer dereference.
> > > 
> > > Check usb_set_interface() return value in flexcop_usb_init()
> > > and return failed to avoid using this NULL pointer.
> > > 
> > > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > > Signed-off-by: Sean Young <sean@mess.org>
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > This commit is bogus and should be dropped from all stable queues.
> > 
> > Contrary to what the commit message claims, iface->cur_altsetting will
> > never be NULL so there's no risk for a NULL-pointer dereference here.
> 
> Yes, you are right, I can't find any path through which cur_altsetting
> will be set to NULL. The commit message is wrong. I am sorry for letting
> this slip through.
> 
> Thank you for pointing this out.
> 
> > Even though the change itself is benign, we shouldn't spread this
> > confusion further.
> 
> usb_set_interface() can fail for a number of reasons, and we should not
> continue if it fails. So, the commit message is misleading but the
> change itself is still valid.

Sure, the change itself is fine, but I wouldn't consider it stable
material even with a correct commit message as it is not a critical fix.

And the user would still see an error message in case changing
altsetting fails.

Johan
