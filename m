Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60EA59A408
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353541AbiHSQie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353234AbiHSQgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:36:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3AF123093;
        Fri, 19 Aug 2022 09:07:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF9DFB82820;
        Fri, 19 Aug 2022 16:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD82EC433C1;
        Fri, 19 Aug 2022 16:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925236;
        bh=e25EplunFs+xhOssElaZHcLWfqW4P+ZY5UR2hRo+Ob0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5x6EQC82OBx9vBhOuBvjbNHmV9kyE+r6imHruH2+os4TaDi+mA1SkBa+Ko/8apTA
         KC1Jm26StT7QB6nl8QYcEC90NGR56ZWSiJoDIB6bAtAsZaBvtuwuje5JIqhMhtPaE0
         6pK5LQ/mgDjHDAvKryBYaZJHQ0ZEneu2tIxTu3HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E8=B0=AD=E6=A2=93=E7=85=8A?= <tanzixuan.me@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Nick Terrell <terrelln@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 427/545] genelf: Use HAVE_LIBCRYPTO_SUPPORT, not the never defined HAVE_LIBCRYPTO
Date:   Fri, 19 Aug 2022 17:43:17 +0200
Message-Id: <20220819153848.523952231@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 91cea6be90e436c55cde8770a15e4dac9d3032d0 ]

When genelf was introduced it tested for HAVE_LIBCRYPTO not
HAVE_LIBCRYPTO_SUPPORT, which is the define the feature test for openssl
defines, fix it.

This also adds disables the deprecation warning, someone has to fix this
to build with openssl 3.0 before the warning becomes a hard error.

Fixes: 9b07e27f88b9cd78 ("perf inject: Add jitdump mmap injection support")
Reported-by: 谭梓煊 <tanzixuan.me@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/YulpPqXSOG0Q4J1o@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/genelf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/genelf.c b/tools/perf/util/genelf.c
index aed49806a09b..953338b9e887 100644
--- a/tools/perf/util/genelf.c
+++ b/tools/perf/util/genelf.c
@@ -30,7 +30,11 @@
 
 #define BUILD_ID_URANDOM /* different uuid for each run */
 
-#ifdef HAVE_LIBCRYPTO
+// FIXME, remove this and fix the deprecation warnings before its removed and
+// We'll break for good here...
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+
+#ifdef HAVE_LIBCRYPTO_SUPPORT
 
 #define BUILD_ID_MD5
 #undef BUILD_ID_SHA	/* does not seem to work well when linked with Java */
-- 
2.35.1



