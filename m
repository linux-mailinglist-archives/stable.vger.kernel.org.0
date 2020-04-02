Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2A619C9E5
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389588AbgDBTTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:19:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732937AbgDBTTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 15:19:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B853206F8;
        Thu,  2 Apr 2020 19:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585855178;
        bh=rOPwtbBOBFiF82ie/2HapkDPckrKOlDUJEddYS++Ta8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H3Oj2jlpNO4TS98adrAw7QHhPX04DMY/VN1yWEKyYjDVaIqhScq5W7tIWAzVP28nt
         nRJizaNBIZkrGk0hF3NbFboQrXQV1mdtv6bQwxjr6sWRppUbiIvoHo9+LtKLONXAQ5
         t035E1wU8NKcj3Wzj4OTNvogYtowLPQEJeUWXEr8=
Date:   Thu, 2 Apr 2020 21:19:36 +0200
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
Message-ID: <20200402191936.GA3243295@kroah.com>
References: <20200401161542.669484650@linuxfoundation.org>
 <20200401161555.630698707@linuxfoundation.org>
 <20200402185320.GA8077@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402185320.GA8077@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 08:53:21PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > commit 8096f229421f7b22433775e928d506f0342e5907 upstream.
> > 
> > For the bpf syscall, we are relying on the compiler to properly zero out
> > the bpf_attr union that we copy userspace data into. Unfortunately that
> > doesn't always work properly, padding and other oddities might not be
> > correctly zeroed, and in some tests odd things have been found when the
> > stack is pre-initialized to other values.
> > 
> > Fix this by explicitly memsetting the structure to 0 before using
> > it.
> 
> Is not that a gcc bug?

No.

> I mean, that's seriously unhelpful behaviour from security
> perspective.

I totally agree, and it is something we have been playing whack-a-mole
over for a number of years now.

Nothing new, but we do have a config option to zero out the stack all
the time if you are feeling paranoid and can take the performance hit.

> Is there any reason to believe this is not causing problems elsewhere?

It probably is, please feel free to audit and fix up the remaining
issues that you find.

thanks,

greg k-h
