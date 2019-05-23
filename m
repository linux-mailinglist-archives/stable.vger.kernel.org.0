Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2D6275A6
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 07:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfEWFms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 01:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbfEWFms (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 01:42:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01DE821019;
        Thu, 23 May 2019 05:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558590167;
        bh=iRBENfq5cCIi6tnQrISWDMi8NREnthCfNU7aYUgd9D0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ylg0LMxpImduI8VrzdKMRI+HIgfdsMBjv5Cc/ynRSxNyOjTxlTxinBQ9jIVuWgg4C
         v5dB7o+iIIoGoyM8Sk4ncoQGfyApoY/tky8K7rjDCN/DIHvMrLhMobimieNcZQN8dj
         UnzLFiUKZdDko9yDYeJDy+LAAdhN5kKSD4eNEwWo=
Date:   Thu, 23 May 2019 07:42:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, kafai@fb.com,
        syzkaller@googlegroups.com, weiwan@google.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ipv6: prevent possible fib6 leaks" failed
 to apply to 4.14-stable tree
Message-ID: <20190523054244.GC16130@kroah.com>
References: <155854389617965@kroah.com>
 <84edd412-c07d-28be-1723-a4727ae2ea56@gmail.com>
 <20190522172945.GA25977@kroah.com>
 <6081e160-5d74-0ec7-59cc-56cdecbaad41@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6081e160-5d74-0ec7-59cc-56cdecbaad41@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 11:36:45AM -0600, David Ahern wrote:
> On 5/22/19 11:29 AM, Greg KH wrote:
> > Thanks, but someone backported the commit mentioned in the Fixes line:
> > 	Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
> > 
> > to 4.14.y.  If it's really not relevant there, not a big deal, now
> > dropped.
> 
> 
> Just checked and that commit is not in 4.14 line.
> 
> It is one of like 90 other patches that actually depend on other changes
> in 4.15, 4.16. I can not imagine some poor soul backporting all of that
> to 4.14.

Argh, my scripts caught that the string "93531c674315" was included in
the changelog for 4.14.72, but the context of that was:
	- fib6_info_release was introduced upstream in 93531c674315
	  ("net/ipv6: separate handling of FIB entries from dst based
	  routes"), but is not present in stable kernels; 4.14.y relies
	  on dst_release/ ip6_rt_put/dst_release_immediate.

So this was my mistake, thanks for pointing it out.

greg k-h
