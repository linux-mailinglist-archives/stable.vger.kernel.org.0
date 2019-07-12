Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6524866DAC
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbfGLMc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729474AbfGLMc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:32:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C71821019;
        Fri, 12 Jul 2019 12:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934745;
        bh=FShXrtKdc4YHViZDililVx7/5jefip73CbYnbQAZJxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUR8qLXawgAl5dYx6TCWYi+Wg9gD6PbwVEAbloF7b4wchJ8UN5bV9gt9xY+wMUwUE
         nncnBm1LFruhuxq6SLgCCEsH+mZzxEYJGq9DCHPg1KPQfVQh04V2i3CGKdLr+J+yHb
         TQTmiA4u6FQfcyXtzftvBE2NdbfJ3CkUVbTZyab4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Carrillo Cisneros <davidca@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, kernel-team@fb.com
Subject: [PATCH 5.2 18/61] perf header: Assign proper ff->ph in perf_event__synthesize_features()
Date:   Fri, 12 Jul 2019 14:19:31 +0200
Message-Id: <20190712121621.620616765@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

commit c952b35f4b15dd1b83e952718dec3307256383ef upstream.

bpf/btf write_* functions need ff->ph->env.

With this missing, pipe-mode (perf record -o -)  would crash like:

Program terminated with signal SIGSEGV, Segmentation fault.

This patch assign proper ph value to ff.

Committer testing:

  (gdb) run record -o -
  Starting program: /root/bin/perf record -o -
  PERFILE2
  <SNIP start of perf.data headers>
  Thread 1 "perf" received signal SIGSEGV, Segmentation fault.
  __do_write_buf (size=4, buf=0x160, ff=0x7fffffff8f80) at util/header.c:126
  126		memcpy(ff->buf + ff->offset, buf, size);
  (gdb) bt
  #0  __do_write_buf (size=4, buf=0x160, ff=0x7fffffff8f80) at util/header.c:126
  #1  do_write (ff=ff@entry=0x7fffffff8f80, buf=buf@entry=0x160, size=4) at util/header.c:137
  #2  0x00000000004eddba in write_bpf_prog_info (ff=0x7fffffff8f80, evlist=<optimized out>) at util/header.c:912
  #3  0x00000000004f69d7 in perf_event__synthesize_features (tool=tool@entry=0x97cc00 <record>, session=session@entry=0x7fffe9c6d010,
      evlist=0x7fffe9cae010, process=process@entry=0x4435d0 <process_synthesized_event>) at util/header.c:3695
  #4  0x0000000000443c79 in record__synthesize (tail=tail@entry=false, rec=0x97cc00 <record>) at builtin-record.c:1214
  #5  0x0000000000444ec9 in __cmd_record (rec=0x97cc00 <record>, argv=<optimized out>, argc=0) at builtin-record.c:1435
  #6  cmd_record (argc=0, argv=<optimized out>) at builtin-record.c:2450
  #7  0x00000000004ae3e9 in run_builtin (p=p@entry=0x98e058 <commands+216>, argc=argc@entry=3, argv=0x7fffffffd670) at perf.c:304
  #8  0x000000000042eded in handle_internal_command (argv=<optimized out>, argc=<optimized out>) at perf.c:356
  #9  run_argv (argcp=<optimized out>, argv=<optimized out>) at perf.c:400
  #10 main (argc=3, argv=<optimized out>) at perf.c:522
  (gdb)

After the patch the SEGSEGV is gone.

Reported-by: David Carrillo Cisneros <davidca@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: kernel-team@fb.com
Cc: stable@vger.kernel.org # v5.1+
Fixes: 606f972b1361 ("perf bpf: Save bpf_prog_info information as headers to perf.data")
Link: http://lkml.kernel.org/r/20190620010453.4118689-1-songliubraving@fb.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/header.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3602,6 +3602,7 @@ int perf_event__synthesize_features(stru
 		return -ENOMEM;
 
 	ff.size = sz - sz_hdr;
+	ff.ph = &session->header;
 
 	for_each_set_bit(feat, header->adds_features, HEADER_FEAT_BITS) {
 		if (!feat_ops[feat].synthesize) {


