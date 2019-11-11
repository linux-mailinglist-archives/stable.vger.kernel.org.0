Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34785F6E57
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 07:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfKKGBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 01:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfKKGBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 01:01:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D88320656;
        Mon, 11 Nov 2019 06:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573452094;
        bh=r2/46Oo7bzlP9QELn0pm6e6LdiAFm+dgs0+pcUxGDOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WlVHQzIJM20xcbXlcK1Ol8oaCuqcHpKxgfD4GWSGZ890mzTBiDyJocMWMK/aajIoH
         zFEHtHcOpa+qWbMSIWCY1uyqCuFSyrpbnu15vhkyvsKgfLDNJC3dtC1zA6XlkMTyNi
         wFW4EpAhLRmhgJW/gN20IziDGpQejHQXTUTHFvMI=
Date:   Mon, 11 Nov 2019 07:01:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andres Freund <andres@anarazel.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John Keeping <john@metanate.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.3 111/344] perf unwind: Fix libunwind when tid != pid
Message-ID: <20191111060129.GA3197363@kroah.com>
References: <20191003154540.062170222@linuxfoundation.org>
 <20191003154551.163214533@linuxfoundation.org>
 <20191110014621.n5yfednqfl7g3atr@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110014621.n5yfednqfl7g3atr@alap3.anarazel.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 09, 2019 at 05:46:21PM -0800, Andres Freund wrote:
> Hi,
> 
> On 2019-10-03 17:51:16 +0200, Greg Kroah-Hartman wrote:
> > From: John Keeping <john@metanate.com>
> >
> > [ Upstream commit e8ba2906f6b9054102ad035ac9cafad9d4168589 ]
> >
> > Commit e5adfc3e7e77 ("perf map: Synthesize maps only for thread group
> > leader") changed the recording side so that we no longer get mmap events
> > for threads other than the thread group leader (when synthesising these
> > events for threads which exist before perf is started).
> >
> > When a file recorded after this change is loaded, the lack of mmap
> > records mean that unwinding is not set up for any other threads.
> >
> > This can be seen in a simple record/report scenario:
> >
> > 	perf record --call-graph=dwarf -t $TID
> > 	perf report
> >
> > If $TID is a process ID then the report will show call graphs, but if
> > $TID is a secondary thread the output is as if --call-graph=none was
> > specified.
> >
> > Following the rationale in that commit, move the libunwind fields into
> > struct map_groups and update the libunwind functions to take this
> > instead of the struct thread.  This is only required for
> > unwind__finish_access which must now be called from map_groups__delete
> > and the others are changed for symmetry.
> >
> > Note that unwind__get_entries keeps the thread argument since it is
> > required for symbol lookup and the libdw unwind provider uses the thread
> > ID.
> >
> > Signed-off-by: John Keeping <john@metanate.com>
> > Reviewed-by: Jiri Olsa <jolsa@kernel.org>
> > Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Fixes: e5adfc3e7e77 ("perf map: Synthesize maps only for thread group leader")
> > Link: http://lkml.kernel.org/r/20190815100146.28842-2-john@metanate.com
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This unfortunately broke --call-graph dwarf on 5.3 (and presumably older
> branches), because while this commit has been included in stable, the
> prerequisite
> 
> commit ab6cd0e5276e24403751e0b3b8ed807738a8571f
> Author:     John Keeping <john@metanate.com>
> AuthorDate: 2019-08-15 11:01:44 +0100
> Commit:     Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: 2019-08-16 12:25:23 -0300
> 
>     perf map: Use zalloc for map_groups
> 
>     In the next commit we will add new fields to map_groups and we need
>     these to be null if no value is assigned.  The simplest way to achieve
>     this is to request zeroed memory from the allocator.
> 
>     Signed-off-by: John Keeping <john@metanate.com>
>     Reviewed-by: Jiri Olsa <jolsa@kernel.org>
>     Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>     Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>     Cc: Namhyung Kim <namhyung@kernel.org>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: john keeping <john@metanate.com>
>     Link: http://lkml.kernel.org/r/20190815100146.28842-1-john@metanate.com
>     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> has not.
> 
> 
> The crash I get is:
> 
> Thread 1 "perf" received signal SIGSEGV, Segmentation fault.
> 0x0000555555872238 in unwind__flush_access (mg=0x555555c53b50) at util/unwind-libunwind.c:76
> 76			mg->unwind_libunwind_ops->flush_access(mg);
> (gdb) bt
> #0  0x0000555555872238 in unwind__flush_access (mg=0x555555c53b50) at util/unwind-libunwind.c:76
> #1  0x0000555555800ac4 in ____thread__set_comm (exec=true, timestamp=325096707055731, str=0x7ffff7f96ed8 "sleep", thread=0x555555c53bc0) at util/thread.c:254
> #2  __thread__set_comm (thread=thread@entry=0x555555c53bc0, str=str@entry=0x7ffff7f96ed8 "sleep", timestamp=325096707055731, exec=exec@entry=true)
>     at util/thread.c:268
> #3  0x00005555557f132a in machine__process_comm_event (machine=0x555555c4bc68, event=0x7ffff7f96ec8, sample=0x7fffffff8f70) at util/machine.c:600
> #4  0x00005555557fa93b in perf_session__deliver_event (session=0x555555c4baf0, event=0x7ffff7f96ec8, tool=0x555555acb9a0 <record>, file_offset=73416)
>     at util/session.c:1473
> #5  0x00005555557feae8 in do_flush (show_progress=true, oe=0x555555c52610) at util/ordered-events.c:243
> #6  __ordered_events__flush (oe=oe@entry=0x555555c52610, how=how@entry=OE_FLUSH__FINAL, timestamp=timestamp@entry=0) at util/ordered-events.c:322
> #7  0x00005555557fef45 in __ordered_events__flush (timestamp=<optimized out>, how=<optimized out>, oe=<optimized out>) at util/ordered-events.c:338
> #8  ordered_events__flush (how=OE_FLUSH__FINAL, oe=0x555555c52610) at util/ordered-events.c:340
> #9  ordered_events__flush (oe=oe@entry=0x555555c52610, how=how@entry=OE_FLUSH__FINAL) at util/ordered-events.c:338
> #10 0x00005555557fd17c in __perf_session__process_events (session=0x555555c4baf0) at util/session.c:2152
> #11 perf_session__process_events (session=session@entry=0x555555c4baf0) at util/session.c:2181
> #12 0x0000555555729379 in process_buildids (rec=0x555555acb9a0 <record>) at builtin-record.c:829
> #13 record__finish_output (rec=0x555555acb9a0 <record>) at builtin-record.c:1037
> #14 0x000055555572c000 in __cmd_record (rec=0x555555acb9a0 <record>, argv=<optimized out>, argc=2) at builtin-record.c:1661
> #15 cmd_record (argc=2, argv=<optimized out>) at builtin-record.c:2450
> #16 0x000055555579cd9d in run_builtin (p=0x555555ad4958 <commands+216>, argc=5, argv=0x7fffffffdcc0) at perf.c:304
> #17 0x0000555555714baa in handle_internal_command (argv=0x7fffffffdcc0, argc=5) at perf.c:356
> #18 run_argv (argcp=<synthetic pointer>, argv=<synthetic pointer>) at perf.c:400
> #19 main (argc=5, argv=0x7fffffffdcc0) at perf.c:525
> 
> (gdb) p *mg
> $7 = {maps = {entries = {rb_node = 0x0}, names = {rb_node = 0x0}, lock = {lock = pthread_rwlock_t = {Status = Not acquired, Shared = No,
>         Prefers = Readers}}}, machine = 0x555555c4bc68, refcnt = {refs = {counter = 1}}, addr_space = 0x693f6967632e6775,
>   unwind_libunwind_ops = 0xa32313438313d64}
> 
> (gdb) p mg->unwind_libunwind_ops
> $8 = (struct unwind_libunwind_ops *) 0xa32313438313d64
> 
> (gdb) p *mg->unwind_libunwind_ops
> Cannot access memory at address 0xa32313438313d64
> 
> which makes sense, because map_groups__new() allocates the group with
> malloc, and map_groups__init() only initializes map_groups->{maps,machine,refcnt}
> 
> 
> A bit surprised that nobody complained about this so far...

Thanks, I've queued up the other patch for 5.3.y now.

greg k-h
