Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369BF6AEECF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbjCGSQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbjCGSQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:16:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3494A568D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:11:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3A21B819BF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5D0C433D2;
        Tue,  7 Mar 2023 18:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212674;
        bh=tpWQ3pQ0YRv95/CN5dI+MV41MpEypJwHkvMGlvUE/e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXw++bKdbYU3XUc9KT5PtTc7DJG42US93IzUrTL1P2qGNTTk7gZq9s7Me6oqXgYIJ
         UwX/HtbzYVCoWO9x7acPn3PoYI0uoKKPoQEQRJCF2yIARjCSQrB08h2RxloMsQkaU/
         Op94u9gR2MiXSjs5sVZOrTQ95XG8ObiiWU74QsYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 243/885] selftests/bpf: Fix map_kptr test.
Date:   Tue,  7 Mar 2023 17:52:57 +0100
Message-Id: <20230307170012.580474372@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 62d101d5f422cde39b269f7eb4cbbe2f1e26f9d4 ]

The compiler is optimizing out majority of unref_ptr read/writes, so the test
wasn't testing much. For example, one could delete '__kptr' tag from
'struct prog_test_ref_kfunc __kptr *unref_ptr;' and the test would still "pass".

Convert it to volatile stores. Confirmed by comparing bpf asm before/after.

Fixes: 2cbc469a6fc3 ("selftests/bpf: Add C tests for kptr")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20230214235051.22938-1-alexei.starovoitov@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/map_kptr.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/map_kptr.c b/tools/testing/selftests/bpf/progs/map_kptr.c
index eb82178034934..228ec45365a8d 100644
--- a/tools/testing/selftests/bpf/progs/map_kptr.c
+++ b/tools/testing/selftests/bpf/progs/map_kptr.c
@@ -62,21 +62,23 @@ extern struct prog_test_ref_kfunc *
 bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **p, int a, int b) __ksym;
 extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
 
+#define WRITE_ONCE(x, val) ((*(volatile typeof(x) *) &(x)) = (val))
+
 static void test_kptr_unref(struct map_value *v)
 {
 	struct prog_test_ref_kfunc *p;
 
 	p = v->unref_ptr;
 	/* store untrusted_ptr_or_null_ */
-	v->unref_ptr = p;
+	WRITE_ONCE(v->unref_ptr, p);
 	if (!p)
 		return;
 	if (p->a + p->b > 100)
 		return;
 	/* store untrusted_ptr_ */
-	v->unref_ptr = p;
+	WRITE_ONCE(v->unref_ptr, p);
 	/* store NULL */
-	v->unref_ptr = NULL;
+	WRITE_ONCE(v->unref_ptr, NULL);
 }
 
 static void test_kptr_ref(struct map_value *v)
@@ -85,7 +87,7 @@ static void test_kptr_ref(struct map_value *v)
 
 	p = v->ref_ptr;
 	/* store ptr_or_null_ */
-	v->unref_ptr = p;
+	WRITE_ONCE(v->unref_ptr, p);
 	if (!p)
 		return;
 	if (p->a + p->b > 100)
@@ -99,7 +101,7 @@ static void test_kptr_ref(struct map_value *v)
 		return;
 	}
 	/* store ptr_ */
-	v->unref_ptr = p;
+	WRITE_ONCE(v->unref_ptr, p);
 	bpf_kfunc_call_test_release(p);
 
 	p = bpf_kfunc_call_test_acquire(&(unsigned long){0});
-- 
2.39.2



