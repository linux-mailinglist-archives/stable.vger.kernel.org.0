Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CD521FB4C
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731136AbgGNTAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729996AbgGNTAf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 15:00:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D362B22AAF;
        Tue, 14 Jul 2020 19:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753234;
        bh=/6OqGyB6j1Y5RgqtxHPkVz0xAsQg57VglVJYD2HVQ2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDoV+DPmxCUK4BJCDz2+oU55rBclPLMVyJx41/iXkdXEbWpqmVLgT4Ff4q7rRl/2n
         haFY/nUiQMix+LEX6ddtdCyDalDqK9Dg7+4egtFUbszeMR8NfwYEJsLGX5d2F7zYn3
         FmViwGaJe/AKtmvcapd8R8vC+sRxQ4KBfE4cLRzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.7 162/166] perf scripts python: export-to-postgresql.py: Fix struct.pack() int argument
Date:   Tue, 14 Jul 2020 20:45:27 +0200
Message-Id: <20200714184123.578904010@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 640432e6bed08e9d5d2ba26856ba3f55008b07e3 upstream.

Python 3.8 is requiring that arguments being packed as integers are also
integers.  Add int() accordingly.

 Before:

   $ perf record -e intel_pt//u uname
   $ perf script --itrace=bep -s ~/libexec/perf-core/scripts/python/export-to-postgresql.py perf_data_db branches calls
   2020-06-25 16:09:10.547256 Creating database...
   2020-06-25 16:09:10.733185 Writing to intermediate files...
   Traceback (most recent call last):
     File "/home/ahunter/libexec/perf-core/scripts/python/export-to-postgresql.py", line 1106, in synth_data
       cbr(id, raw_buf)
     File "/home/ahunter/libexec/perf-core/scripts/python/export-to-postgresql.py", line 1058, in cbr
       value = struct.pack("!hiqiiiiii", 4, 8, id, 4, cbr, 4, MHz, 4, percent)
   struct.error: required argument is not an integer
   Fatal Python error: problem in Python trace event handler
   Python runtime state: initialized

   Current thread 0x00007f35d3695780 (most recent call first):
   <no Python frame>
   Aborted (core dumped)

 After:

   $ dropdb perf_data_db
   $ rm -rf perf_data_db-perf-data
   $ perf script --itrace=bep -s ~/libexec/perf-core/scripts/python/export-to-postgresql.py perf_data_db branches calls
   2020-06-25 16:09:40.990267 Creating database...
   2020-06-25 16:09:41.207009 Writing to intermediate files...
   2020-06-25 16:09:41.270915 Copying to database...
   2020-06-25 16:09:41.382030 Removing intermediate files...
   2020-06-25 16:09:41.384630 Adding primary keys
   2020-06-25 16:09:41.541894 Adding foreign keys
   2020-06-25 16:09:41.677044 Dropping unused tables
   2020-06-25 16:09:41.703761 Done

Fixes: aba44287a224 ("perf scripts python: export-to-postgresql.py: Export Intel PT power and ptwrite events")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200629091955.17090-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/scripts/python/export-to-postgresql.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/scripts/python/export-to-postgresql.py
+++ b/tools/perf/scripts/python/export-to-postgresql.py
@@ -1055,7 +1055,7 @@ def cbr(id, raw_buf):
 	cbr = data[0]
 	MHz = (data[4] + 500) / 1000
 	percent = ((cbr * 1000 / data[2]) + 5) / 10
-	value = struct.pack("!hiqiiiiii", 4, 8, id, 4, cbr, 4, MHz, 4, percent)
+	value = struct.pack("!hiqiiiiii", 4, 8, id, 4, cbr, 4, int(MHz), 4, int(percent))
 	cbr_file.write(value)
 
 def mwait(id, raw_buf):


