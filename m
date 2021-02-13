Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE0031ACBA
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 16:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhBMPxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 10:53:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26755 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhBMPxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Feb 2021 10:53:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613231532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4yQoeB9+5T4l5A6cJhLBs5pW8o2Xp0pgWwvHBZnCN4Q=;
        b=GRtTohBO8+I/bRlOd6MjZMyLlAleuxcfml78b5wvP4iunA3iz3wV9bI8LXRzU7lX02/Iq4
        tWdi5vBuqGEDOW+fkEzhsLghiz9IL0sXaElf38SifyE32MyMY+gYTI1Sk7/UcmsW+pWQz3
        uVaB6UIkDeTIdKRqihemrIUXiXqDeBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-L75yiQJHMvqpF1X5XtNc0w-1; Sat, 13 Feb 2021 10:52:08 -0500
X-MC-Unique: L75yiQJHMvqpF1X5XtNc0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D665E192CC43;
        Sat, 13 Feb 2021 15:52:06 +0000 (UTC)
Received: from treble (ovpn-120-169.rdu2.redhat.com [10.10.120.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 81ADC1F0;
        Sat, 13 Feb 2021 15:52:05 +0000 (UTC)
Date:   Sat, 13 Feb 2021 09:52:03 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Xi Ruoyao <xry111@mengyan1223.wang>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip: objtool/urgent] objtool: Fix seg fault with Clang
 non-section symbols
Message-ID: <20210213155203.lehuegwc3h42nebs@treble>
References: <ba6b6c0f0dd5acbba66e403955a967d9fdd1726a.1607983452.git.jpoimboe@redhat.com>
 <160812658044.3364.4188208281079332844.tip-bot2@tip-bot2>
 <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
 <YCU3Vdoqd+EI+zpv@kroah.com>
 <CAKwvOd=GHdkvAU3u6ROSgtGqC_wrkXo8siL1nZHE-qsqSx0gsw@mail.gmail.com>
 <YCafKVSTX9MxDBMd@kroah.com>
 <20210212170750.y7xtitigfqzpchqd@treble>
 <20210212124547.1dcf067e@gandalf.local.home>
 <YCfdfkoeh8i0baCj@kroah.com>
 <20210213091304.2dd51e5f@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210213091304.2dd51e5f@oasis.local.home>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 13, 2021 at 09:13:04AM -0500, Steven Rostedt wrote:
> On Sat, 13 Feb 2021 15:09:02 +0100
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > Thanks for the patch, but no, still fails with:
> > 
> > Cannot find symbol for section 8: .text.unlikely.
> > kernel/kexec_file.o: failed
> > make[1]: *** [scripts/Makefile.build:277: kernel/kexec_file.o] Error 1
> > make[1]: *** Deleting file 'kernel/kexec_file.o'
> 
> It was just a guess.
> 
> I guess I'll need to find some time next week to set up a VM with
> binutils 2.36 (I just checked, and all my development machines have
> 2.35). Then I'll be able to try and debug it.

FWIW, I wasn't able to recreate.   I tried both binutils 2.36 and
2.36.1, with gcc 11 and a 'make allmodconfig' kernel.

-- 
Josh

