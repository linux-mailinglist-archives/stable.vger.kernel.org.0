Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4311C12BEBE
	for <lists+stable@lfdr.de>; Sat, 28 Dec 2019 20:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfL1TnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Dec 2019 14:43:04 -0500
Received: from mx2.yrkesakademin.fi ([85.134.45.195]:33459 "EHLO
        mx2.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfL1TnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Dec 2019 14:43:04 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Dec 2019 14:43:01 EST
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Thomas Backlund <tmb@mageia.org>
Subject: Broken stuff in current 5.4 stable queue
Message-ID: <b46b8ea9-ad07-264f-69aa-f9ee06148600@mageia.org>
Date:   Sat, 28 Dec 2019 21:27:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-WatchGuard-Spam-ID: str=0001.0A0C0212.5E07B045.006C,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.195
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Isn't autosel stuff being buildtested before it ends up in stable queue ?


I tried to build the current stuff and end up with:


**********
libbpf.c: In function 'bpf_program__collect_reloc':
libbpf.c:1795:5: error: implicit declaration of function 'pr_warn'; did 
you mean 'pr_warning'? [-Werror=implicit-function-declaration]
  1795 |     pr_warn("bad call relo offset: %lu\n", sym.st_value);
       |     ^~~~~~~
       |     pr_warning
libbpf.c:1795:5: error: nested extern declaration of 'pr_warn' 
[-Werror=nested-externs]


Caused by:
libbpf-fix-call-relocation-offset-calculation-bug.patch



**********
builtin-trace.c: In function 'trace__record':
builtin-trace.c:2580:17: warning: implicit declaration of function 
'asprintf__tp_filter_pids' [-Wimplicit-function-declaration]
  2580 |  char *filter = asprintf__tp_filter_pids(1, &pid);
       |                 ^~~~~~~~~~~~~~~~~~~~~~~~
builtin-trace.c:2580:17: warning: nested extern declaration of 
'asprintf__tp_filter_pids' [-Wnested-externs]
builtin-trace.c:2580:17: warning: initialization of 'char *' from 'int' 
makes pointer from integer without a cast [-Wint-conversion]


Caused by:
perf-trace-filter-own-pid-to-avoid-a-feedback-look-i.patch



**********
arch/x86/util/auxtrace.c: In function 'auxtrace_record__init_intel':
arch/x86/util/auxtrace.c:31:16: error: 'struct perf_pmu' has no member 
named 'auxtrace'
    31 |   intel_bts_pmu->auxtrace = true;
       |                ^~
mv: cannot stat 'arch/x86/util/.auxtrace.o.tmp': No such file or directory
make[6]: *** [/linux-5.4/tools/build/Makefile.build:97: 
arch/x86/util/auxtrace.o] Error 1
make[6]: *** Waiting for unfinished jobs....
arch/x86/util/intel-bts.c: In function 'intel_bts_recording_options':
arch/x86/util/intel-bts.c:116:12: error: 'struct record_opts' has no 
member named 'auxtrace_sample_mode'; did you mean 'auxtrace_snapshot_mode'?
   116 |  if (opts->auxtrace_sample_mode) {
       |            ^~~~~~~~~~~~~~~~~~~~
       |            auxtrace_snapshot_mode


Caused by:
perf-intel-bts-does-not-support-aux-area-sampling.patch



**********
util/record.c: In function 'perf_can_aux_sample':
util/record.c:152:4: error: 'struct perf_event_attr' has no member named 
'aux_sample_size'
   152 |   .aux_sample_size = 1,
       |    ^~~~~~~~~~~~~~~



Caused by:
perf-record-add-a-function-to-test-for-kernel-suppor.patch



**********
util/parse-events.c: In function 'tracepoint_error':
util/parse-events.c:508:2: warning: implicit declaration of function 
'parse_events__handle_error'; did you mean 'parse_events_print_error'? 
[-Wimplicit-function-declaration]
   508 |  parse_events__handle_error(e, 0, strdup(str), strdup(help));
       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~
       |  parse_events_print_error
util/parse-events.c:508:2: warning: nested extern declaration of 
'parse_events__handle_error' [-Wnested-externs]


Caused by:
perf-parse-fix-potential-memory-leak-when-handling-t.patch



**********
/usr/bin/ld: perf-in.o: in function `debuginfo__find_probe_point':
/linux-5.4/tools/perf/util/probe-finder.c:1616: undefined reference to `
die_entrypc'
/usr/bin/ld: /linux-5.4/tools/perf/util/probe-finder.c:1633: undefined 
reference to `die_entrypc'
/usr/bin/ld: perf-in.o: in function `probe_point_search_cb':
/linux-5.4/tools/perf/util/probe-finder.c:1012: undefined reference to 
`die_entrypc'
/usr/bin/ld: perf-in.o: in function `probe_point_inline_cb':
/linux-5.4/tools/perf/util/probe-finder.c:960: undefined reference to 
`die_entrypc'
/usr/bin/ld: perf-in.o: in function `__die_walk_funclines_cb':
/linux-5.4/tools/perf/util/dwarf-aux.c:683: undefined reference to 
`die_entrypc'
/usr/bin/ld: perf-in.o:/linux-5.4/tools/perf/util/dwarf-aux.c:683: more 
undefined references to `die_entrypc' follow


Caused by:
perf-probe-fix-to-probe-a-function-which-has-no-entr.patch
perf-probe-fix-to-show-inlined-function-callsite-wit.patch
perf-probe-fix-to-list-probe-event-with-correct-line.patch
perf-probe-fix-to-probe-an-inline-function-which-has.patch
perf-probe-fix-to-show-ranges-of-variables-in-functi.patch
-- 

Thomas


