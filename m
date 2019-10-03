Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D62ECAF13
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 21:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731031AbfJCTUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 15:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfJCTUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 15:20:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA6532086A;
        Thu,  3 Oct 2019 19:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570130445;
        bh=8aXRktA/EAyWUQQqTzHLaSh0+nuPevY0JdjThyvfqMM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t7084uP1PrSCorsAG7W3vflO6GMkosUtk3DYYV/mrT8JIy4g/49Dn+JNCZmx6taxV
         jJLZt/9PajjXjdYByizJJ39M19xmvR9rUaJbxwN02IisyYOunmJKmmMae1vAmb9oOZ
         NbjxhoUe3JcKXtPUBn1wpuVJG+0a8xHHHFC+XKLw=
Date:   Thu, 3 Oct 2019 21:20:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Fran=E7ois?= Valenduc <francoisvalenduc@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/211] 4.19.77-stable review
Message-ID: <20191003192042.GA3587427@kroah.com>
References: <20191003154447.010950442@linuxfoundation.org>
 <ea824819-1047-e74b-2e71-814c3c2756e9@gmail.com>
 <20191003191016.GB3585751@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191003191016.GB3585751@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 09:10:16PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Oct 03, 2019 at 09:02:23PM +0200, François Valenduc wrote:
> > This does not compile. I get this error:
> > 
> >   CC      drivers/ras/debugfs.o
> > drivers/ras/debugfs.c:9:5: error: redefinition of 'ras_userspace_consumers'
> >  int ras_userspace_consumers(void)
> >      ^~~~~~~~~~~~~~~~~~~~~~~
> > In file included from drivers/ras/debugfs.c:2:
> > ./include/linux/ras.h:14:19: note: previous definition of
> > 'ras_userspace_consumers' was here
> >  static inline int ras_userspace_consumers(void) { return 0; }
> >                    ^~~~~~~~~~~~~~~~~~~~~~~
> > drivers/ras/debugfs.c:39:12: error: redefinition of 'ras_add_daemon_trace'
> >  int __init ras_add_daemon_trace(void)
> >             ^~~~~~~~~~~~~~~~~~~~
> > In file included from drivers/ras/debugfs.c:2:
> > ./include/linux/ras.h:16:19: note: previous definition of
> > 'ras_add_daemon_trace' was here
> >  static inline int ras_add_daemon_trace(void) { return 0; }
> >                    ^~~~~~~~~~~~~~~~~~~~
> > drivers/ras/debugfs.c:55:13: error: redefinition of 'ras_debugfs_init'
> >  void __init ras_debugfs_init(void)
> >              ^~~~~~~~~~~~~~~~
> > In file included from drivers/ras/debugfs.c:2:
> > ./include/linux/ras.h:15:20: note: previous definition of
> > 'ras_debugfs_init' was here
> >  static inline void ras_debugfs_init(void) { }
> >                     ^~~~~~~~~~~~~~~~
> > make[2]: *** [scripts/Makefile.build:304: drivers/ras/debugfs.o] Error 1
> > make[1]: *** [scripts/Makefile.build:544: drivers/ras] Error 2
> > make: *** [Makefile:1046: drivers] Error 2
> > zsh: exit 2     LANG="C" make
> > 
> > 
> > Does somebody have an idea about this ?
> 
> If you add b6ff24f7b510 ("RAS: Build debugfs.o only when enabled in
> Kconfig") to your tree, does that solve the issue?
> 
> This should not be a new thing right?

Yeah, the above should fix this for you.  But again, is this a new
thing with this -rc release, or can you duplicate this in 4.19.76?

thanks,

greg k-h
