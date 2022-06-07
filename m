Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8334A541CFE
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383563AbiFGWHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383737AbiFGWGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD41D196A98;
        Tue,  7 Jun 2022 12:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A44F6192F;
        Tue,  7 Jun 2022 19:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C8BC385A2;
        Tue,  7 Jun 2022 19:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629452;
        bh=6oCEsGrH4yCyfhP7SrWq+do8nPz28zA/Cu2zTNcGrHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlnepKPparM/cb27mRvM5OusKxt3rX1VN4VsUk7GbMf1i1BvL/1fkesVQNrjmeUJW
         XL0UI5JPu6KebaC7JNCHnU+VMAfymQDfLCispKXWjtulBg5U2fQTRmOBQN/bWbvf0q
         9sx0otLS02dxA9iVhiMqJGzfv7nFsKaUn6kDAgFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 696/879] perf build: Fix btf__load_from_kernel_by_id() feature check
Date:   Tue,  7 Jun 2022 19:03:34 +0200
Message-Id: <20220607165023.049031152@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 73534617dfa3c4cd95fe5ffaeff5315e9ffc2de6 ]

The btf__load_from_kernel_by_id() only takes one arg, not two.

Committer notes:

I tested it just with an older libbpf, one where
btf__load_from_kernel_by_id() wasn't introduced yet.

A test with a newer dynamic libbpf would fail because the
btf__load_from_kernel_by_id() is there, but takes just one arg.

Fixes: 0ae065a5d265bc5a ("perf build: Fix check for btf__load_from_kernel_by_id() in libbpf")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: http://lore.kernel.org/linux-perf-users/YozLKby7ITEtchC9@krava
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../build/feature/test-libbpf-btf__load_from_kernel_by_id.c  | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/build/feature/test-libbpf-btf__load_from_kernel_by_id.c b/tools/build/feature/test-libbpf-btf__load_from_kernel_by_id.c
index f7c084428735..a17647f7d5a4 100644
--- a/tools/build/feature/test-libbpf-btf__load_from_kernel_by_id.c
+++ b/tools/build/feature/test-libbpf-btf__load_from_kernel_by_id.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <bpf/libbpf.h>
+#include <bpf/btf.h>
 
 int main(void)
 {
-	return btf__load_from_kernel_by_id(20151128, NULL);
+	btf__load_from_kernel_by_id(20151128);
+	return 0;
 }
-- 
2.35.1



