Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758D75511BA
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239471AbiFTHo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238584AbiFTHo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 03:44:57 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29653FD19
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 00:44:54 -0700 (PDT)
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220620074449epoutp04da5eda991f24389f7b071592a5b41d08~6RHbICvfY3072330723epoutp04Z
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 07:44:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220620074449epoutp04da5eda991f24389f7b071592a5b41d08~6RHbICvfY3072330723epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1655711090;
        bh=h74OKRkrsil4uJbRuqVKc9EK1AtgoMhPLIW9LShca70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuLfR5TJwsXjH9TT9jZUk3Sp2ygMGEWzOeM7KR4ytN5QQH3228//mdNEBuh6M9TXl
         JdpyZfMh8ZktrvTgCKLQctw8mRlkFje53YkTSuomgxNs0alPXJRSgjLVSzm0vTJgm/
         7a+luf/bU/q96kfGzJ6pPeKybLT9J696TL7GoNXA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20220620074449epcas1p3e6135f4465572da9807f038eb197fa72~6RHa3u-N31759417594epcas1p3B;
        Mon, 20 Jun 2022 07:44:49 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.38.232]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LRM9r3Wpyz4x9QC; Mon, 20 Jun
        2022 07:44:48 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.7C.09657.F6520B26; Mon, 20 Jun 2022 16:44:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20220620074447epcas1p3f8283939958ab1ad3c9429234f09d4c5~6RHYt6r9W0945709457epcas1p3D;
        Mon, 20 Jun 2022 07:44:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220620074447epsmtrp208fff5461e2992aa81e05246c8b9027c~6RHYtMCmR0581205812epsmtrp2x;
        Mon, 20 Jun 2022 07:44:47 +0000 (GMT)
X-AuditID: b6c32a35-f4312a80000025b9-2b-62b0256fe2bf
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        18.75.08802.F6520B26; Mon, 20 Jun 2022 16:44:47 +0900 (KST)
Received: from localhost.localdomain (unknown [10.113.113.58]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220620074447epsmtip20fe6340853619db264be35cbf85b6c17~6RHYiY8141596715967epsmtip2y;
        Mon, 20 Jun 2022 07:44:47 +0000 (GMT)
From:   Jiho Chu <jiho.chu@samsung.com>
To:     jiho.chu@samsung.com
Cc:     Julian Orth <ju.orth@gmail.com>, stable@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 1/5] audit,io_uring,io-wq: call __audit_uring_exit for dummy
 contexts
Date:   Mon, 20 Jun 2022 16:44:40 +0900
Message-Id: <20220620074444.504674-2-jiho.chu@samsung.com>
In-Reply-To: <20220620074444.504674-1-jiho.chu@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsWy7bCmnm6+6oYkg3fT1Szed+9mtnh5p4HR
        4vak6SwWCzY+YnRg8dg56y67x9q9Lxg9+rasYvT4vEkugCUq2yYjNTEltUghNS85PyUzL91W
        yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ386mKL+0JFUh
        I7+4xFYptSAlp8C0QK84Mbe4NC9dLy+1xMrQwMDIFKgwITtj24X1jAUTBCruLONsYJzN28XI
        ySEhYCLx9+J39i5GLg4hgR2MEtOP3meCcD4xSnQuusEI4XxmlPh2vYWti5EDrOXDYkGI+C5G
        iSObJ7LCFV1+/YURZC6bgKrEzBlr2EFsEQEJiZ/v/jGB2MwC8RKbX09hA7GFBcIlenZMYQWx
        WYDqF/Y+BKvhFbCS2NpxnxnE5hSwlrh/ez4rRFxQ4uTMJywQc+QlmrfOZgZZLCGwj11i/pLZ
        LBAPuUjcerSPDcIWlnh1fAs7hC0l8fndXqi4j8Sqw79ZIb5JkPgyjQ/CNJa4uCIFxGQW0JRY
        v0sfolhRYufvuYwQW/kk3n3tgWrklehoE4IoUZJY8ucw1B4JiakzvjFB2B4Svy/chgZuH6PE
        5zu7WCYwys9C8swsJM/MQti8gJF5FaNYakFxbnpqsWGBITxKk/NzNzGC05yW6Q7GiW8/6B1i
        ZOJgPMQowcGsJMJrw70hSYg3JbGyKrUoP76oNCe1+BCjKTB4JzJLiSbnAxNtXkm8oYmlgYmZ
        kbGJhaGZoZI476pppxOFBNITS1KzU1MLUotg+pg4OKUamDw4Bbc1R4rqX1qsd73ritJXRruf
        Td+XJDzTC8qr8Dqfw2nxtSNiU85zEyuzfI43lms8Ag5mZx3j2Ri+If1KrswJoVUzf87ya1l2
        4PfJ40xGqW61t2es5nqr2seltWJLA4dIZ+2y9K9aTwwuvdxRGWpmoymyTXW3tPLVgLhqvYdf
        5fZlX5vOqvtT+frsZSzH9OMS/+RmGsvz3/W8saCD+95due7p6Ta1ibPsw9pPKB+y7fystm/S
        PLHi3k8XDy/W2vFdPfDC18j0VVtvzrW8l7jYXKRs/dcfx6Ujzk08bMq+fdWkRJ+1EzyPnT4j
        kC//5nz0Ma6st7J7Q/0WRGi5SXlGL1BhtzGeIXCnPdK9VImlOCPRUIu5qDgRAPSB/7P8AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsWy7bCSvG6+6oYkg8W7BC3ed+9mtnh5p4HR
        4vak6SwWCzY+YnRg8dg56y67x9q9Lxg9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2PbhfWM
        BRMEKu4s42xgnM3bxcjBISFgIvFhsWAXIxeHkMAORolbT1awdDFyAsUlJDbdW84MUSMscfhw
        MUhYSOAjo8Tvd/YgNpuAqsTMGWvYQWwRoPKf7/4xgdjMAokSL79sYQOxhQVCJb4v+QpWwwJU
        v7D3IVgNr4CVxNaO+8wgNqeAtcT92/NZIeZbSSzrfs4MUSMocXLmExaImfISzVtnM09g5J+F
        JDULSWoBI9MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgcNTS2sG4Z9UHvUOMTByM
        hxglOJiVRHhtuDckCfGmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbL
        xMEp1cC073Q5lw3z6V3FhrdL7qu/Y+BgDP4V+i0gMCTZK7v2ezcP3+EZXhHf9Fom3N+98v5+
        +xaJ1fFfuzqFNgSnz9O/KnnR2sDK+MnyIwa6hmumXFlpbrdBp+ZTVJqL2hFeC7X9Ni3xPdtF
        CpOcNy21epN48GXBXd/tv9Zn95kK5S5jiHE5+iub2Sg67OOa8km1RnFvv/hzhDZGrbwU7bj+
        8p5/jteXq85Jnv5HXMCjge++J48Xn/H5BWdbTP/aLeg1XFBxJGP+0TPzJpatr7qsepanmOVh
        EmPVGZUEvb+rpz3hczsYPzWP1WaCq8+phJ1LT1R3nuYxcM/Nz2n3vKlxz0vTMO9u/fWyh/8X
        lJuXvlFiKc5INNRiLipOBAAgO/h2tgIAAA==
X-CMS-MailID: 20220620074447epcas1p3f8283939958ab1ad3c9429234f09d4c5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220620074447epcas1p3f8283939958ab1ad3c9429234f09d4c5
References: <20220620074444.504674-1-jiho.chu@samsung.com>
        <CGME20220620074447epcas1p3f8283939958ab1ad3c9429234f09d4c5@epcas1p3.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Orth <ju.orth@gmail.com>

Not calling the function for dummy contexts will cause the context to
not be reset. During the next syscall, this will cause an error in
__audit_syscall_entry:

	WARN_ON(context->context != AUDIT_CTX_UNUSED);
	WARN_ON(context->name_count);
	if (context->context != AUDIT_CTX_UNUSED || context->name_count) {
		audit_panic("unrecoverable error in audit_syscall_entry()");
		return;
	}

These problematic dummy contexts are created via the following call
chain:

       exit_to_user_mode_prepare
    -> arch_do_signal_or_restart
    -> get_signal
    -> task_work_run
    -> tctx_task_work
    -> io_req_task_submit
    -> io_issue_sqe
    -> audit_uring_entry

Cc: stable@vger.kernel.org
Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
Signed-off-by: Julian Orth <ju.orth@gmail.com>
[PM: subject line tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 include/linux/audit.h | 2 +-
 kernel/auditsc.c      | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index d06134ac6245..cece70231138 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -339,7 +339,7 @@ static inline void audit_uring_entry(u8 op)
 }
 static inline void audit_uring_exit(int success, long code)
 {
-	if (unlikely(!audit_dummy_context()))
+	if (unlikely(audit_context()))
 		__audit_uring_exit(success, code);
 }
 static inline void audit_syscall_entry(int major, unsigned long a0,
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index ea2ee1181921..f3a2abd6d1a1 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1959,6 +1959,12 @@ void __audit_uring_exit(int success, long code)
 {
 	struct audit_context *ctx = audit_context();
 
+	if (ctx->dummy) {
+		if (ctx->context != AUDIT_CTX_URING)
+			return;
+		goto out;
+	}
+
 	if (ctx->context == AUDIT_CTX_SYSCALL) {
 		/*
 		 * NOTE: See the note in __audit_uring_entry() about the case
-- 
2.25.1

