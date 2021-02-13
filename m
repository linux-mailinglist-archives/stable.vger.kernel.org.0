Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE22331AD18
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 17:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhBMQ0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 11:26:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhBMQ0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 11:26:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A89FB64E26;
        Sat, 13 Feb 2021 16:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613233522;
        bh=qwhOzhrZcsiVBjW8fHg5QGb+PU58vaBatmX1+UiLRhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JwFgmndjX5avX9jhhFF0/CrGie6NBBXTQTlh3+bw2rtwNvGba2nf0w2jsaunhMVGE
         iKwozPu33yo26KUZxbzqC0oAg9G4SDJvy5WB3KCe2TZlJUGkgQeBqwyigzql3x10ZG
         VIHGob9mDbMRu/7Sdvol+FMNZrs1tqFlGQheVZ2M=
Date:   Sat, 13 Feb 2021 17:25:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <YCf9bnsmXqRGMn+j@kroah.com>
References: <160812658044.3364.4188208281079332844.tip-bot2@tip-bot2>
 <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
 <YCU3Vdoqd+EI+zpv@kroah.com>
 <CAKwvOd=GHdkvAU3u6ROSgtGqC_wrkXo8siL1nZHE-qsqSx0gsw@mail.gmail.com>
 <YCafKVSTX9MxDBMd@kroah.com>
 <20210212170750.y7xtitigfqzpchqd@treble>
 <20210212124547.1dcf067e@gandalf.local.home>
 <YCfdfkoeh8i0baCj@kroah.com>
 <20210213091304.2dd51e5f@oasis.local.home>
 <20210213155203.lehuegwc3h42nebs@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210213155203.lehuegwc3h42nebs@treble>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 13, 2021 at 09:52:03AM -0600, Josh Poimboeuf wrote:
> On Sat, Feb 13, 2021 at 09:13:04AM -0500, Steven Rostedt wrote:
> > On Sat, 13 Feb 2021 15:09:02 +0100
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > > Thanks for the patch, but no, still fails with:
> > > 
> > > Cannot find symbol for section 8: .text.unlikely.
> > > kernel/kexec_file.o: failed
> > > make[1]: *** [scripts/Makefile.build:277: kernel/kexec_file.o] Error 1
> > > make[1]: *** Deleting file 'kernel/kexec_file.o'
> > 
> > It was just a guess.
> > 
> > I guess I'll need to find some time next week to set up a VM with
> > binutils 2.36 (I just checked, and all my development machines have
> > 2.35). Then I'll be able to try and debug it.
> 
> FWIW, I wasn't able to recreate.   I tried both binutils 2.36 and
> 2.36.1, with gcc 11 and a 'make allmodconfig' kernel.

I'm using whatever the latest is in Arch, which is gcc 10.2 and binutils
2.36.  My config is here:
	https://github.com/gregkh/gregkh-linux/blob/master/stable/configs/4.4.y

thanks,

greg k-h
