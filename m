Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C709B1993A6
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 12:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbgCaKmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 06:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729925AbgCaKmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 06:42:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35DC9208E0;
        Tue, 31 Mar 2020 10:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585651322;
        bh=IMaARxto1wU2KuadB9baG/GU1gTRr4yDXBIObte9rUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QVDUBY08T61oYJnGnL0TYd5PkxZhrsSrplWX1MhZo7JJEuh9dJxaOImZkAvEbAI5J
         hqGnj93Lfu+MKj1InKmcNS983cH/JEzFzymScBkzf5emnjN9TzSFzc9FPYu+7zIxDs
         YVtxYf1hxh5Rs16+hwNcZLrkddy47YtFvM+xcMD8=
Date:   Tue, 31 Mar 2020 12:02:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dirk Mueller <dmueller@suse.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 5.5 102/170] scripts/dtc: Remove redundant YYLOC global
 declaration
Message-ID: <20200331100238.GA1204199@kroah.com>
References: <20200331085423.990189598@linuxfoundation.org>
 <20200331085435.053942582@linuxfoundation.org>
 <20200331095323.GA32667@ubuntu-m2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331095323.GA32667@ubuntu-m2-xlarge-x86>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 02:53:23AM -0700, Nathan Chancellor wrote:
> On Tue, Mar 31, 2020 at 10:58:36AM +0200, Greg Kroah-Hartman wrote:
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
> > @@ -23,7 +23,6 @@ LINECOMMENT	"//".*\n
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
> Replying here simply because I am not subscribed to the stable-commits
> mailing list and there does not appear to be an easy way to reply to one
> of those emails through the existing archives because they are not as
> nice as lore.kernel.org.
> 
> This patch is fine for the current releases in review but 4.4, 4.9, and
> 4.14 need to have the patch applied to scripts/dtc/dtc-lexer.lex.c_shipped
> because prior to commit e039139be8c2 ("scripts/dtc: generate lexer and
> parser during build instead of shipping"), that was the file that was
> being built. Running the command below in the stable-queue repo works
> for me and I have tested all of the patches to make sure they still
> apply (albeit with some fuzz).
> 
> $ sed -i 's;scripts/dtc/dtc-lexer.l;scripts/dtc/dtc-lexer.lex.c_shipped;g' \
> queue-{4.4,4.9,4.14}/scripts-dtc-remove-redundant-yyloc-global-declaration.patch
> 
> If you would prefer a set of patches, let me know.

Should I just drop the patch from 4.4, 4.9, and 4.14 instead?

If not, yes, I can run the above script on the patches.

thanks,

greg k-h
