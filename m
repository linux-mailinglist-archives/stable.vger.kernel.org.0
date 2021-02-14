Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8530531B100
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 16:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhBNPx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 10:53:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229759AbhBNPx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 10:53:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613317920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b0So7W4a4U2tcf26Y/zPdxj6J7yWSOARMMAY/QxHwq8=;
        b=brfPwERZ9r+31tGx7PUJtE/UTBkeCF8Sc9R4yyDmsVct84e9XC5aM9XuwP4h+inkiGDzwn
        SA4vqNxN7I6G8dUyC1nna+lIpbsIENtOgNeUt4DHjJlxTRJXv6rV5VR3TRubmGK5yzlZmg
        bxLYZ0I8gMJ7qi18bcBx8gCw1HV7Vt0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-svSsil19MpCJuxoQ9NQ19Q-1; Sun, 14 Feb 2021 10:51:53 -0500
X-MC-Unique: svSsil19MpCJuxoQ9NQ19Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECA46192AB79;
        Sun, 14 Feb 2021 15:51:51 +0000 (UTC)
Received: from treble (ovpn-120-169.rdu2.redhat.com [10.10.120.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BA9B10021AA;
        Sun, 14 Feb 2021 15:51:49 +0000 (UTC)
Date:   Sun, 14 Feb 2021 09:51:47 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Message-ID: <20210214155147.3owdimqv2lyhu6by@treble>
References: <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
 <YCU3Vdoqd+EI+zpv@kroah.com>
 <CAKwvOd=GHdkvAU3u6ROSgtGqC_wrkXo8siL1nZHE-qsqSx0gsw@mail.gmail.com>
 <YCafKVSTX9MxDBMd@kroah.com>
 <20210212170750.y7xtitigfqzpchqd@treble>
 <20210212124547.1dcf067e@gandalf.local.home>
 <YCfdfkoeh8i0baCj@kroah.com>
 <20210213091304.2dd51e5f@oasis.local.home>
 <20210213155203.lehuegwc3h42nebs@treble>
 <YCf9bnsmXqRGMn+j@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YCf9bnsmXqRGMn+j@kroah.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 13, 2021 at 05:25:18PM +0100, Greg Kroah-Hartman wrote:
> On Sat, Feb 13, 2021 at 09:52:03AM -0600, Josh Poimboeuf wrote:
> > On Sat, Feb 13, 2021 at 09:13:04AM -0500, Steven Rostedt wrote:
> > > On Sat, 13 Feb 2021 15:09:02 +0100
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > 
> > > > Thanks for the patch, but no, still fails with:
> > > > 
> > > > Cannot find symbol for section 8: .text.unlikely.
> > > > kernel/kexec_file.o: failed
> > > > make[1]: *** [scripts/Makefile.build:277: kernel/kexec_file.o] Error 1
> > > > make[1]: *** Deleting file 'kernel/kexec_file.o'
> > > 
> > > It was just a guess.
> > > 
> > > I guess I'll need to find some time next week to set up a VM with
> > > binutils 2.36 (I just checked, and all my development machines have
> > > 2.35). Then I'll be able to try and debug it.
> > 
> > FWIW, I wasn't able to recreate.   I tried both binutils 2.36 and
> > 2.36.1, with gcc 11 and a 'make allmodconfig' kernel.
> 
> I'm using whatever the latest is in Arch, which is gcc 10.2 and binutils
> 2.36.  My config is here:
> 	https://github.com/gregkh/gregkh-linux/blob/master/stable/configs/4.4.y

Ok, I was able to recreate with that config.

GCC places two weak functions (arch_kexec_apply_relocations_add() and
arch_kexec_apply_relocations()) in .text.unlikely (probably because
printk() is __cold), and then the assembler doesn't generate the
'.text.unlikely' symbol because no other code references it.

Steve, looks like recordmcount avoids referencing weak symbols directly
by their function symbol.  Maybe it can just skip weak symbols which
don't have a section symbol, since this seems like a rare scenario.

Here's a total hack fix.  Just remove the functions, awkwardly avoiding
the problem.

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 6030efd4a188..456e3427c5e5 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -115,24 +115,6 @@ int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 	return -EKEYREJECTED;
 }
 
-/* Apply relocations of type RELA */
-int __weak
-arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-				 unsigned int relsec)
-{
-	pr_err("RELA relocation unsupported.\n");
-	return -ENOEXEC;
-}
-
-/* Apply relocations of type REL */
-int __weak
-arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-			     unsigned int relsec)
-{
-	pr_err("REL relocation unsupported.\n");
-	return -ENOEXEC;
-}
-
 /*
  * Free up memory used by kernel, initrd, and command line. This is temporary
  * memory allocation which is not needed any more after these buffers have

