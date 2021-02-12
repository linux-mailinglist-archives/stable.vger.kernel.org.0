Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F230A31A3FB
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 18:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhBLRqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 12:46:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231474AbhBLRqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 12:46:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D31664E89;
        Fri, 12 Feb 2021 17:45:49 +0000 (UTC)
Date:   Fri, 12 Feb 2021 12:45:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
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
Message-ID: <20210212124547.1dcf067e@gandalf.local.home>
In-Reply-To: <20210212170750.y7xtitigfqzpchqd@treble>
References: <ba6b6c0f0dd5acbba66e403955a967d9fdd1726a.1607983452.git.jpoimboe@redhat.com>
        <160812658044.3364.4188208281079332844.tip-bot2@tip-bot2>
        <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
        <YCU3Vdoqd+EI+zpv@kroah.com>
        <CAKwvOd=GHdkvAU3u6ROSgtGqC_wrkXo8siL1nZHE-qsqSx0gsw@mail.gmail.com>
        <YCafKVSTX9MxDBMd@kroah.com>
        <20210212170750.y7xtitigfqzpchqd@treble>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Feb 2021 11:07:50 -0600
Josh Poimboeuf <jpoimboe@redhat.com> wrote:


> > Any ideas are appreciated.  
> 
> [ Adding Steve Rostedt ]
> 
> This error message comes from recordmcount.  It probably can't handle
> the missing STT_SECTION symbols which are getting stripped by the new
> binutils.  (Objtool also had trouble with that.)
> 
> No idea why you only see this on 4.4 though.
> 

Just taking a quick look, but would something like this work?

I created this against v4.4.257.

-- Steve

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 04151ede8043..698404f092d0 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -437,6 +437,8 @@ static unsigned find_secsym_ndx(unsigned const txtndx,
 			if (w2(ehdr->e_machine) == EM_ARM
 			    && ELF_ST_TYPE(symp->st_info) == STT_FUNC)
 				continue;
+			if (ELF_ST_TYPE(symp->st_info) == STT_SECTION)
+				continue;
 
 			*recvalp = _w(symp->st_value);
 			return symp - sym0;

