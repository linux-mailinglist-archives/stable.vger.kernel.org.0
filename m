Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D22519CABA
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 22:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388843AbgDBUEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 16:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388781AbgDBUEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 16:04:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D95EC206E9;
        Thu,  2 Apr 2020 20:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585857881;
        bh=SLau+LKmZYm2Wl1sqETl68Y6B4wiD4ofzcVkxfGGCxg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kS2l3M9Z21CypL26NC8ZFD56/5M2Imd9mOvSze8VhnzIW42lVdcInG0Y6YOLt6o3O
         X1i7VfWrX0gvQdaL78DUzkqahMxXEfAhTTcrX5sYoL9VmRMtU2WJx120EnX0ZOKHhw
         B7a2CODcDREViM/pGwbiWjB3Xha/t+WlfXlC2Tao=
Date:   Thu, 2 Apr 2020 22:04:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH 4.19 105/116] bpf: Explicitly memset the bpf_attr
 structure
Message-ID: <20200402200437.GA3251457@kroah.com>
References: <20200401161542.669484650@linuxfoundation.org>
 <20200401161555.630698707@linuxfoundation.org>
 <20200402185320.GA8077@duo.ucw.cz>
 <20200402192053.GB3243295@kroah.com>
 <20200402195324.GB8077@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402195324.GB8077@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 09:53:24PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > Should we fix gcc, instead?
> > 
> > Also, this is allowed in the C standard, and both clang and gcc
> > sometimes emit code that does not clear padding in structures.  Changing
> > the compiler to not do this would be wonderful, but we still have to
> > live with this for the next 10 years as those older compilers age-out.
> 
> I agree C standard allows this. It allows to even worse stuff.
> 
> I was just surprised that gcc does that.. and that I did not know
> about this trap. I was probably telling people to do = {} for
> structure init...
> 
> Should we get "= {}" warning for checkpatch?

Only if the structure has padding, and it is data to be sent to
userspace, or to be intrepreted in a way from userspace.

Good luck trying to write a checkpatch rule for that.

greg k-h
