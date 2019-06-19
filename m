Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5514B4BF63
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 19:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfFSRNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 13:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfFSRNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 13:13:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0491420657;
        Wed, 19 Jun 2019 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560964425;
        bh=NeiH9zJI5Pw3DoSpPZBpoNunqGgfxafaUVIxJKhW7DA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qd/ZMLp+Z5l0+G4LxkQXhHg/RMC5dyuOr0xqS9JND9OxrCyzSdOYPmTCNpr6v1JAu
         /FqxoR9XUugVt8vI1OGXNiXisT5ejiwdxWQyiH8fIK1euTZtGZ6CNbI1TvqqlGs+en
         bTnJg5McpGXJE1W6eIbKK39A/j4/zMzhAftvs9ws=
Date:   Wed, 19 Jun 2019 19:13:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Martin Weinelt <martin@linuxlounge.net>
Cc:     linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 45/83] staging: vc04_services: prevent integer
 overflow in create_pagelist()
Message-ID: <20190619171343.GD10107@kroah.com>
References: <20190609164127.843327870@linuxfoundation.org>
 <20190609164131.760341489@linuxfoundation.org>
 <c069dac7-7416-78af-80fd-e8836c76c82d@linuxlounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c069dac7-7416-78af-80fd-e8836c76c82d@linuxlounge.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 19, 2019 at 06:02:07PM +0200, Martin Weinelt wrote:
> Hi.
> 
> On 6/9/19 6:42 PM, Greg Kroah-Hartman wrote:
> > From: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > commit ca641bae6da977d638458e78cd1487b6160a2718 upstream.
> 
> This commit breaks the kernel build because the vchiq_pagelist_info
> struct is not defined in v4.9.182.
> 
> It was only added in v4.10, in commit
> 4807f2c0e684e907c501cb96049809d7a957dbc2.
> 
> 
> Best regards,
> 
> Martin Weinelt
> 
> 
> In file included from ./include/uapi/linux/posix_types.h:4:0,
>                  from ./include/uapi/linux/types.h:13,
>                  from ./include/linux/compiler.h:224,
>                  from ./include/linux/linkage.h:4,
>                  from ./include/linux/kernel.h:6,
>                  from
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c:34:
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c: In
> function 'create_pagelist':
> ./include/linux/stddef.h:7:14: warning: return makes integer from
> pointer without a cast [-Wint-conversion]
>  #define NULL ((void *)0)
>               ^
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c:385:10:
> note: in expansion of macro 'NULL'
>    return NULL;
>           ^~~~
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c:391:12:
> error: invalid application of 'sizeof' to incomplete type 'struct
> vchiq_pagelist_info'
>      sizeof(struct vchiq_pagelist_info)) /
>             ^~~~~~
> In file included from ./include/uapi/linux/posix_types.h:4:0,
>                  from ./include/uapi/linux/types.h:13,
>                  from ./include/linux/compiler.h:224,
>                  from ./include/linux/linkage.h:4,
>                  from ./include/linux/kernel.h:6,
>                  from
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c:34:
> ./include/linux/stddef.h:7:14: warning: return makes integer from
> pointer without a cast [-Wint-conversion]
>  #define NULL ((void *)0)
>               ^
> drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c:394:10:
> note: in expansion of macro 'NULL'
>    return NULL;
>           ^~~~

Really?  How come all of the built tests still succeed?

Ah, arm systems :(

Odd that we didn't catch this already, sorry about that.  And that was
my fault in the backport, which the build tests did catch.  Odd that it
didn't catch the failure after that...

Anyway, thanks, I'll go revert this.

greg k-h
