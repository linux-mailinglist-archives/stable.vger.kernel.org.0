Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A962617B3D5
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 02:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgCFBkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 20:40:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgCFBkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 20:40:01 -0500
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 321382073B;
        Fri,  6 Mar 2020 01:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583458801;
        bh=4uVbvZs7bGvhYOVrCxKIFITotprXAnPMtZLds6M/fi8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OmvPbAKrVK4fV9T8TnrYRzpZ32q3vszMJxtIB/+mCKR5pT0nwCC4mVZSizjdGMTOP
         boWX9YaIsxi+KXzeUVHbsntpQ/bPJWv+aekROhOyWA2HMz3WZ3593yvbZb0VZ7lMAS
         WtvllrvaHCNxOkkSiST4UpxO0NeWR7z+dSSHVqX4=
Date:   Fri, 6 Mar 2020 10:39:56 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [BUGFIX PATCH] tools: Let O= makes handle a relative path with
 -C option
Message-Id: <20200306103956.7376399c71428b7a527a4d38@kernel.org>
In-Reply-To: <5d572db0-c603-aef1-220f-b26f89ba947a@infradead.org>
References: <9e7beb31-b41f-9e95-c92b-1829e420af77@infradead.org>
        <158338818292.25448.7161196505598269976.stgit@devnote2>
        <5d572db0-c603-aef1-220f-b26f89ba947a@infradead.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 5 Mar 2020 10:50:43 -0800
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 3/4/20 10:03 PM, Masami Hiramatsu wrote:
> > When I compiled tools/bootconfig from top directory with
> > -C option, the O= option didn't work correctly if I passed
> > a relative path.
> > 
> >   $ make O=./builddir/ -C tools/bootconfig/
> >   make: Entering directory '/home/mhiramat/ksrc/linux/tools/bootconfig'
> >   ../scripts/Makefile.include:4: *** O=./builddir/ does not exist.  Stop.
> >   make: Leaving directory '/home/mhiramat/ksrc/linux/tools/bootconfig'
> > 
> > The O= directory existence check failed because the check
> > script ran in the build target directory instead of the
> > directory where I ran the make command.
> > 
> > To fix that, once change directory to $(PWD) and check O=
> > directory, since the PWD is set to where the make command
> > runs.
> > 
> > Fixes: c883122acc0d ("perf tools: Let O= makes handle relative paths")
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> 
> Hi Masami,
> 
> This patch doesn't fix anything AFAICT.
> Didn't help in my testing.
> 

Hmm, what happens on your case? Maybe PWD is not set?

Thank you,


> Thanks.
> 
> > ---
> >  tools/scripts/Makefile.include |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
> > index ded7a950dc40..6d2f3a1b2249 100644
> > --- a/tools/scripts/Makefile.include
> > +++ b/tools/scripts/Makefile.include
> > @@ -1,8 +1,8 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  ifneq ($(O),)
> >  ifeq ($(origin O), command line)
> > -	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
> > -	ABSOLUTE_O := $(shell cd $(O) ; pwd)
> > +	dummy := $(if $(shell cd $(PWD); test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
> > +	ABSOLUTE_O := $(shell cd $(PWD); cd $(O) ; pwd)
> >  	OUTPUT := $(ABSOLUTE_O)/$(if $(subdir),$(subdir)/)
> >  	COMMAND_O := O=$(ABSOLUTE_O)
> >  ifeq ($(objtree),)
> > 
> 
> 
> -- 
> ~Randy
> Reported-by: Randy Dunlap <rdunlap@infradead.org>


-- 
Masami Hiramatsu <mhiramat@kernel.org>
