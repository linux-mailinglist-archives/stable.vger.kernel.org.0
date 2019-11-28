Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D78210C48F
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 08:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfK1HxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 02:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbfK1HxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 02:53:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB0DB215E5;
        Thu, 28 Nov 2019 07:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574927595;
        bh=Mn2fLKoZ7GJZlk08IbBurAvzrC0C1uKp4r18FrhSTbE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NCh9h1lTVMMn+vQzN4RdQ+8hIGi0SEr4sAXzkz/c9AqERfRwFzj1Z4+wJ8QhQZp7Z
         3AfUstxQCTm/rSNBtcUXSlwhhifBKaSFbpst1hD677xCbfnQIDWJoq7DNYjAtruIDV
         eu3PDQIYBOzk71v7c6j3WWo3zLEJ4yzPLTMYCRQU=
Date:   Thu, 28 Nov 2019 08:53:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 216/220] PM / devfreq: Fix static checker warning in
 try_then_request_governor
Message-ID: <20191128075312.GA3362744@kroah.com>
References: <20191122100912.732983531@linuxfoundation.org>
 <20191122100929.173069944@linuxfoundation.org>
 <20191128034020.necma5gpnf2wgsm4@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191128034020.necma5gpnf2wgsm4@toshiba.co.jp>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 28, 2019 at 12:40:20PM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> On Fri, Nov 22, 2019 at 11:29:41AM +0100, Greg Kroah-Hartman wrote:
> > From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> > 
> > [ Upstream commit b53b0128052ffd687797d5f4deeb76327e7b5711 ]
> > 
> > The patch 23c7b54ca1cd: "PM / devfreq: Fix devfreq_add_device() when
> > drivers are built as modules." leads to the following static checker
> > warning:
> > 
> >     drivers/devfreq/devfreq.c:1043 governor_store()
> >     warn: 'governor' can also be NULL
> > 
> > The reason is that the try_then_request_governor() function returns both
> > error pointers and NULL. It should just return error pointers, so fix
> > this by returning a ERR_PTR to the error intead of returning NULL.
> > 
> > Fixes: 23c7b54ca1cd ("PM / devfreq: Fix devfreq_add_device() when drivers are built as modules.")
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> > Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
> > Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> The following commits are provided for this fix:
> 
> commit 7544fd7f384591038646d3cd9efb311ab4509e24
> Author: Ezequiel Garcia <ezequiel@collabora.com>
> Date:   Fri Jun 21 18:39:49 2019 -0300
> 
>     PM / devfreq: Fix kernel oops on governor module load
> 
>     A bit unexpectedly (but still documented), request_module may
>     return a positive value, in case of a modprobe error.
>     This is currently causing issues in the devfreq framework.
> 
>     When a request_module exits with a positive value, we currently
>     return that via ERR_PTR. However, because the value is positive,
>     it's not a ERR_VALUE proper, and is therefore treated as a
>     valid struct devfreq_governor pointer, leading to a kernel oops.
> 
>     Fix this by returning -EINVAL if request_module returns a positive
>     value.
> 
>     Fixes: b53b0128052ff ("PM / devfreq: Fix static checker warning in try_then_request_governor")
>     Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
>     Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
>     Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> 
> Please apply.

Good catch, now queued up.

greg k-h
