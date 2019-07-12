Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939E766E4C
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbfGLM30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728972AbfGLM30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:29:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A8362084B;
        Fri, 12 Jul 2019 12:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934565;
        bh=AZv/LQrXr3RW25gjxyCOzDhCvmEvZEzY/2T/JakO7UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8LqdU4ypbp4439+ZE8LeM+iifADzmouoMjTOvBJdft2vMbdrw8Sjoo8qWtnYPjNy
         4gwum3J7liR5w71CJ54smDy4PI9m6Gx8H45j+j71opJGdkSGypZi8LjwA19gPqRdV0
         x/0pjd6ysSQ3vxkP3U4X7yA3SFkPkdSI7wXZ6ZrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5.1 097/138] perf auxtrace: Fix itrace defaults for perf script
Date:   Fri, 12 Jul 2019 14:19:21 +0200
Message-Id: <20190712121632.487972616@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 355200e0f6a9ce14771625014aa469f5ecbd8977 upstream.

Commit 4eb068157121 ("perf script: Make itrace script default to all
calls") does not work for the case when '--itrace' only is used, because
default_no_sample is not being passed.

Example:

 Before:

  $ perf record -e intel_pt/cyc/u ls
  $ perf script --itrace > cmp1.txt
  $ perf script --itrace=cepwx > cmp2.txt
  $ diff -sq cmp1.txt cmp2.txt
  Files cmp1.txt and cmp2.txt differ

 After:

  $ perf script --itrace > cmp1.txt
  $ perf script --itrace=cepwx > cmp2.txt
  $ diff -sq cmp1.txt cmp2.txt
  Files cmp1.txt and cmp2.txt are identical

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 4eb068157121 ("perf script: Make itrace script default to all calls")
Link: http://lkml.kernel.org/r/20190520113728.14389-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/auxtrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -1010,7 +1010,8 @@ int itrace_parse_synth_opts(const struct
 	}
 
 	if (!str) {
-		itrace_synth_opts__set_default(synth_opts, false);
+		itrace_synth_opts__set_default(synth_opts,
+					       synth_opts->default_no_sample);
 		return 0;
 	}
 


