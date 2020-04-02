Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F6719C832
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389796AbgDBRkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388677AbgDBRkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 13:40:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2019E2077D;
        Thu,  2 Apr 2020 17:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585849217;
        bh=zDhAbgFiBp5xgrOISRQg46E+lTmZmLpU/ycGZY6jzxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FYDqKJINHdC/NYXhdznGWU7wTiqkm0Zt3X+fEenD2pDhhwR1QGFXdvtylrcpJUXr6
         p9kS6iFq/Cg9YSv0vfNnc12fDk5kbZVFL2C0PCz4G9nfzhEvmViS56tNTTiWgLT2jf
         7d+VouGnELeJCDLGDx1P2duksAMWXYGoU43aim9M=
Date:   Thu, 2 Apr 2020 19:40:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dirk Mueller <dmueller@suse.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 4.9 061/102] scripts/dtc: Remove redundant YYLOC global
 declaration
Message-ID: <20200402174015.GA3221004@kroah.com>
References: <20200401161530.451355388@linuxfoundation.org>
 <20200401161543.380204082@linuxfoundation.org>
 <20200401212553.GA43588@ubuntu-m2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401212553.GA43588@ubuntu-m2-xlarge-x86>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 02:25:53PM -0700, Nathan Chancellor wrote:
> On Wed, Apr 01, 2020 at 06:18:04PM +0200, Greg Kroah-Hartman wrote:
> > From: Dirk Mueller <dmueller@suse.com>
> > 
> > commit e33a814e772cdc36436c8c188d8c42d019fda639 upstream.
> > 
> > gcc 10 will default to -fno-common, which causes this error at link
> > time:
> > 
> >   (.text+0x0): multiple definition of `yylloc'; dtc-lexer.lex.o (symbol from plugin):(.text+0x0): first defined here
> > 
> > This is because both dtc-lexer as well as dtc-parser define the same
> > global symbol yyloc. Before with -fcommon those were merged into one
> > defintion. The proper solution would be to to mark this as "extern",
> > however that leads to:
> > 
> >   dtc-lexer.l:26:16: error: redundant redeclaration of 'yylloc' [-Werror=redundant-decls]
> >    26 | extern YYLTYPE yylloc;
> >       |                ^~~~~~
> > In file included from dtc-lexer.l:24:
> > dtc-parser.tab.h:127:16: note: previous declaration of 'yylloc' was here
> >   127 | extern YYLTYPE yylloc;
> >       |                ^~~~~~
> > cc1: all warnings being treated as errors
> > 
> > which means the declaration is completely redundant and can just be
> > dropped.
> > 
> > Signed-off-by: Dirk Mueller <dmueller@suse.com>
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > [robh: cherry-pick from upstream]
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  scripts/dtc/dtc-lexer.l |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > --- a/scripts/dtc/dtc-lexer.l
> > +++ b/scripts/dtc/dtc-lexer.l
> > @@ -38,7 +38,6 @@ LINECOMMENT	"//".*\n
> >  #include "srcpos.h"
> >  #include "dtc-parser.tab.h"
> >  
> > -YYLTYPE yylloc;
> >  extern bool treesource_error;
> >  
> >  /* CAUTION: this will stop working if we ever use yyless() or yyunput() */
> > 
> > 
> 
> Hi Greg,
> 
> Please see my email on the 5.5 version of this patch:
> 
> https://lore.kernel.org/stable/20200331192515.GA39354@ubuntu-m2-xlarge-x86/
> 
> As it stands how, this version of the patch does nothing.

I have picked those up now, sorry for the delay.

greg k-h
