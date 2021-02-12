Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37ACE31A34E
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 18:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhBLRJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 12:09:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229796AbhBLRJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 12:09:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613149680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6YUDcDVX3NzZxjlcM+vySz3aTES26WxXpS2MVDAUT7o=;
        b=Q5UWXjeRUua2cihuTZeGc5O7Ag6tZ5Wgq3eoh7hj/vqRhJSf6kg/evbcsdTBTZA05wxWge
        /yOsTPN/9ZLuiUC325ua59DgG5P1+SKkDbATQIKS8BQXCgEV2Mmxb5QokIW5fEf9ddlmL9
        aB1t+oAuf7kRwFBYllL4824m/IBZt38=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-MJ-FrVg8M8S4jVTiWYCdQw-1; Fri, 12 Feb 2021 12:07:56 -0500
X-MC-Unique: MJ-FrVg8M8S4jVTiWYCdQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0F4419611A0;
        Fri, 12 Feb 2021 17:07:53 +0000 (UTC)
Received: from treble (ovpn-120-169.rdu2.redhat.com [10.10.120.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 127636E528;
        Fri, 12 Feb 2021 17:07:51 +0000 (UTC)
Date:   Fri, 12 Feb 2021 11:07:50 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Xi Ruoyao <xry111@mengyan1223.wang>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-tip-commits@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [tip: objtool/urgent] objtool: Fix seg fault with Clang
 non-section symbols
Message-ID: <20210212170750.y7xtitigfqzpchqd@treble>
References: <ba6b6c0f0dd5acbba66e403955a967d9fdd1726a.1607983452.git.jpoimboe@redhat.com>
 <160812658044.3364.4188208281079332844.tip-bot2@tip-bot2>
 <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
 <YCU3Vdoqd+EI+zpv@kroah.com>
 <CAKwvOd=GHdkvAU3u6ROSgtGqC_wrkXo8siL1nZHE-qsqSx0gsw@mail.gmail.com>
 <YCafKVSTX9MxDBMd@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YCafKVSTX9MxDBMd@kroah.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 04:30:49PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Feb 11, 2021 at 10:46:05AM -0800, Nick Desaulniers wrote:
> > On Thu, Feb 11, 2021 at 5:55 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Feb 11, 2021 at 09:32:03PM +0800, Xi Ruoyao wrote:
> > > > Hi all,
> > > >
> > > > The latest GNU assembler (binutils-2.36.1) is removing unused section symbols
> > > > like Clang [1].  So linux-5.10.15 can't be built with binutils-2.36.1 now.  It
> > > > has been reported as https://bugzilla.kernel.org/show_bug.cgi?id=211693.
> > 
> > Xi,
> > Happy Lunar New Year to you, too, and thanks for the report.  Did you
> > observe such segfaults for older branches of stable?
> > 
> > > 2.36 of binutils fails to build the 4.4.y tree right now as well, but as
> > > objtool isn't there, I don't know what to do about it :(
> > 
> > Greg,
> > There may be multiple issues in the latest binutils release for the
> > kernel; we should still avoid segfaults in host tools so I do
> > recommend considering this patch for inclusion at least into 5.10.y.
> > Arnd's report in https://github.com/ClangBuiltLinux/linux/issues/1207
> > mentions this was found via randconfig testing, so likely some set of
> > configs is needed to reproduce reliably.
> > 
> > Do you have more info about the failure you're observing? Trolling
> > lore, I only see:
> > https://lore.kernel.org/stable/YCLeJcQFsDIsrAEc@kroah.com/
> > (Maybe it was reported on a different list; I only searched stable ML).
> 
> I didn't report it anywhere.
> 
> Here's the output of doing a 'make allmodconfig' on the latest 4.4.257
> release failing with binutils 2.36
> 
> Cannot find symbol for section 8: .text.unlikely.
> kernel/kexec_file.o: failed
> make[1]: *** [scripts/Makefile.build:277: kernel/kexec_file.o] Error 1
> make[1]: *** Deleting file 'kernel/kexec_file.o'
> make[1]: *** Waiting for unfinished jobs....
> 
> 4.9.257 works fine, probably because we are using objtool?
> 
> Any ideas are appreciated.

[ Adding Steve Rostedt ]

This error message comes from recordmcount.  It probably can't handle
the missing STT_SECTION symbols which are getting stripped by the new
binutils.  (Objtool also had trouble with that.)

No idea why you only see this on 4.4 though.

-- 
Josh

