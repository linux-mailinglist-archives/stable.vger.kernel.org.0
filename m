Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7AE6AC80
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 18:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387958AbfGPQId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 12:08:33 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46948 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388058AbfGPQIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 12:08:32 -0400
Received: by mail-io1-f67.google.com with SMTP id i10so40740275iol.13
        for <stable@vger.kernel.org>; Tue, 16 Jul 2019 09:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2Do517kmLX0/AbsjIptJHF+WgkfT9EAU1+uYSgocd18=;
        b=OD8jzeifgewgqWGZ67bSF6pUYQTISn1eNZ0jVIJg1dunQPNbgn2mPaWegO1fT2FnKX
         snZyKcZSA+onK1zQVhDVSD/oL61Xe+ICpvdedmTCdyMgs6PTGu1sSZ+qHref8oQi0Pm1
         Y7hO//QXUeoLwWUsQsflE+SArFAuxZisIjQVhDca2MzaxwMGqSXtQ5Uo6TSGlcaPJ23d
         QaSfkMO4aF7Lw557MU+ruINuhuA3yaL7p7ANEcD538R5JV4q5En/bn2IHwb5etm2xg0P
         cReUuCqZhiJu6wFPr3U0WVD/gP0Xd4HebFlzSJ9BCvAEkcbTMtsJZKwrAhHVVVFZ3B/a
         1TAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2Do517kmLX0/AbsjIptJHF+WgkfT9EAU1+uYSgocd18=;
        b=JOss0OkN2L3HanR1Ac2vE7KmRSs0GuVRHN9J0+F1FP3ErICGgB0OsPMtAmN2IMe7UC
         hrXApeSdje6RHCkYwX0QWXHi8C6eEzbxcm0CVxVP1wENFB4+4dYwgIFqnoVRd+q70TCn
         l8zXBXOGkXS2Bmw1ybPPXEv6XVMXFXHWOLBOYfARN+WQKDa4czN2pe5gZcw6UJZhiBuk
         UE9mDs+GUM2yiMULPTGvDdEAi4j7HTUz+k41v1bNOF2yvs2hoIzPPDmR9bL81EK4hv63
         w1Qx6LXi1Utj5LYY/tvwTOdfkRiAB2I+vQ2x7p11aw6FpIwv9ScZJfOl6EsN+F+M45Ha
         K5Rw==
X-Gm-Message-State: APjAAAX7cotKfGJ9CZmafySwM0uZD93S7Yas7LaUJJ1q/SapnOasykid
        2RA2fRdp8iPgB/AER3ddcSuozw==
X-Google-Smtp-Source: APXvYqy2UY1Az05aEyIlQ6vJPmmEBF7PV01YxKa+o/A6WTJqZUVLyX5dcKmJ1+hiLMQ3qaIZ5tNkPA==
X-Received: by 2002:a02:230a:: with SMTP id u10mr35398925jau.117.1563293311353;
        Tue, 16 Jul 2019 09:08:31 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id s3sm18401674iob.49.2019.07.16.09.08.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 09:08:30 -0700 (PDT)
Date:   Tue, 16 Jul 2019 10:08:28 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Ross Zwisler <zwisler@chromium.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>,
        Guenter Roeck <groeck@google.com>
Subject: Re: [v4.14.y PATCH 0/2] fix drm/udl use-after-free error
Message-ID: <20190716160828.GA13008@google.com>
References: <20190715193618.24578-1-zwisler@google.com>
 <20190716011308.GA1943@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716011308.GA1943@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 15, 2019 at 09:13:08PM -0400, Sasha Levin wrote:
> On Mon, Jul 15, 2019 at 01:36:16PM -0600, Ross Zwisler wrote:
> > This patch is the second in this series, and requires the first patch as
> > a dependency.  This series apples cleanly to v4.14.133.
> 
> Hm, we don't need ac3b35f11a06 here? Why not? I'd love to document that
> with the backport.

Nope, we don't need that patch in the v4.14 backport.

In v4.19.y we have two functions, drm_dev_put() and drm_dev_unref(), which are
aliases for one another (drm_dev_unref() just calls drm_dev_put()).
drm_dev_unref() is the older of the two, and was introduced back in v4.0.
drm_dev_put() was introduced in v4.15 with 

9a96f55034e41 drm: introduce drm_dev_{get/put} functions

and slowly callers were moved from the old name (_unref) to the new name
(_put).  The patch you mentioned, ac3b35f11a06, is one such patch where we are
replacing a drm_dev_unref() call with a drm_dev_put() call.  This doesn't have
a functional change, but was necessary so that the third patch in the v4.19.y
series I sent would apply cleanly.

For the v4.14.y series, though, the drm_dev_put() function hasn't yet been
defined and everyone is still using drm_dev_unref().  So, we don't need a
backport of ac3b35f11a06, and I also had a small backport change in the last
patch of the v4.14.y series where I had to change a drm_dev_put() call with a
drm_dev_unref() call.

Just for posterity, the drm_dev_unref() calls were eventually all changed to
drm_dev_put() in v5.0, and drm_dev_unref() was removed entirely.  That
happened with the following two patches:

808bad32ea423 drm: replace "drm_dev_unref" function with "drm_dev_put"
ba1d345401476 drm: remove deprecated "drm_dev_unref" function
