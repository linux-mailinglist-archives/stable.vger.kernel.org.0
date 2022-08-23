Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150D159E06D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244969AbiHWLh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245319AbiHWLfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:35:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AEEC6E8C;
        Tue, 23 Aug 2022 02:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84FF661227;
        Tue, 23 Aug 2022 09:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445A6C433D6;
        Tue, 23 Aug 2022 09:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246848;
        bh=3PkGHcka/DfFwtOsUWVB+ZlnkYOjRyZCig8SvtQSvBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xihmgdn3ahcWHcXVdfnkFPnZnQbxQ47MHxR21DDlGQkc9zXEwuHZxrtqbt7AcJm3m
         RkCVH6ezJzzQUoEhJjgdW1TeFo8olb0Oef1zAX/ucqKQiqLRKUw+raf0Zx7GCDgLqk
         Z1X8a21oaM5YVhSfMhB4LGM7Cr/ENzWUcGw+mY2E=
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
Subject: [PATCH 5.4 240/389] genelf: Use HAVE_LIBCRYPTO_SUPPORT, not the never defined HAVE_LIBCRYPTO
Date:   Tue, 23 Aug 2022 10:25:18 +0200
Message-Id: <20220823080125.588289313@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index f9f18b8b1df9..17b74aba8b9a 100644
--- a/tools/perf/util/genelf.c
+++ b/tools/perf/util/genelf.c
@@ -35,7 +35,11 @@
 
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



