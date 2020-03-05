Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB5F517A83C
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 15:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgCEOyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 09:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbgCEOyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 09:54:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E1FF208CD;
        Thu,  5 Mar 2020 14:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583420041;
        bh=3t25Yn1gvcl81+XR7DKIL9gthVsJPbGh2NF+lcogUkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M+Nf5Z5/7XFsDqdEzoEdxGlHlurv2x7xGjSYV6C1FqTpCst3BKrkEdEPEdBvLTmhq
         NLHI8404QG6ioVo9FnmcaXdmEWwp4X0+AgLKvI9nzwEgRH0m+G4mZEkTu7w2yLmYWH
         EpgmMy8V26rxASiFiRJTdY2ctfE7YCnMTr2wnZE0=
Date:   Thu, 5 Mar 2020 15:53:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 12/87] arm/ftrace: Fix BE text poking
Message-ID: <20200305145358.GC1950999@kroah.com>
References: <20200303174349.075101355@linuxfoundation.org>
 <20200303174350.172336594@linuxfoundation.org>
 <20200305134956.GD2367@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305134956.GD2367@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 05, 2020 at 02:49:57PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > [ Upstream commit be993e44badc448add6a18d6f12b20615692c4c3 ]
> > 
> > The __patch_text() function already applies __opcode_to_mem_*(), so
> > when __opcode_to_mem_*() is not the identity (BE*), it is applied
> > twice, wrecking the instruction.
> > 
> > Fixes: 42e51f187f86 ("arm/ftrace: Use __patch_text()")
> 
> I don't see 42e51f187f86 anywhere. Mainline contains
> 
> commit 5a735583b764750726621b0396d03e4782911b77
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Tue Oct 15 21:07:35 2019 +0200
> 
>     arm/ftrace: Use __patch_text()
> 
> But that one is not present in 4.19, so perhaps we should not need
> this?

Good catch, I'll go drop this from everywhere.

I think Sasha has now fixed up his scripts to handle things when the
Fixes: tag does not point to a valid one.

thanks,

greg k-h
