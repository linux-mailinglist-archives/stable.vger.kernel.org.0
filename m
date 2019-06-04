Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D06734387
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 11:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfFDJzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 05:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbfFDJzH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 05:55:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56BBE24B36;
        Tue,  4 Jun 2019 09:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559642106;
        bh=j6tNQKAb3k8wxyLpbWBR8zk77facM632E43SzMuSftY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AO7mBtZ5bHgJfJlW6M+hHlIKCtcfz7BinSiE0B/CrsrPMloie/CjR0uNu3SKDaBV9
         HdS85ELXr0tzo4WWq91dK2kBufPnWRup2g2AnJ3bjMp0EWeN91hymaoEOBbQnId/1y
         skEOn4IiJflmmn2gCt4Ok+ml4cF8h7wAdoh57vJw=
Date:   Tue, 4 Jun 2019 11:55:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 4.19 29/32] jump_label: move asm goto support test to
 Kconfig
Message-ID: <20190604095504.GA6186@kroah.com>
References: <20190603090308.472021390@linuxfoundation.org>
 <20190603090315.474902271@linuxfoundation.org>
 <20190604093032.GA2689@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604093032.GA2689@amd>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 11:30:32AM +0200, Pavel Machek wrote:
> On Mon 2019-06-03 11:08:23, Greg Kroah-Hartman wrote:
> > From: Masahiro Yamada <yamada.masahiro@socionext.com>
> > 
> > commit e9666d10a5677a494260d60d1fa0b73cc7646eb3 upstream.
> > 
> > Currently, CONFIG_JUMP_LABEL just means "I _want_ to use jump label".
> > 
> > The jump label is controlled by HAVE_JUMP_LABEL, which is defined
> > like this:
> > 
> >   #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
> >   # define HAVE_JUMP_LABEL
> >   #endif
> > 
> > We can improve this by testing 'asm goto' support in Kconfig, then
> > make JUMP_LABEL depend on CC_HAS_ASM_GOTO.
> > 
> > Ugly #ifdef HAVE_JUMP_LABEL will go away, and CONFIG_JUMP_LABEL will
> > match to the real kernel capability.
> > 
> > Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> > Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > [nc: Fix trivial conflicts in 4.19
> >      arch/xtensa/kernel/jump_label.c doesn't exist yet
> >      Ensured CC_HAVE_ASM_GOTO and HAVE_JUMP_LABEL were sufficiently
> >      eliminated]
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This does not matche stable-kernel rules. It is nice cleanup, but it
> does not really fix any bug (does it?), and resulting patch is too
> big.

Please see the original email on the stable mailing list for why this
patch was submitted and accepted.

thanks,

greg k-h
