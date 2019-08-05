Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55AA781D0F
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbfHENWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbfHENWC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:22:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC80F2067D;
        Mon,  5 Aug 2019 13:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011321;
        bh=L2n12sUqOg47COSrX65P7AFO8JpGrbfguF3fj3jB14s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nN2mv71RnZ3/th+NGTQaTdNWFL5mhUnbE+dET1ep3CWEE3RmT35jGEv9Q6cC6A5lu
         ZCDULQatm/aiqfKvvmKdBGgeDW1LXZoOCQdz67WDJIIMgPJrQPPkwxluzhM7JoD+R0
         YuFg8lNwHYz4deyMscyUfcRges/AjNJVE1ZTHh3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mamatha Inamdar <mamatha4@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 041/131] perf version: Fix segfault due to missing OPT_END()
Date:   Mon,  5 Aug 2019 15:02:08 +0200
Message-Id: <20190805124954.181133823@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 916c31fff946fae0e05862f9b2435fdb29fd5090 ]

'perf version' on powerpc segfaults when used with non-supported
option:
  # perf version -a
  Segmentation fault (core dumped)

Fix this.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Tested-by: Mamatha Inamdar <mamatha4@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20190611030109.20228-1-ravi.bangoria@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-version.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-version.c b/tools/perf/builtin-version.c
index f470144d1a704..bf114ca9ca870 100644
--- a/tools/perf/builtin-version.c
+++ b/tools/perf/builtin-version.c
@@ -19,6 +19,7 @@ static struct version version;
 static struct option version_options[] = {
 	OPT_BOOLEAN(0, "build-options", &version.build_options,
 		    "display the build options"),
+	OPT_END(),
 };
 
 static const char * const version_usage[] = {
-- 
2.20.1



