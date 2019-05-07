Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C9B16DDD
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 01:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfEGXdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 19:33:25 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40741 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfEGXdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 19:33:25 -0400
Received: by mail-lf1-f67.google.com with SMTP id o16so13099386lfl.7;
        Tue, 07 May 2019 16:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=55v5Dsg1z0oHxHaQ+vXevXFSFPW/zo73YqWBOxq3l78=;
        b=jYWT+sb+suhqZhqZZ/qEXlVbnN4ssONo8jjnS0+LtXa3jmxZnMQ2vcY2F9qMjJhYOX
         UOzhG5gO0l4qa8RaJeNgkzBjsRfo3IehKdAF70XwArrUFm5LaP0pF78UbaIgNAlY292A
         ghD8a0U7HRhwIll9W6a2mlVpYeB9Zb9ih6wDowbYGNTdFipz56p6rg7GYsKeM9LJQbjp
         8EW9ywb/520t3Q4W8aX+GIwcncNmnBKdDkqtJEouEyYDS4Aa6Riuvwt1IHG/VTfVqr36
         cwW9oRtK2sv30xq0pmLYgqM63hBoFYZZTQWAIoiEiXphAR2rQC50z4sQZDv6rCKNMSt9
         UXKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=55v5Dsg1z0oHxHaQ+vXevXFSFPW/zo73YqWBOxq3l78=;
        b=aFG0s/iUa/Hp+CFolQnMmr5uLYuOifGMCXg/EzwhRQZYuT+a70hoMw5q1JnBWgF7cZ
         SOYHfrswnd+j5MjWnDCymRmIkE0Z0b6tqB7Otvh9tthwe6115pBD1ZT+Xr6gNbMbqvss
         d2mIHumiZj3phHdgWszrWh8OlSQ2Y0jGTmdH8PTdFGddDtjaBqNtFpaUBnOt+0CcEoix
         ogEA3hYxnTzZ5EzGOTKONQTB/vw0Ai7SZjJkAp+36o49Wk4wGLUfbkxaCXK9hRAaxxx0
         eHs1YpHR6Ox5hoBOSPIRRkzhu+RwDxhj3qjVY11/J4I8GPuA9oO/rKx3sadutEWXB/4A
         eXRg==
X-Gm-Message-State: APjAAAXLsbq3T1XD5L9biy8pAJmp2tGEkuewzzQfhF2B9C9mC3dadBSU
        bJtA+Cc6p+gVF8eKuLYRv9mPjPC97cYccw==
X-Google-Smtp-Source: APXvYqwsz00DbKdUkTLM7MFYjEwnLbM1Szy4NSt3GBthdFAfGYU8io1AUpnllTniAH6mcvaL8VD9Bg==
X-Received: by 2002:ac2:4186:: with SMTP id z6mr5674055lfh.50.1557272003068;
        Tue, 07 May 2019 16:33:23 -0700 (PDT)
Received: from z50.localnet (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id d80sm4433139lfd.90.2019.05.07.16.33.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 16:33:22 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: Re: [PATCH 03/14] media: ov6650: Fix unverified arguments used in .set_fmt()
Date:   Wed, 08 May 2019 01:33:19 +0200
Message-ID: <2020766.LXvJ9naVtX@z50>
In-Reply-To: <20190430135809.5mgf4govbqj3cxph@valkosipuli.retiisi.org.uk>
References: <20190408214242.9603-1-jmkrzyszt@gmail.com> <20190408214242.9603-4-jmkrzyszt@gmail.com> <20190430135809.5mgf4govbqj3cxph@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sakari,

Sorry for late answer, I've just found your message in Gmail spam folder.

On Tuesday, April 30, 2019 3:58:09 PM CEST Sakari Ailus wrote:
> Hi Janusz,
> 
> On Mon, Apr 08, 2019 at 11:42:31PM +0200, Janusz Krzysztofik wrote:
> > Commit 717fd5b4907ad ("[media] v4l2: replace try_mbus_fmt by set_fmt")
> > converted a former ov6650_try_fmt() video operation callback to an
> > ov6650_set_fmt() pad operation callback.  However, the function does not
> > verify correctness of user provided format->which flag and pad config
> > pointer arguments.  Fix it.
> > 
> > Fixes: 717fd5b4907ad ("[media] v4l2: replace try_mbus_fmt by set_fmt")
> > Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/media/i2c/ov6650.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
> > index 007f0ca24913..3062c9a6c57b 100644
> > --- a/drivers/media/i2c/ov6650.c
> > +++ b/drivers/media/i2c/ov6650.c
> > @@ -679,6 +679,17 @@ static int ov6650_set_fmt(struct v4l2_subdev *sd,
> >  	if (format->pad)
> >  		return -EINVAL;
> >  
> > +	switch (format->which) {
> > +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> > +		break;
> > +	case V4L2_SUBDEV_FORMAT_TRY:
> > +		if (cfg)
> > +			break;
> > +		/* fall through */
> > +	default:
> > +		return -EINVAL;
> > +	}
> 
> For this to return an error, there would need to be a problem on the
> caller's side. In other words, this isn't supposed to happen.

How about raising a bug if that happens nevertheless?

@@ -677,10 +677,20 @@ static int ov6650_set_fmt(struct v4l2_subdev *sd,
 	struct ov6650 *priv = to_ov6650(client);
 
 	if (format->pad)
 		return -EINVAL;
 
+	switch (format->which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		BUG_ON(!cfg);
+		/* fall through */
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		break;
+	default:
+		BUG();
+	}
+
 	if (is_unscaled_ok(mf->width, mf->height, &priv->rect))
 		v4l_bound_align_image(&mf->width, 2, W_CIF, 1,
 				&mf->height, 2, H_CIF, 1, 0);
 
 	mf->field = V4L2_FIELD_NONE;


Thanks,
Janusz

> 
> Instead of adding such checks to all drivers, I think they instead should
> be added to the caller's side. The checks already exist for uAPI, but not
> for other drivers.
> 
> The same applies to patches until 7th (including).
> 
> > +
> >  	if (is_unscaled_ok(mf->width, mf->height, &priv->rect))
> >  		v4l_bound_align_image(&mf->width, 2, W_CIF, 1,
> >  				&mf->height, 2, H_CIF, 1, 0);
> 
> 




