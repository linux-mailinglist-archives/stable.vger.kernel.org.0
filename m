Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41781450F6
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbgAVJiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:38:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731590AbgAVJiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:38:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B674B2467F;
        Wed, 22 Jan 2020 09:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685892;
        bh=MP3X2BrlBok4cbtpD4ZKUkbaVbNUyQijtX2E5c4vpBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5h+eCN1qBaen5sJJE3/BCtIH/CKp3dp55rb49m/i+aQcSabvQuzgmXpyuPv/zhv2
         S9CgxbIeBpZnqBRC8fxwfV6YC/c2iXEigxTZ3lfmP6359wA+NBNJJCRnXnxS4zJ/nz
         1Ge7VNhjlx7X6law7J+T4Ah01hdymrbm6oWJS5RM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuya Fujita <fujita.yuya@fujitsu.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.14 24/65] perf hists: Fix variable names inconsistency in hists__for_each() macro
Date:   Wed, 22 Jan 2020 10:29:09 +0100
Message-Id: <20200122092754.370609927@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
References: <20200122092750.976732974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuya Fujita <fujita.yuya@fujitsu.com>

commit 55347ec340af401437680fd0e88df6739a967f9f upstream.

Variable names are inconsistent in hists__for_each macro().

Due to this inconsistency, the macro replaces its second argument with
"fmt" regardless of its original name.

So far it works because only "fmt" is passed to the second argument.
However, this behavior is not expected and should be fixed.

Fixes: f0786af536bb ("perf hists: Introduce hists__for_each_format macro")
Fixes: aa6f50af822a ("perf hists: Introduce hists__for_each_sort_list macro")
Signed-off-by: Yuya Fujita <fujita.yuya@fujitsu.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/OSAPR01MB1588E1C47AC22043175DE1B2E8520@OSAPR01MB1588.jpnprd01.prod.outlook.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/hist.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -317,10 +317,10 @@ static inline void perf_hpp__prepend_sor
 	list_for_each_entry_safe(format, tmp, &(_list)->sorts, sort_list)
 
 #define hists__for_each_format(hists, format) \
-	perf_hpp_list__for_each_format((hists)->hpp_list, fmt)
+	perf_hpp_list__for_each_format((hists)->hpp_list, format)
 
 #define hists__for_each_sort_list(hists, format) \
-	perf_hpp_list__for_each_sort_list((hists)->hpp_list, fmt)
+	perf_hpp_list__for_each_sort_list((hists)->hpp_list, format)
 
 extern struct perf_hpp_fmt perf_hpp__format[];
 


