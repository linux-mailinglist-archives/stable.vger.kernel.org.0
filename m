Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9B9D234F
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388266AbfJJIlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388275AbfJJIlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:41:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D90821D80;
        Thu, 10 Oct 2019 08:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696870;
        bh=UFac5e5D1Otmrjuz4+CHUdFyycKp6DL19+o5YDGMP0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KG5fIMQS6IE0vyOQ3b1n5EufLrY/0/bmwENrTL6xaj5fH3KQJnSfOXHTzSlenxjg8
         BX5AloOGTqZDNNTlw3EGaojNFyT1KFV2e9k11QEbbos4IrVaA2d4DyUD08AhhUDGsz
         MXvmn4TAbp91Uet2vmqn3t9psv0sMxfJFn9pEuC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        David Carrillo-Cisneros <davidcc@google.com>,
        He Kuang <hekuang@huawei.com>, Jiri Olsa <jolsa@kernel.org>,
        Michal rarek <mmarek@suse.com>, Paul Turner <pjt@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.3 038/148] tools lib traceevent: Fix "robust" test of do_generate_dynamic_list_file
Date:   Thu, 10 Oct 2019 10:34:59 +0200
Message-Id: <20191010083613.461857258@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 82a2f88458d70704be843961e10b5cef9a6e95d3 upstream.

The tools/lib/traceevent/Makefile had a test added to it to detect a failure
of the "nm" when making the dynamic list file (whatever that is). The
problem is that the test sorts the values "U W w" and some versions of sort
will place "w" ahead of "W" (even though it has a higher ASCII value, and
break the test.

Add 'tr "w" "W"' to merge the two and not worry about the ordering.

Reported-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: David Carrillo-Cisneros <davidcc@google.com>
Cc: He Kuang <hekuang@huawei.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Michal rarek <mmarek@suse.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Wang Nan <wangnan0@huawei.com>
Cc: stable@vger.kernel.org
Fixes: 6467753d61399 ("tools lib traceevent: Robustify do_generate_dynamic_list_file")
Link: http://lkml.kernel.org/r/20190805130150.25acfeb1@gandalf.local.home
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/traceevent/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -266,8 +266,8 @@ endef
 
 define do_generate_dynamic_list_file
 	symbol_type=`$(NM) -u -D $1 | awk 'NF>1 {print $$1}' | \
-	xargs echo "U W w" | tr ' ' '\n' | sort -u | xargs echo`;\
-	if [ "$$symbol_type" = "U W w" ];then				\
+	xargs echo "U w W" | tr 'w ' 'W\n' | sort -u | xargs echo`;\
+	if [ "$$symbol_type" = "U W" ];then				\
 		(echo '{';						\
 		$(NM) -u -D $1 | awk 'NF>1 {print "\t"$$2";"}' | sort -u;\
 		echo '};';						\


