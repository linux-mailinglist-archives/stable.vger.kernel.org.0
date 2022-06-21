Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F15553B47
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 22:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237933AbiFUUOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiFUUOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:14:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6751D1CB2D
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 13:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655842437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=B5cOqYed6vEtU3pGIKA3AJFhOOPC3JpU4Y53gzfWLyM=;
        b=QmNENEHMnOAiuhWUAEcIpSyhfNRRW0ZA+9qJl8ptQrU0N6LqwYzbimoBKms9Ualz6Kae/F
        Vz7gqiw8WwQQAKs7wfi8/jqUhfkxsYJ5wFEc2A1b+D0ByRTz4+40sNVGOuA2hv9Epx854V
        CDI/yMBQ+pgDxdzCPe+ZYEpysKBffGc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-sGRzTzNNNT-Z5CMw0CX3qA-1; Tue, 21 Jun 2022 16:13:56 -0400
X-MC-Unique: sGRzTzNNNT-Z5CMw0CX3qA-1
Received: by mail-ej1-f72.google.com with SMTP id hq41-20020a1709073f2900b00722e5ad076cso1218389ejc.20
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 13:13:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B5cOqYed6vEtU3pGIKA3AJFhOOPC3JpU4Y53gzfWLyM=;
        b=AQzPuTtzY22+Po5BFPCY3onOMh3m7DVkZ6tHHwR/rMMiKxr/pBDzW/Ah8UOjAOA0RY
         LsRMY0cDzv833lHebIOgoD7wpoNfm5mUz96ShTdrm4nJOVfrShOoTIn6h3AwPbF6ROkX
         Tb+ojr8EoeVUXp8LRAoZQFaUogCWGkKZ/dyNpBqp19/GcDhlcfOdvbGiygZKfLed+EIv
         3TrlckQ9IxYeiegacx4tjX+Mle2xShSIf6MyQEUMRKtI5Iy1XVueQCq8Yr9qgZms8kR0
         mSSEdDk1kqG+Ak9enCC+bYkPtx+AfeM514Qf0rvU9YKLQ0Hjq0IdWP7aV3qybs4TwJgH
         yJAg==
X-Gm-Message-State: AJIora+il8WpQFxrjHElfR8LRfYCsn2RTF9AW79eddFfswLkiD2s0Zwp
        stz2eY1gGmpZxUPDzXJrMXGkoPvT3zsIF2JGMW7fVYY6/mX4iqLcpx2+2Ueg6Eat5DyjAm8m3hR
        OEMWlu1F/Om3vf2hu
X-Received: by 2002:a17:907:3e8c:b0:712:c6d:46df with SMTP id hs12-20020a1709073e8c00b007120c6d46dfmr13016989ejc.314.1655842434888;
        Tue, 21 Jun 2022 13:13:54 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vOM9D1UI55sIrJJz4JmOTFxL6CX0hFxNTBQTt2R4p8im3MDTPIrDh/grMU5KQHsTJKQNrOLw==
X-Received: by 2002:a17:907:3e8c:b0:712:c6d:46df with SMTP id hs12-20020a1709073e8c00b007120c6d46dfmr13016971ejc.314.1655842434530;
        Tue, 21 Jun 2022 13:13:54 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z21-20020aa7d415000000b0043566884333sm10085963edq.63.2022.06.21.13.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 13:13:52 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0658E407826; Tue, 21 Jun 2022 22:13:52 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Simon Sundberg <simon.sundberg@kau.se>
Subject: [PATCH 5.15 1/2] bpf: Fix calling global functions from BPF_PROG_TYPE_EXT programs
Date:   Tue, 21 Jun 2022 22:13:44 +0200
Message-Id: <20220621201345.112137-1-toke@redhat.com>
X-Mailer: git-send-email 2.36.1
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

commit f858c2b2ca04fc7ead291821a793638ae120c11d upstream

The verifier allows programs to call global functions as long as their
argument types match, using BTF to check the function arguments. One of the
allowed argument types to such global functions is PTR_TO_CTX; however the
check for this fails on BPF_PROG_TYPE_EXT functions because the verifier
uses the wrong type to fetch the vmlinux BTF ID for the program context
type. This failure is seen when an XDP program is loaded using
libxdp (which loads it as BPF_PROG_TYPE_EXT and attaches it to a global XDP
type program).

Fix the issue by passing in the target program type instead of the
BPF_PROG_TYPE_EXT type to bpf_prog_get_ctx() when checking function
argument compatibility.

The first Fixes tag refers to the latest commit that touched the code in
question, while the second one points to the code that first introduced
the global function call verification.

v2:
- Use resolve_prog_type()

Fixes: 3363bd0cfbb8 ("bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM argument support")
Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
Reported-by: Simon Sundberg <simon.sundberg@kau.se>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20220606075253.28422-1-toke@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ backport: open-code missing resolve_prog_type() helper, resolve context diff ]
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/btf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 40df35088cdb..3cfba41a0829 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5441,6 +5441,8 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    struct bpf_reg_state *regs,
 				    bool ptr_to_mem_ok)
 {
+	enum bpf_prog_type prog_type = env->prog->type == BPF_PROG_TYPE_EXT ?
+		env->prog->aux->dst_prog->type : env->prog->type;
 	struct bpf_verifier_log *log = &env->log;
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
@@ -5533,8 +5535,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 					reg_ref_tname);
 				return -EINVAL;
 			}
-		} else if (btf_get_prog_ctx_type(log, btf, t,
-						 env->prog->type, i)) {
+		} else if (btf_get_prog_ctx_type(log, btf, t, prog_type, i)) {
 			/* If function expects ctx type in BTF check that caller
 			 * is passing PTR_TO_CTX.
 			 */
-- 
2.36.1

