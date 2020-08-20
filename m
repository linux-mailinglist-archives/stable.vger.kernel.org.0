Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9183824BF7F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729063AbgHTNjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbgHTJ2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:28:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 732EC22D3E;
        Thu, 20 Aug 2020 09:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915692;
        bh=4PcJebeh/Ll0u6T2COoRTK6XyspIHlBi+EwMv6Zg/BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HScMFZLuucr8SU/DyhCfHwhReS++DCj6EXuunKXVyjuKMKburRKl1wzjwxRFfHEdE
         un6lwtvEDvt16r+1KMtSHaAhHB88I9WUgOukOhext0781D1aYHuTR8PrbHFVE557uf
         CK+Dqj1c0kygeNJlCKw4qBNaXi1Sjzktst/JC6P8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.8 102/232] perf probe: Fix wrong variable warning when the probe point is not found
Date:   Thu, 20 Aug 2020 11:19:13 +0200
Message-Id: <20200820091617.773551777@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 11fd3eb874e73ee8069bcfd54e3c16fa7ce56fe6 upstream.

Fix a wrong "variable not found" warning when the probe point is not
found in the debuginfo.

Since the debuginfo__find_probes() can return 0 even if it does not find
given probe point in the debuginfo, fill_empty_trace_arg() can be called
with tf.ntevs == 0 and it can emit a wrong warning.  To fix this, reject
ntevs == 0 in fill_empty_trace_arg().

E.g. without this patch;

  # perf probe -x /lib64/libc-2.30.so -a "memcpy arg1=%di"
  Failed to find the location of the '%di' variable at this address.
   Perhaps it has been optimized out.
   Use -V with the --range option to show '%di' location range.
  Added new events:
    probe_libc:memcpy    (on memcpy in /usr/lib64/libc-2.30.so with arg1=%di)
    probe_libc:memcpy    (on memcpy in /usr/lib64/libc-2.30.so with arg1=%di)

  You can now use it in all perf tools, such as:

  	perf record -e probe_libc:memcpy -aR sleep 1

With this;

  # perf probe -x /lib64/libc-2.30.so -a "memcpy arg1=%di"
  Added new events:
    probe_libc:memcpy    (on memcpy in /usr/lib64/libc-2.30.so with arg1=%di)
    probe_libc:memcpy    (on memcpy in /usr/lib64/libc-2.30.so with arg1=%di)

  You can now use it in all perf tools, such as:

  	perf record -e probe_libc:memcpy -aR sleep 1

Fixes: cb4027308570 ("perf probe: Trace a magic number if variable is not found")
Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Tested-by: Andi Kleen <ak@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/159438667364.62703.2200642186798763202.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/probe-finder.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1408,6 +1408,9 @@ static int fill_empty_trace_arg(struct p
 	char *type;
 	int i, j, ret;
 
+	if (!ntevs)
+		return -ENOENT;
+
 	for (i = 0; i < pev->nargs; i++) {
 		type = NULL;
 		for (j = 0; j < ntevs; j++) {


