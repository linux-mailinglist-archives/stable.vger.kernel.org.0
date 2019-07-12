Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE8066DA7
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbfGLMcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfGLMcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:32:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FE2216C8;
        Fri, 12 Jul 2019 12:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934736;
        bh=lkindddp7am+EJxQW8maw9xn2dB1EDCqkcHxRx8pMvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdYZkVqjrbtzrQQXYYsBljGDeJZ0UbifAGCwNveVHKKjoWUKoxvwDbc5CX1J6leCt
         EBWC2XIEmkzteh6H4A2RVQpRXDit/iqb1jAKO9AFYJ/To0KwOoVDJPVN48r94NfBWd
         IJFXVPMOs4gwAurCr14zZU/kAKTXzsp9+PtgD5yY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.2 15/61] perf intel-pt: Fix itrace defaults for perf script intel-pt documentation
Date:   Fri, 12 Jul 2019 14:19:28 +0200
Message-Id: <20190712121621.455643067@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

commit a2d8a1585e35444789c1c8cf7e2e51fb15589880 upstream.

Fix intel-pt documentation to reflect the change of itrace defaults for
perf script.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 4eb068157121 ("perf script: Make itrace script default to all calls")
Link: http://lkml.kernel.org/r/20190520113728.14389-4-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/Documentation/intel-pt.txt |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/perf/Documentation/intel-pt.txt
+++ b/tools/perf/Documentation/intel-pt.txt
@@ -88,16 +88,16 @@ smaller.
 
 To represent software control flow, "branches" samples are produced.  By default
 a branch sample is synthesized for every single branch.  To get an idea what
-data is available you can use the 'perf script' tool with no parameters, which
-will list all the samples.
+data is available you can use the 'perf script' tool with all itrace sampling
+options, which will list all the samples.
 
 	perf record -e intel_pt//u ls
-	perf script
+	perf script --itrace=ibxwpe
 
 An interesting field that is not printed by default is 'flags' which can be
 displayed as follows:
 
-	perf script -Fcomm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr,symoff,flags
+	perf script --itrace=ibxwpe -F+flags
 
 The flags are "bcrosyiABEx" which stand for branch, call, return, conditional,
 system, asynchronous, interrupt, transaction abort, trace begin, trace end, and
@@ -713,7 +713,7 @@ Having no option is the same as
 
 which, in turn, is the same as
 
-	--itrace=ibxwpe
+	--itrace=cepwx
 
 The letters are:
 


