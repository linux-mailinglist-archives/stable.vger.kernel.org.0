Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA48553B4C
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 22:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352707AbiFUUPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352453AbiFUUPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:15:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74E6E1FCCD
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 13:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655842528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k6Zlu2TJUdA3D4ZoIylfMpPObezxs5u+ojGXSNlUNOE=;
        b=AJSM5tvvt0LLvBpAF0yYXF4sdCzjqO3t7nqJ02EvjZx/d5O9buszrVgZ95kjGRWqtnK7gc
        Yp7yKZ0TAt1fT+5tCuPMB4kqqPsXPk3pBjGwGNYgYESHjrS0SAYt/RIcX41Z9tTf3f6QMI
        bpohM7U6Z9dQBjdKbIzN3fO5qQf7v88=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-pww_laTqPyOYaqZQaVADXA-1; Tue, 21 Jun 2022 16:15:27 -0400
X-MC-Unique: pww_laTqPyOYaqZQaVADXA-1
Received: by mail-ed1-f70.google.com with SMTP id z4-20020a05640240c400b004358a7d5a1dso4333022edb.2
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 13:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k6Zlu2TJUdA3D4ZoIylfMpPObezxs5u+ojGXSNlUNOE=;
        b=X7CQi7L4WzZq2CrqGamipLP8bAqCmsX7hlM/Gb7RdJNtKw+63HFwTVUByfh47Fot/v
         rDANMRfzzTHz3hvhwaOlQz2zmYPBrC2vQWSUGtw5hIqfjbzpLjnUgsP8cuK0dDzB8d5A
         beZwUuTI1RNDGlzdpIvg4lyecWBujWESQBIPqOLI2KZSR7r+cTh629XwsoQIU7HcdB22
         vMIgYHIExNH6MpZ7/EnoMuf51F1nfnDU+PhrcE0WA3H6lAWEBVzpvwqBBl4kwoQepeoc
         Ka34wcs2IoSZNprlkhIW7LDWFhIm+aZKTp/l+Tl6ihAQdvQjKJdvi1Z0laYKejW4w1ZE
         m1Cg==
X-Gm-Message-State: AJIora9CUk3R4y7pWUWlwFQqDJfN/8COdRFUmfbP4iQKXlQxEFPbHc5P
        z77xddte7c7i1Bv1zeH8pP1wAYuypkABOgAuEThfrSe8QcvOKZSR7jngOA3GdzrFuE+s61jlw6s
        CtxcOv0DpwZ8x6Krj
X-Received: by 2002:a17:907:6d24:b0:70c:81d9:d5b9 with SMTP id sa36-20020a1709076d2400b0070c81d9d5b9mr26617418ejc.597.1655842525380;
        Tue, 21 Jun 2022 13:15:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uhXqtk3GGtosxBxbOD/BwN3CcooG1PfjeK4JujOG7uSJ56sWUm97csD+zqDkqWoZ1sUWq2nA==
X-Received: by 2002:a17:907:6d24:b0:70c:81d9:d5b9 with SMTP id sa36-20020a1709076d2400b0070c81d9d5b9mr26617399ejc.597.1655842525054;
        Tue, 21 Jun 2022 13:15:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id cn25-20020a0564020cb900b0043578cf97d0sm7054751edb.23.2022.06.21.13.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 13:15:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2B2A640782F; Tue, 21 Jun 2022 22:15:03 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH 5.18 2/2] selftests/bpf: Add selftest for calling global functions from freplace
Date:   Tue, 21 Jun 2022 22:15:01 +0200
Message-Id: <20220621201501.112598-2-toke@redhat.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621201501.112598-1-toke@redhat.com>
References: <20220621201501.112598-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2cf7b7ffdae519b284f1406012b52e2282fa36bf upstream

Add a selftest that calls a global function with a context object parameter
from an freplace function to check that the program context type is
correctly converted to the freplace target when fetching the context type
from the kernel BTF.

v2:
- Trim includes
- Get rid of global function
- Use __noinline

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20220606075253.28422-2-toke@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c   | 14 ++++++++++++++
 .../selftests/bpf/progs/freplace_global_func.c | 18 ++++++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_global_func.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index d9aad15e0d24..02bb8cbf9194 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -395,6 +395,18 @@ static void test_func_map_prog_compatibility(void)
 				     "./test_attach_probe.o");
 }
 
+static void test_func_replace_global_func(void)
+{
+	const char *prog_name[] = {
+		"freplace/test_pkt_access",
+	};
+
+	test_fexit_bpf2bpf_common("./freplace_global_func.o",
+				  "./test_pkt_access.o",
+				  ARRAY_SIZE(prog_name),
+				  prog_name, false, NULL);
+}
+
 /* NOTE: affect other tests, must run in serial mode */
 void serial_test_fexit_bpf2bpf(void)
 {
@@ -416,4 +428,6 @@ void serial_test_fexit_bpf2bpf(void)
 		test_func_replace_multi();
 	if (test__start_subtest("fmod_ret_freplace"))
 		test_fmod_ret_freplace();
+	if (test__start_subtest("func_replace_global_func"))
+		test_func_replace_global_func();
 }
diff --git a/tools/testing/selftests/bpf/progs/freplace_global_func.c b/tools/testing/selftests/bpf/progs/freplace_global_func.c
new file mode 100644
index 000000000000..96cb61a6ce87
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/freplace_global_func.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+__noinline
+int test_ctx_global_func(struct __sk_buff *skb)
+{
+	volatile int retval = 1;
+	return retval;
+}
+
+SEC("freplace/test_pkt_access")
+int new_test_pkt_access(struct __sk_buff *skb)
+{
+	return test_ctx_global_func(skb);
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.36.1

