Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365F14FD5BE
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355706AbiDLH3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352956AbiDLHOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:14:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAB232076;
        Mon, 11 Apr 2022 23:55:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AE0B61531;
        Tue, 12 Apr 2022 06:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EA0C385A6;
        Tue, 12 Apr 2022 06:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746529;
        bh=ZlLDchbIbSnAE1sVs9zu688bMteVPT8JnbgzYlKLtSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NscTc7RHtYx4WRpa50dKLjz/NT0UIfM+shrUCYUi5Q8yrRGs2YCZvuiNp7n8VUIfl
         PKkdWyL9cyxIFhKZnDZZ9vAhQYlT6LVUP1rsWRJuZlP0AlgIIiJRh6NoH9auh/RIQ9
         RQCkXonx2w0WrBQeyDQ1TOc0oSXf55iTJqv3nCZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Delyan Kratunov <delyank@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 039/285] libbpf: Fix build issue with llvm-readelf
Date:   Tue, 12 Apr 2022 08:28:16 +0200
Message-Id: <20220412062944.804118711@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 0908a66ad1124c1634c33847ac662106f7f2c198 ]

There are cases where clang compiler is packaged in a way
readelf is a symbolic link to llvm-readelf. In such cases,
llvm-readelf will be used instead of default binutils readelf,
and the following error will appear during libbpf build:

#  Warning: Num of global symbols in
#   /home/yhs/work/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/sharedobjs/libbpf-in.o (367)
#   does NOT match with num of versioned symbols in
#   /home/yhs/work/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/libbpf.so libbpf.map (383).
#   Please make sure all LIBBPF_API symbols are versioned in libbpf.map.
#  --- /home/yhs/work/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/libbpf_global_syms.tmp ...
#  +++ /home/yhs/work/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/libbpf_versioned_syms.tmp ...
#  @@ -324,6 +324,22 @@
#   btf__str_by_offset
#   btf__type_by_id
#   btf__type_cnt
#  +LIBBPF_0.0.1
#  +LIBBPF_0.0.2
#  +LIBBPF_0.0.3
#  +LIBBPF_0.0.4
#  +LIBBPF_0.0.5
#  +LIBBPF_0.0.6
#  +LIBBPF_0.0.7
#  +LIBBPF_0.0.8
#  +LIBBPF_0.0.9
#  +LIBBPF_0.1.0
#  +LIBBPF_0.2.0
#  +LIBBPF_0.3.0
#  +LIBBPF_0.4.0
#  +LIBBPF_0.5.0
#  +LIBBPF_0.6.0
#  +LIBBPF_0.7.0
#   libbpf_attach_type_by_name
#   libbpf_find_kernel_btf
#   libbpf_find_vmlinux_btf_id
#  make[2]: *** [Makefile:184: check_abi] Error 1
#  make[1]: *** [Makefile:140: all] Error 2

The above failure is due to different printouts for some ABS
versioned symbols. For example, with the same libbpf.so,
  $ /bin/readelf --dyn-syms --wide tools/lib/bpf/libbpf.so | grep "LIBBPF" | grep ABS
     134: 0000000000000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.5.0
     202: 0000000000000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.6.0
     ...
  $ /opt/llvm/bin/readelf --dyn-syms --wide tools/lib/bpf/libbpf.so | grep "LIBBPF" | grep ABS
     134: 0000000000000000     0 OBJECT  GLOBAL DEFAULT   ABS LIBBPF_0.5.0@@LIBBPF_0.5.0
     202: 0000000000000000     0 OBJECT  GLOBAL DEFAULT   ABS LIBBPF_0.6.0@@LIBBPF_0.6.0
     ...
The binutils readelf doesn't print out the symbol LIBBPF_* version and llvm-readelf does.
Such a difference caused libbpf build failure with llvm-readelf.

The proposed fix filters out all ABS symbols as they are not part of the comparison.
This works for both binutils readelf and llvm-readelf.

Reported-by: Delyan Kratunov <delyank@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220204214355.502108-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -129,7 +129,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --
 			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
 			      sed 's/\[.*\]//' | \
-			      awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
+			      awk '/GLOBAL/ && /DEFAULT/ && !/UND|ABS/ {print $$NF}' | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
 
 CMD_TARGETS = $(LIB_TARGET) $(PC_FILE)
@@ -192,7 +192,7 @@ check_abi: $(OUTPUT)libbpf.so $(VERSION_
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf --dyn-syms --wide $(OUTPUT)libbpf.so |		 \
 		    sed 's/\[.*\]//' |					 \
-		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
+		    awk '/GLOBAL/ && /DEFAULT/ && !/UND|ABS/ {print $$NF}'|  \
 		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
 		    sort -u > $(OUTPUT)libbpf_versioned_syms.tmp; 	 \
 		diff -u $(OUTPUT)libbpf_global_syms.tmp			 \


