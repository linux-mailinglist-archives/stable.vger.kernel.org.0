Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E6A44C027
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 12:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhKJLgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 06:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhKJLgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 06:36:45 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28210C061766
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 03:33:57 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id z200so1866646wmc.1
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 03:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PiCJPKq4B/c2pDOax4h3Wik5ueo54GMsOopU4l+/WnQ=;
        b=UK+z9kKdScaxl38LAt27JPlLf7WPqx7Osf+Wjvt+GPTMPOlaRg3NVKSblOh1Qg7yzO
         aLLca1Jh+JbPZwPbhpLP3RiHiF0rbWMr+z5hB6uhlD673ZgH652+oxrRN2FFz+d7Bv/Q
         WeWjW94B8ySqdywvFYnNeAn+/uqqFkdGSJsjyS3O5ZkOE82Ht13HQJqQKdVElHu5UHTj
         OKzORDOYrFB9iXmOc08wZJM47NTEP1clIu1Z0/Uw1xYn/qsd2rh/Zlumw0Ng9FhKb9OO
         yFv4A3YSzDirncsfn1Rf3vWc5H/AkhwM9K+0BxUCp91vlVgeL5Ldmz9k7SKK86PO2exD
         A6Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PiCJPKq4B/c2pDOax4h3Wik5ueo54GMsOopU4l+/WnQ=;
        b=YMPzWGGEHmgSa+PccsKRONUdJDrhLZ/WpbkoN+EP+NNZRNOZEfmdndpsURnkQuiBVK
         tb2Kw++XJVDQvvKnppBy43iilpO6vdmh3WNWCO7LbFaEnBii7qxZt0P6OACjs+9kkfTO
         Sr80x/VLecjGjQZRw0rwp6hhPw/OAQ7YIyi3kWubniQzEIhHVJpd3u6A2QfFf1BMZazg
         kfZxIjwGWhwoo1bovhFSdgo3vAgEV/aZUu5db0lpnrUcZX99v1DvHqsKp/EAMxr58u5i
         Ph4f1cHVq3fUfNMx4iTElY0knhQaMqPxmLTn5K8KXN9qArC7TrkceOopijq0/OBUkQcx
         njrw==
X-Gm-Message-State: AOAM532XpOV33EJp1+0qIct7YhyTezfed8hRiLj5/FBEgG/whOSd0uOx
        KXRkUckuevH6k7i427SoYL3sXw==
X-Google-Smtp-Source: ABdhPJwrAG/u4ilxTYbP2ZfozDcPzBvMj+ufRTjxP0Et6ljauH8h5h4Z7tPzRYZ+lv72bj8DKjvzLA==
X-Received: by 2002:a1c:2b04:: with SMTP id r4mr16283166wmr.48.1636544035688;
        Wed, 10 Nov 2021 03:33:55 -0800 (PST)
Received: from google.com ([95.148.6.174])
        by smtp.gmail.com with ESMTPSA id r68sm279916wmr.45.2021.11.10.03.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:33:55 -0800 (PST)
Date:   Wed, 10 Nov 2021 11:33:48 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andreas Kemnade <andreas@kemnade.info>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Johan Hovold <johan@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.9 1/2] net: hso: register netdev later to avoid a race
 condition
Message-ID: <YYuuHPXYwGGYhrc2@google.com>
References: <20211109093959.173885-1-lee.jones@linaro.org>
 <YYuCE9EoMu+4zsiF@kroah.com>
 <YYuXq3wOdmWc+8lo@google.com>
 <YYuYyROE7FKrQgIF@google.com>
 <YYue00HWr1hW/8cE@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYue00HWr1hW/8cE@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Nov 2021, Greg KH wrote:

> On Wed, Nov 10, 2021 at 10:02:49AM +0000, Lee Jones wrote:
> > On Wed, 10 Nov 2021, Lee Jones wrote:
> > 
> > > On Wed, 10 Nov 2021, Greg KH wrote:
> > > 
> > > > On Tue, Nov 09, 2021 at 09:39:58AM +0000, Lee Jones wrote:
> > > > > From: Andreas Kemnade <andreas@kemnade.info>
> > > > > 
> > > > > [ Upstream commit 4c761daf8bb9a2cbda9facf53ea85d9061f4281e ]
> > > > 
> > > > You already sent this for inclusion:
> > > > 	https://lore.kernel.org/r/YYU1KqvnZLyPbFcb@google.com
> > > > 
> > > > Why send it again?
> > > 
> > > The real question is; why didn't I sent patch 2 at the same time!
> > 
> > Also, why didn't it go away when I rebased prior to sending this?
> 
> Because it is still in the queue and has not been in a released 4.4.y or
> 4.9.y kernel yet.

I guess that answers all of our questions then.

Both patches still reside on the topic branch and I don't have the
brain capacity nor project management skills to keep track of all the
patch status' without Git branches. :)

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
