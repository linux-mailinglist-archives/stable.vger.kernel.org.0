Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6F427C74D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbgI2Lw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730026AbgI2LrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AEA520848;
        Tue, 29 Sep 2020 11:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380027;
        bh=6el3+1FgbNSy6Rd+VQN1BuhxVVFj08kb48nzNNe6ZrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8K3POXg4wNB03gZF43/ht8danTmtEwmx+rGMH9/LPekpE9ML1ravZW+AioBoVjFr
         Z9Kcb4bIdJ18thBYfs2JyZjwfuHRZyGeqzgsP+XpnD7wVa/BirXsEVg2Pz8oHKejut
         Wmu049svcee3veK7mkzn9f9jeAqvAhq0PaXD4EsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Ambardar <Tony.Ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 35/99] tools/libbpf: Avoid counting local symbols in ABI check
Date:   Tue, 29 Sep 2020 13:01:18 +0200
Message-Id: <20200929105931.461063397@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 746f534a4809e07f427f7d13d10f3a6a9641e5c3 ]

Encountered the following failure building libbpf from kernel 5.8.5 sources
with GCC 8.4.0 and binutils 2.34: (long paths shortened)

  Warning: Num of global symbols in sharedobjs/libbpf-in.o (234) does NOT
  match with num of versioned symbols in libbpf.so (236). Please make sure
  all LIBBPF_API symbols are versioned in libbpf.map.
#  --- libbpf_global_syms.tmp    2020-09-02 07:30:58.920084380 +0000
#  +++ libbpf_versioned_syms.tmp 2020-09-02 07:30:58.924084388 +0000
  @@ -1,3 +1,5 @@
  +_fini
  +_init
   bpf_btf_get_fd_by_id
   bpf_btf_get_next_id
   bpf_create_map
  make[4]: *** [Makefile:210: check_abi] Error 1

Investigation shows _fini and _init are actually local symbols counted
amongst global ones:

  $ readelf --dyn-syms --wide libbpf.so|head -10

  Symbol table '.dynsym' contains 343 entries:
     Num:    Value  Size Type    Bind   Vis      Ndx Name
       0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND
       1: 00004098     0 SECTION LOCAL  DEFAULT   11
       2: 00004098     8 FUNC    LOCAL  DEFAULT   11 _init@@LIBBPF_0.0.1
       3: 00023040     8 FUNC    LOCAL  DEFAULT   14 _fini@@LIBBPF_0.0.1
       4: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.4
       5: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.1
       6: 0000ffa4     8 FUNC    GLOBAL DEFAULT   12 bpf_object__find_map_by_offset@@LIBBPF_0.0.1

A previous commit filtered global symbols in sharedobjs/libbpf-in.o. Do the
same with the libbpf.so DSO for consistent comparison.

Fixes: 306b267cb3c4 ("libbpf: Verify versioned symbols")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200905214831.1565465-1-Tony.Ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -152,6 +152,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --
 			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
 			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
+			      awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
 
 CMD_TARGETS = $(LIB_TARGET) $(PC_FILE)
@@ -219,6 +220,7 @@ check_abi: $(OUTPUT)libbpf.so
 		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf --dyn-syms --wide $(OUTPUT)libbpf.so |		 \
+		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
 		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
 		    sort -u > $(OUTPUT)libbpf_versioned_syms.tmp; 	 \
 		diff -u $(OUTPUT)libbpf_global_syms.tmp			 \


